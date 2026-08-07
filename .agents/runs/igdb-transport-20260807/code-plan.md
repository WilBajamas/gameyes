# Code Plan
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07

## CREATE NEW

### lib/core/services/supabase/igdb_proxy_service.dart

```dart
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:retrofit/retrofit.dart';

part 'igdb_proxy_service.g.dart';

// No base url here on purpose - the host is the flavour's own Supabase
// project, so it can only be known once the app is running.
@RestApi()
abstract class IgdbProxyService {
  factory IgdbProxyService(Dio dio) = _IgdbProxyService;

  @POST(SupabaseIgdbProxyConstants.functionPath)
  Future<Object?> invoke(@Body() Map<String, String> body);
}
```

### lib/core/services/supabase/igdb_proxy_auth_interceptor.dart

```dart
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Signs every igdb-proxy call as the person using the app, and gives a
/// rejected call one more try with a fresh sign-in token.
class IgdbProxyAuthInterceptor extends Interceptor {
  IgdbProxyAuthInterceptor({
    required GoTrueClient auth,
    required String anonKey,
    required Dio dio,
  }) : _auth = auth,
       _anonKey = anonKey,
       _dio = dio;

  // Marks a call we have already tried again, so one rejection can never
  // turn into an endless chain of retries.
  static const _replayedKey = 'igdb_proxy_replayed';

  final GoTrueClient _auth;
  final String _anonKey;
  final Dio _dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Read fresh every time - the token changes while the app is running.
    // With nobody signed in the anon key stands in, which is what the
    // Supabase SDK sends today.
    final token = _auth.currentSession?.accessToken ?? _anonKey;
    options.headers['Authorization'] = 'Bearer $token';
    options.headers['apikey'] = _anonKey;
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final alreadyReplayed = options.extra[_replayedKey] == true;

    if (err.response?.statusCode != 401 || alreadyReplayed) {
      return handler.next(err);
    }

    try {
      final refreshed = await _auth.refreshSession();
      if (refreshed.session == null) return handler.next(err);
    } catch (_) {
      // A refresh we cannot do is not a better answer than the rejection
      // the caller already has.
      return handler.next(err);
    }

    options.extra[_replayedKey] = true;
    try {
      // Back through this same interceptor, which picks up the new token
      // in onRequest.
      handler.resolve(await _dio.fetch<Object?>(options));
    } on DioException catch (replayError) {
      handler.next(replayError);
    }
  }
}
```

### lib/core/di/igdb_proxy_module.dart

```dart
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_proxy_auth_interceptor.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_proxy_service.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class IgdbProxyModule {
  // Built at startup, so a build with no flavour set up fails here rather
  // than the first time somebody opens a game list.
  @singleton
  IgdbProxyService igdbProxyService(SupabaseClient supabase) {
    final config = FlavorConfig.instance;
    final baseUrl =
        '${config.supabaseUrl}${SupabaseIgdbProxyConstants.functionsBasePath}';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ConfigConstants.connectTimeout,
        receiveTimeout: ConfigConstants.receiveTimeout,
        sendTimeout: ConfigConstants.sendTimeout,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(
      IgdbProxyAuthInterceptor(
        auth: supabase.auth,
        anonKey: config.supabaseAnonKey,
        dio: dio,
      ),
    );

    return IgdbProxyService(dio);
  }
}
```

## MODIFY EXISTING

### lib/core/services/supabase/supabase_igdb_client.dart

```dart
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_call_log.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_proxy_service.dart';
import 'package:injectable/injectable.dart';

// the client we use to communicate with supabase
// querying and retrieving data from it
@injectable
class SupabaseIgdbClient {
  const SupabaseIgdbClient(this._service);

  final IgdbProxyService _service;

  Future<Object?> invoke({
    required String endpoint,
    required String query,
  }) async {
    IgdbCallLog.request(endpoint: endpoint, query: query);
    try {
      final body = await _service.invoke({
        'endpoint': endpoint,
        'query': query,
      });

      IgdbCallLog.response(body);
      return body;
    } catch (error, stackTrace) {
      IgdbCallLog.failure(error, stackTrace);
      rethrow;
    }
  }
}
```

Gone from this file: the `supabase_flutter` and `core/res/const.dart` imports,
the `SupabaseClient` field, `_client.functions.invoke(...)` and the
`.timeout(SupabaseIgdbProxyConstants.requestTimeout)` chain.

### lib/core/res/const.dart

```dart
class SupabaseIgdbProxyConstants {
  static const functionsBasePath = '/functions/v1';
  static const functionPath = '/igdb-proxy';
  static const gamesEndpoint = 'games';
  static const releaseDatesEndpoint = 'release_dates';

  // How much of a response body is worth reading in the console.
  static const maxLogBodyLines = 50;
}
```

`functionName` is renamed to `functionPath` and `requestTimeout` is deleted; the
Dio instance owns the deadline now. Every other class in this file is untouched.

### test/mocks/auth_mock.dart

```dart
// ... mockDiscordSession stays exactly as it is, this is added below it

Session get mockRefreshedDiscordSession => Session(
      accessToken: 'discord-access-token-refreshed',
      tokenType: 'bearer',
      refreshToken: 'discord-refresh-token-2',
      expiresIn: 3600,
      user: mockDiscordUser,
    );
```

## TEST FILES

### test/api/supabase/supabase_igdb_client_test.dart

`@GenerateMocks([HttpClientAdapter])`. A `Dio` with
`baseUrl: 'https://test-project.supabase.co/functions/v1'` and the mock adapter
in place, wrapped in `IgdbProxyService`, wrapped in `SupabaseIgdbClient`. No
interceptor — auth is the other file's job. Responses come from a small helper
that returns `ResponseBody.fromString(jsonEncode(body), status, headers: {json
content type})`, and the request is read back off the `RequestOptions` mockito
captures.

- `'should post to the igdb-proxy function url when invoke is called'` — the
  captured request is a `POST` to
  `https://test-project.supabase.co/functions/v1/igdb-proxy`. (AC-1, AC-2)
- `'should send only the endpoint and query keys in the body'` — the captured
  body equals `{'endpoint': 'games', 'query': 'fields name;'}` and has exactly
  two keys. (AC-1)
- `'should send a json content type'` — the captured content-type header is
  `application/json`. (AC-1)
- `'should not send anything to an igdb host'` — the captured request host is the
  Supabase one, and the url contains no `api.igdb.com`. (AC-3)
- `'should return the decoded list when the proxy answers 200'` — the result is a
  `List` whose first entry is the `Map` from the response body, not a string and
  not a wrapper. (AC-14)
- `'should throw the error with its status when the proxy answers 400'` — a
  `DioException` escapes `invoke`, carrying status 400 and the proxy's
  `{'error': ...}` body. (AC-1 failure case, AC-15)
- `'should throw rather than return null when the proxy answers 502'` — the
  exception reaches the caller with status 502. (AC-15)

### test/api/supabase/igdb_proxy_auth_interceptor_test.dart

`@GenerateMocks([HttpClientAdapter, GoTrueClient])`. A `Dio` with the mock adapter
and one `IgdbProxyAuthInterceptor(auth: mockAuth, anonKey: 'test-anon-key', dio:
dio)`, driven with `dio.post(SupabaseIgdbProxyConstants.functionPath, data: ...)`.
Sessions come from `test/mocks/auth_mock.dart`.

- `'should send the session token and the anon key when somebody is signed in'` —
  `Authorization: Bearer discord-access-token` and `apikey: test-anon-key`.
  (AC-7)
- `'should use the newer token when the session changed between calls'` — the
  stubbed `currentSession` returns two different sessions; the second request
  carries the second token. (AC-8)
- `'should send the anon key as the bearer token when nobody is signed in'` —
  `currentSession` is null, `Authorization: Bearer test-anon-key`, `apikey` still
  set. (AC-9)
- `'should refresh and try again once when the proxy answers 401'` — first
  response 401, second 200; `refreshSession` called once; the caller gets the 200
  body and no error; the second request carries the refreshed token. (AC-10)
- `'should make exactly two requests when the second answer is also 401'` —
  `verify(adapter.fetch(...)).called(2)`, `refreshSession` called once, and the
  401 escapes. (AC-11)
- `'should surface the original 401 when the refresh throws'` — `refreshSession`
  throws; one request only; the error carries status 401. (AC-12)
- `'should surface the original 401 when the refresh returns no session'` —
  `refreshSession` answers `AuthResponse(session: null)`; one request only;
  status 401. (AC-12)
- `'should not try again when the proxy answers 502'` — one request,
  `verifyNever(auth.refreshSession())`, error carries status 502. (AC-13)
- `'should not try again when the request fails without a response'` — a
  connection error; one request; no refresh. (AC-13)

### Unchanged test files

`test/api/supabase/igdb_call_log_test.dart` already covers the 50-line cap, the
exactly-50 boundary and the cut-short note, and `IgdbCallLog` is not being
touched — so AC-22 is met with no edit. `test/api/games/games_test.dart`,
`test/api/game_detail/game_detail_test.dart` and the featured repository tests
mock `SupabaseIgdbClient` itself and must pass unedited (AC-23).

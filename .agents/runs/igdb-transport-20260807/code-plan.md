# Code Plan
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07
Revised: 2026-08-07 — Phase 3 human feedback applied inline below; the full
change list is in `## Approved feedback delta` at the end, which is authoritative
on any conflict with `task-brief.md`.

## MODIFY EXISTING — pubspec.yaml

```yaml
  # Logging
  logger: ^2.7.0
  talker_flutter: ^5.1.16
  talker_dio_logger: ^5.1.16
```

One added line, then `flutter pub get`. `^5.1.16` keeps it on the same talker
5.1.x line the lockfile already resolves (`talker 5.1.20`,
`talker_flutter 5.1.18`). Nothing else in the file moves.

## CREATE NEW

### lib/core/services/supabase/supabase_igdb_proxy_service.dart

```dart
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:retrofit/retrofit.dart';

part 'supabase_igdb_proxy_service.g.dart';

// No base url here on purpose - the host is the flavour's own Supabase
// project, so it can only be known once the app is running.
@RestApi()
abstract class SupabaseIgdbProxyService {
  factory SupabaseIgdbProxyService(Dio dio) = _SupabaseIgdbProxyService;

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
import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_proxy_auth_interceptor.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

@module
abstract class IgdbProxyModule {
  // Built at startup, so a build with no flavour set up fails here rather
  // than the first time somebody opens a game list.
  @singleton
  SupabaseIgdbProxyService supabaseIgdbProxyService(SupabaseClient supabase) {
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

    // Added only for a developer running the dev build, so nothing is ever
    // printed in release or on prod. Defaults are left alone - they keep
    // request headers, and so the sign-in token, out of the console.
    // History is off because nothing in the app can show it.
    if (kDebugMode && config.flavor == Flavor.dev) {
      dio.interceptors.add(
        TalkerDioLogger(
          talker: Talker(settings: TalkerSettings(useHistory: false)),
        ),
      );
    }

    return SupabaseIgdbProxyService(dio);
  }
}
```

## MODIFY EXISTING

### lib/core/services/supabase/supabase_igdb_client.dart

```dart
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:injectable/injectable.dart';

// the client we use to communicate with supabase
// querying and retrieving data from it
@injectable
class SupabaseIgdbClient {
  const SupabaseIgdbClient(this._service);

  final SupabaseIgdbProxyService _service;

  Future<Object?> invoke({
    required String endpoint,
    required String query,
  }) => _service.invoke({'endpoint': endpoint, 'query': query});
}
```

Gone from this file: the `supabase_flutter`, `core/res/const.dart` and
`igdb_call_log.dart` imports, the `SupabaseClient` field,
`_client.functions.invoke(...)`, the `.timeout(...)` chain, the three
`IgdbCallLog` calls, and the `try`/`catch`/`rethrow` that only wrapped them.
Errors now propagate because nothing touches them.

### lib/core/res/const.dart

```dart
class SupabaseIgdbProxyConstants {
  static const functionsBasePath = '/functions/v1';
  static const functionPath = '/igdb-proxy';
  static const gamesEndpoint = 'games';
  static const releaseDatesEndpoint = 'release_dates';
}
```

`functionName` is renamed to `functionPath`; `requestTimeout` goes because the
Dio instance owns the deadline now, and `maxLogBodyLines` goes with the trim it
sized. Every other class in this file is untouched.

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

## DELETE

### lib/core/services/supabase/igdb_call_log.dart
Whole file. `TalkerDioLogger` takes over. Nothing else imports it once
`supabase_igdb_client.dart` is updated.

### test/api/supabase/igdb_call_log_test.dart
Whole file, all 4 tests. They exercise `IgdbCallLog.trimToLineCap`, which no
longer exists. Nothing is ported.

## TEST FILES

### test/api/supabase/supabase_igdb_client_test.dart

`@GenerateMocks([HttpClientAdapter])`. A `Dio` with
`baseUrl: 'https://test-project.supabase.co/functions/v1'` and the mock adapter
in place, wrapped in `SupabaseIgdbProxyService`, wrapped in `SupabaseIgdbClient`.
No interceptor — auth is the other file's job. Responses come from a small helper
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

`test/api/games/games_test.dart`, `test/api/game_detail/game_detail_test.dart`
and the featured repository tests mock `SupabaseIgdbClient` itself and must pass
unedited (AC-23). No test covers the logger — it is a third-party interceptor
behind a build-mode gate, with nothing of ours to assert.

## Approved feedback delta

Approved by the human at the Phase 3 gate on 2026-08-07. Authoritative wherever
it conflicts with anything above or with `task-brief.md`.

**1. `talker_dio_logger` is adopted; `IgdbCallLog` is deleted.**
- `pubspec.yaml` gains exactly one line, `talker_dio_logger: ^5.1.16`, in the
  `# Logging` block; `flutter pub get` follows and its `pubspec.lock` change is
  committed. Approved one-off deviation from the read-only-`pubspec.yaml` rule,
  this run only. No other constraint moves — if resolution needs one, escalate.
- `lib/core/services/supabase/igdb_call_log.dart` and
  `test/api/supabase/igdb_call_log_test.dart` are both deleted outright. Nothing
  is ported, and no hand-written logging replaces them.
- `TalkerDioLogger` is added to the new `igdb-proxy` Dio inside
  `IgdbProxyModule`, after `IgdbProxyAuthInterceptor`. That order means a 401 the
  replay rescues is logged as the success it became, not as an error, and the
  logger sees the replay as its own second request.
- `TalkerDioLoggerSettings` is left entirely at defaults. Worth knowing why that
  is safe as well as cheap: `printRequestHeaders` defaults to `false`, so the
  `Authorization` bearer token never reaches the console. Do not enable it.
- The logger is given `talker: Talker(settings: TalkerSettings(useHistory:
  false))` — the same choice `IgdbCallLog` made, since nothing in the app can
  display log history. This also keeps `talker_flutter` a used direct dependency
  after the deletion.
- **AC-17 gate:** achieved at registration, not through settings — the
  `dio.interceptors.add(TalkerDioLogger(...))` call sits inside
  `if (kDebugMode && config.flavor == Flavor.dev)`, the same condition
  `IgdbCallLog._isOn` used. Release and prod builds construct no logger at all.
- **Accepted losses, confirmed by the human:** the 50-line response trim with its
  omitted-line count, and the caller's own stack trace on failure. Neither is
  reproduced. AC-16 is met to the extent `TalkerDioLogger`'s defaults meet it —
  endpoint and query still appear (as the logged request body), failures still
  log with an error and a stack trace.
- **AC-22 is superseded, not failed.** It protected the trim's test coverage; the
  trim no longer exists, so there is nothing to cover and no replacement test is
  written. QA should mark it N/A with this line as the reason.
- **AC-18 residual, flagged not fixed:** with the gate closed (release, prod)
  nothing can throw because no logging runs. In a debug dev build it now rests on
  `TalkerDioLogger` itself, where `IgdbCallLog._write` used to swallow its own
  failures. We do not wrap the third-party interceptor to restore that.
- **Test-count effect:** deleting `igdb_call_log_test.dart` removes 4 passing
  tests, so the recorded `Test baseline: +209` legitimately drops by 4 before
  this task's new tests are added. Not a regression.

**2. `IgdbProxyService` is renamed to `SupabaseIgdbProxyService`.**
- Class `IgdbProxyService` → `SupabaseIgdbProxyService`; generated impl
  `_IgdbProxyService` → `_SupabaseIgdbProxyService`.
- File `lib/core/services/supabase/igdb_proxy_service.dart` →
  `lib/core/services/supabase/supabase_igdb_proxy_service.dart`; the `part`
  directive and the generated output become `supabase_igdb_proxy_service.g.dart`.
- `IgdbProxyModule`'s provider returns `SupabaseIgdbProxyService`; the method is
  named `supabaseIgdbProxyService`. `SupabaseIgdbClient`'s field type follows.
- Only this class is renamed. `IgdbProxyAuthInterceptor`,
  `igdb_proxy_auth_interceptor.dart`, `IgdbProxyModule` and
  `igdb_proxy_module.dart` keep the names they already have.
- `tdd.md` and `task-brief.md` were updated in place for this rename and for the
  deletion above, because the Dev Agent's file-allowlist check in
  `.claude/pipeline/rules/git.md` reads `task-brief.md` literally.

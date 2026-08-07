# Code Plan
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07
Revised: 2026-08-07, twice — Phase 3 human feedback applied inline below; the full
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

The three API services call this as
`invoke({'endpoint': …, 'query': …})`. Retrofit takes the whole request body as
one `@Body()` argument, so the two named arguments the deleted
`SupabaseIgdbClient` accepted cannot be kept here.

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

### lib/features/games/services/games_api_service.dart

```dart
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:injectable/injectable.dart';

// the "games" feature api service
@injectable
class GamesApiService {
  const GamesApiService(this._proxy);

  final SupabaseIgdbProxyService _proxy;

  // fetchGames and fetchReleaseDates are unchanged

  // reusable function - both functions above share the same shape
  Future<List<T>> _decodeList<T>({
    required String endpoint,
    required String query,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final body = await _proxy.invoke({'endpoint': endpoint, 'query': query});

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }
}
```

Three lines move: the import, the field, and the `invoke` call. Everything else in
the file — the header comment, `@injectable`, the `const` constructor,
`fetchGames`, `fetchReleaseDates`, the guard and the mapping — stays byte for
byte.

### lib/features/game_detail/services/game_detail_api_service.dart

```dart
// import swaps to supabase_igdb_proxy_service.dart

@injectable
class GameDetailApiService {
  const GameDetailApiService(this._proxy);

  final SupabaseIgdbProxyService _proxy;

  Future<List<GameDetailModel>> fetchGameDetail(String query) async {
    final body = await _proxy.invoke({
      'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
      'query': query,
    });

    // the `body is! List` guard and the GameDetailModel.fromJson mapping
    // below it are unchanged
  }
}
```

### lib/features/featured/services/featured_api_service.dart

Identical change to `GameDetailApiService`: the import, the field
`final SupabaseIgdbProxyService _proxy;`, and the single call in `fetchGames`
becoming the same three-line `_proxy.invoke({...})` with
`SupabaseIgdbProxyConstants.gamesEndpoint` and `query`. The guard and the
`Game.fromJson` mapping are untouched.

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
sized. `'endpoint'` and `'query'` stay as literals at the three call sites — they
are this one endpoint's wire format, written next to the value they carry. Every
other class in this file is untouched.

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

### lib/core/services/supabase/supabase_igdb_client.dart
Whole file, whole class. After the transport moved to Retrofit and the logging to
an interceptor, `invoke` was
`_service.invoke({'endpoint': endpoint, 'query': query})` and nothing else. Its
three callers take `SupabaseIgdbProxyService` instead.

### test/api/supabase/supabase_igdb_client_test.dart
Whole file. Its brief moves intact to
`test/api/supabase/supabase_igdb_proxy_service_test.dart` below — nothing it
asserted is dropped. Delete
`test/api/supabase/supabase_igdb_client_test.mocks.dart` with it if build_runner
does not clear the orphan itself.

### lib/core/services/supabase/igdb_call_log.dart
Whole file. `TalkerDioLogger` takes over. Nothing else imports it once
`supabase_igdb_client.dart` is gone.

### test/api/supabase/igdb_call_log_test.dart
Whole file, all 4 tests. They exercise `IgdbCallLog.trimToLineCap`, which no
longer exists. Nothing is ported.

## TEST FILES

### test/api/supabase/supabase_igdb_proxy_service_test.dart

New file, carrying every case the deleted `supabase_igdb_client_test.dart` was
briefed to cover, with the wrapper taken out of the middle.

`@GenerateMocks([HttpClientAdapter])`. A `Dio` with
`baseUrl: 'https://test-project.supabase.co/functions/v1'`,
`contentType: Headers.jsonContentType` and the mock adapter in place, wrapped in
`SupabaseIgdbProxyService(dio)`. No interceptor — auth is the other file's job.
Responses come from a small helper that returns
`ResponseBody.fromString(jsonEncode(body), status, headers: {json content type})`,
and the request is read back off the `RequestOptions` mockito captures. Every call
under test is `proxy.invoke({'endpoint': 'games', 'query': 'fields name;'})`.

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

### test/api/games/games_test.dart

Mechanical mock swap. Four kinds of edit, nothing else in the file moves — same
five test names, same `mockGamesJson` / `mockReleaseDatesJson` /
`mockFunctionException`, same expectations.

1. Import: `supabase_igdb_client.dart` → `supabase_igdb_proxy_service.dart`.
   The `supabase_flutter` import stays; `FunctionException` still comes from it.
2. `@GenerateMocks([SupabaseIgdbClient])` →
   `@GenerateMocks([SupabaseIgdbProxyService])`.
3. `late MockSupabaseIgdbClient igdbClient;` → `late MockSupabaseIgdbProxyService
   igdbProxy;`, `MockSupabaseIgdbClient()` → `MockSupabaseIgdbProxyService()`,
   `GamesApiService(igdbClient)` → `GamesApiService(igdbProxy)`, and the
   `reset(...)` in `tearDown` follows.
4. Every `when`/`verify` argument list:

```dart
// before
when(
  igdbClient.invoke(
    endpoint: SupabaseIgdbProxyConstants.gamesEndpoint,
    query: expectedQuery,
  ),
).thenAnswer((_) async => mockGamesJson);

// after
when(
  igdbProxy.invoke({
    'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
    'query': expectedQuery,
  }),
).thenAnswer((_) async => mockGamesJson);
```

and the two loose stubs:

```dart
// before
when(igdbClient.invoke(
  endpoint: anyNamed('endpoint'),
  query: anyNamed('query'),
))

// after
when(igdbProxy.invoke(any))
```

Mockito wraps a plain argument in `equals(...)`, which compares maps by deep
equality — so the map literal matches the map the service builds. Do not
hand-write a `predicate(...)` for it.

### test/api/game_detail/game_detail_test.dart

Exactly the same four edits across its four tests, with
`GameDetailApiService(igdbProxy)` in `setUp`. Test names, `mockGameDetailJson`,
`mockEmptyGameDetailJson` and every expectation are unchanged.

### Untested by design

`FeaturedApiService` has no test file — verified, nothing under `test/` names it.
`featured` is covered at the use-case and cubit layers
(`test/features/featured/…`), which mock repositories and never reach this
service, so its one-line change breaks nothing and needs no new test. No test
covers the logger either — it is a third-party interceptor behind a build-mode
gate, with nothing of ours to assert.

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
  named `supabaseIgdbProxyService`. `SupabaseIgdbClient`'s field type follows
  (superseded by delta 3 — that class is gone).
- Only this class is renamed. `IgdbProxyAuthInterceptor`,
  `igdb_proxy_auth_interceptor.dart`, `IgdbProxyModule` and
  `igdb_proxy_module.dart` keep the names they already have.
- `tdd.md` and `task-brief.md` were updated in place for this rename and for the
  deletion above, because the Dev Agent's file-allowlist check in
  `.claude/pipeline/rules/git.md` reads `task-brief.md` literally.

**3. `SupabaseIgdbClient` is deleted; its three callers use
`SupabaseIgdbProxyService` directly.**

Second Phase 3 revision, same date. Delta 1 and delta 2 between them left
`SupabaseIgdbClient.invoke` as a single delegating line
(`_service.invoke({'endpoint': endpoint, 'query': query})`), which the human
judged not worth a class, a DI registration, a generated mock and a test file.

- `lib/core/services/supabase/supabase_igdb_client.dart` is **deleted**. It is no
  longer a MODIFY entry anywhere; the skeleton delta 1 showed for it is void.
- `lib/features/games/services/games_api_service.dart`,
  `lib/features/game_detail/services/game_detail_api_service.dart` and
  `lib/features/featured/services/featured_api_service.dart` each change in
  exactly three places: the import, the field
  (`final SupabaseIgdbClient _client` → `final SupabaseIgdbProxyService _proxy`),
  and the one `invoke` call. Their public methods, their `body is! List` guards,
  their `FormatException`s and their `fromJson` mappings do not move. `@injectable`
  and the `const` constructors stay.
- **Call shape.** Retrofit takes the request body as one `@Body()` argument, so
  `invoke(endpoint: …, query: …)` becomes
  `invoke({'endpoint': …, 'query': …})`. `'endpoint'` and `'query'` are written as
  literals at all three sites rather than promoted to constants — they are one
  endpoint's wire format, and a constant would lengthen each call without making
  it safer. This is the one duplication the deletion buys, and it was weighed.
- **DI.** `service_locator.config.dart` loses its `SupabaseIgdbClient` entry and
  passes `SupabaseIgdbProxyService` to all three services. Regenerated, never
  hand-edited.
- **Field name.** `_proxy`, not `_client` or `_service` — inside a class already
  called `…ApiService`, `_service` says nothing.

Test fallout, all four items accounted for:

- `test/api/supabase/supabase_igdb_client_test.dart` is **deleted**, and its
  coverage moves whole to a new
  `test/api/supabase/supabase_igdb_proxy_service_test.dart`. That file is not new
  work: it is the same seven cases delta 1 already briefed for the client test
  (request target, body shape, JSON content type, no IGDB host, decoded return
  value, 400 propagation, 502 propagation), asserted directly against
  `SupabaseIgdbProxyService` with the deleted wrapper removed from the middle.
  **Nothing is orphaned and nothing is ported anywhere else.** Delete
  `supabase_igdb_client_test.mocks.dart` alongside it if build_runner leaves the
  orphan behind.
- `test/api/games/games_test.dart` and
  `test/api/game_detail/game_detail_test.dart` are **edited**:
  `@GenerateMocks([SupabaseIgdbClient])` → `@GenerateMocks([
  SupabaseIgdbProxyService])`, `MockSupabaseIgdbClient` →
  `MockSupabaseIgdbProxyService`, and every argument list to the map form —
  `invoke(endpoint: X, query: Y)` → `invoke({'endpoint': X, 'query': Y})`,
  `invoke(endpoint: anyNamed('endpoint'), query: anyNamed('query'))` →
  `invoke(any)`. Mockito wraps a plain argument in `equals(...)`, which does deep
  map comparison, so the literal matches. No test name, stubbed response or
  expectation changes.
- `mockFunctionException` stays as the thrown stub in both files. Those two tests
  assert that an error from the proxy is not swallowed, not which type it is; the
  transport can no longer produce a `FunctionException`, but swapping it would
  pull `test/mocks/error_mock.dart` into the diff for no added coverage, and
  `test/repository/games/games_repository_test.dart` needs the getter regardless.
  Deliberate residual, flagged so QA does not read it as an oversight.
- `FeaturedApiService` has **no test** — re-verified by search across `test/`.
  `featured` is covered at the use-case and cubit layers, which mock
  repositories, so its one-line change breaks nothing hidden. No test is added
  for it; that matches the standing decision recorded in the
  `igdb-client-repoint-20260805` run.

Criteria this overturns or re-reads, all human-approved:

- **AC-23 is overturned outright.** Its guarantee that the callers' test files are
  not edited is now explicitly false. QA marks it knowingly-not-met, not failed,
  and should not treat the edits as evidence that AC-14 or AC-15 broke.
- **AC-14** named a method on a deleted class. What still binds, and what QA
  should check instead: the proxy returns the decoded body untouched, and
  `GamesApiService.fetchGames` / `fetchReleaseDates`,
  `GameDetailApiService.fetchGameDetail` and `FeaturedApiService.fetchGames` keep
  their names, parameters, return types and bodies. Nothing above the three
  services changes.
- **AC-15**'s "compile and behave unchanged with no edits" loses the "no edits"
  half and keeps the "behave unchanged" half.
- **AC-1, AC-3, AC-5** read `SupabaseIgdbProxyService` and its Dio wherever they
  say `SupabaseIgdbClient`. AC-5 is met more completely than written — the type
  that held `FunctionsClient` no longer exists.
- **Test-count effect, updated.** On top of delta 1's 4, deleting
  `supabase_igdb_client_test.dart` removes its 3 passing tests. The recorded
  `Test baseline: +209` legitimately drops by 7 before this task's new tests are
  counted.

As with delta 2, `tdd.md` and `task-brief.md` were corrected in place for this
change rather than left stale, because the Dev Agent's file-allowlist check reads
`task-brief.md` literally and would otherwise refuse to touch the three callers.

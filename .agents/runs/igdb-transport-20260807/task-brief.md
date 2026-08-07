# Task Brief
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07
Revised: 2026-08-07 (twice) — Phase 3 human feedback. `code-plan.md ## Approved
feedback delta` is authoritative wherever anything still conflicts. Second
revision: `SupabaseIgdbClient` is deleted and its three callers talk to
`SupabaseIgdbProxyService` directly.

## Context

Move the IGDB path off `functions.invoke` and onto Dio + Retrofit against the same
`igdb-proxy` Edge Function. `SupabaseIgdbClient` had become a one-line passthrough
once the transport moved, so it goes too — `GamesApiService`,
`GameDetailApiService` and `FeaturedApiService` each hold the Retrofit service
instead. Logging moves off the hand-rolled `IgdbCallLog` and onto
`TalkerDioLogger` as an interceptor.

## Testing mode

`coverage` — Rule applied: auth/authorisation (AC-7 to AC-13 are token, fallback
and 401-refresh behaviour). Justification: the shared-utility rule matches too —
this one service serves `games`, `game_detail` and `featured`.

## File allowlist

### CREATE NEW
- `lib/core/services/supabase/supabase_igdb_proxy_service.dart` — Retrofit
  interface `SupabaseIgdbProxyService`, one POST to the `igdb-proxy` function.
- `lib/core/services/supabase/igdb_proxy_auth_interceptor.dart` — puts the
  Supabase session credentials on each request and replays a 401 once.
- `lib/core/di/igdb_proxy_module.dart` — builds the Dio (flavour host, shared
  timeouts, the auth interceptor, and `TalkerDioLogger` only in a debug dev
  build) and provides `SupabaseIgdbProxyService`.

### MODIFY EXISTING
- `pubspec.yaml` — **one line only**: add `talker_dio_logger: ^5.1.16` under the
  `# Logging` comment, beside `talker_flutter`. Then run `flutter pub get`, which
  updates `pubspec.lock` — that lock change is expected and is committed. No
  other dependency is added, removed or version-bumped. This is a human-approved
  one-off deviation from the read-only-`pubspec.yaml` rule, for this run only.
- `lib/core/res/const.dart` — in `SupabaseIgdbProxyConstants`: rename
  `functionName` to `functionPath` with value `'/igdb-proxy'`, add
  `functionsBasePath = '/functions/v1'`, delete `requestTimeout`, delete
  `maxLogBodyLines` (its only reader is deleted). Touch no other class in the
  file.
- `lib/features/games/services/games_api_service.dart` — field type
  `SupabaseIgdbClient _client` becomes `SupabaseIgdbProxyService _proxy`; the one
  call inside `_decodeList` becomes
  `_proxy.invoke({'endpoint': endpoint, 'query': query})`; the import swaps.
  `fetchGames`, `fetchReleaseDates`, the `body is! List` guard and the `fromJson`
  mapping are untouched.
- `lib/features/game_detail/services/game_detail_api_service.dart` — same shape
  change, one call site inside `fetchGameDetail`. Nothing else moves.
- `lib/features/featured/services/featured_api_service.dart` — same shape change,
  one call site inside `fetchGames`. Nothing else moves.

### DELETE
- `lib/core/services/supabase/supabase_igdb_client.dart` — after the transport
  change it is a one-line passthrough to `SupabaseIgdbProxyService.invoke`, with
  no behaviour of its own left to justify a class. Human-approved at the Phase 3
  gate; this is what overturns AC-23.
- `test/api/supabase/supabase_igdb_client_test.dart` — tests the deleted class.
  Its coverage moves wholesale to the new
  `test/api/supabase/supabase_igdb_proxy_service_test.dart`; see TEST FILES.
- `lib/core/services/supabase/igdb_call_log.dart` — replaced by
  `TalkerDioLogger`. Nothing else in `lib/` references it once the client is
  deleted.
- `test/api/supabase/igdb_call_log_test.dart` — tests a class that no longer
  exists. Delete the whole file; do not port its cases anywhere.

### TEST FILES
- `test/api/supabase/supabase_igdb_proxy_service_test.dart` — **new**, and the
  home of everything `supabase_igdb_client_test.dart` was going to assert:
  request target, body shape, JSON content type, no IGDB host, the decoded return
  value, and error propagation with the status preserved (400 and 502). Same
  cases, one layer lower, with the deleted wrapper taken out of the middle.
- `test/api/supabase/igdb_proxy_auth_interceptor_test.dart` — new. Both auth
  headers, the per-request token read, the no-session anon-key fallback, refresh
  and replay on 401, exactly two requests on a repeated 401, refresh failure, and
  no retry on a non-401.
- `test/api/games/games_test.dart` — **modify**. `@GenerateMocks([
  SupabaseIgdbClient])` becomes `@GenerateMocks([SupabaseIgdbProxyService])`,
  `MockSupabaseIgdbClient` becomes `MockSupabaseIgdbProxyService`, and every
  `invoke(endpoint: X, query: Y)` / `invoke(endpoint: anyNamed('endpoint'), query:
  anyNamed('query'))` becomes the single-map form. Test names, stubbed data and
  assertions do not change.
- `test/api/game_detail/game_detail_test.dart` — **modify**, exactly the same
  four changes.
- `test/mocks/auth_mock.dart` — add one refreshed-session getter. Nothing existing
  in this file changes.

`FeaturedApiService` has no test of its own — confirmed, nothing under `test/`
references it. The `featured` feature is covered at the use-case and cubit layers
(`test/features/featured/…`), which mock repositories and never reach this
service. So its one-line change breaks no test and needs none added; do not write
one.

## Implementation plan

Step 1: `pubspec.yaml` — add `talker_dio_logger: ^5.1.16` in the `# Logging`
block under `talker_flutter`, then run `flutter pub get`. Commit the resulting
`pubspec.lock`. If it will not resolve without changing another constraint, stop
and escalate — do not bump anything else.

Step 2: `lib/core/res/const.dart` — update `SupabaseIgdbProxyConstants`: rename
`functionName` to `functionPath` (`'/igdb-proxy'`), add
`functionsBasePath` (`'/functions/v1'`), remove `requestTimeout` and
`maxLogBodyLines`. Leave `gamesEndpoint` and `releaseDatesEndpoint` alone.

Step 3: create `lib/core/services/supabase/supabase_igdb_proxy_service.dart` —
the `@RestApi()` interface `SupabaseIgdbProxyService` with the single
`@POST(SupabaseIgdbProxyConstants.functionPath)` method taking a
`@Body() Map<String, String>` and returning `Future<Object?>`. Do **not** put a
`baseUrl` in the `@RestApi` annotation; the Dio instance supplies it at runtime.

Step 4: run `dart run build_runner build --delete-conflicting-outputs` — produces
`supabase_igdb_proxy_service.g.dart`, which is committed.

Step 5: create `lib/core/services/supabase/igdb_proxy_auth_interceptor.dart` —
`IgdbProxyAuthInterceptor extends Interceptor` (not `QueuedInterceptor`), taking
`GoTrueClient auth`, `String anonKey` and the `Dio` it will replay through.
`onRequest` sets `Authorization: Bearer <currentSession?.accessToken ?? anonKey>`
and `apikey: <anonKey>`, reading the session on every call. `onError` acts only on
a 401 that has not already been replayed: refresh the session, and if that throws
or yields no session pass the original error on unchanged; otherwise flag
`requestOptions.extra` and re-issue through the same Dio, resolving with the
replay's response or forwarding the replay's error.

Step 6: create `lib/core/di/igdb_proxy_module.dart` — `@module` with one
`@singleton` method that takes `SupabaseClient`, reads `FlavorConfig.instance`,
builds the Dio (`baseUrl` = the flavour Supabase URL plus `functionsBasePath`,
`ConfigConstants.connectTimeout` / `receiveTimeout` / `sendTimeout`,
`contentType: Headers.jsonContentType`), adds `IgdbProxyAuthInterceptor`, then
adds `TalkerDioLogger` **only inside** an
`if (kDebugMode && config.flavor == Flavor.dev)`, and returns
`SupabaseIgdbProxyService(dio)`. Give the logger
`talker: Talker(settings: TalkerSettings(useHistory: false))` and leave
`TalkerDioLoggerSettings` at its defaults — in particular do not enable
`printRequestHeaders`, which would print the bearer token. Do not register the
`Dio` itself.

Step 7: `lib/features/games/services/games_api_service.dart` — swap the
`SupabaseIgdbClient` import and field for `SupabaseIgdbProxyService _proxy`, and
change the one line inside `_decodeList` to
`await _proxy.invoke({'endpoint': endpoint, 'query': query})`. Nothing else in the
file changes — same `@injectable`, same `const` constructor, same two public
methods, same `FormatException` guard.

Step 8: `lib/features/game_detail/services/game_detail_api_service.dart` — the
same swap, with the map built from
`SupabaseIgdbProxyConstants.gamesEndpoint` and `query` at the one call site in
`fetchGameDetail`.

Step 9: `lib/features/featured/services/featured_api_service.dart` — the same
swap, one call site in `fetchGames`.

Step 10: delete four files —
`lib/core/services/supabase/supabase_igdb_client.dart`,
`test/api/supabase/supabase_igdb_client_test.dart`,
`lib/core/services/supabase/igdb_call_log.dart` and
`test/api/supabase/igdb_call_log_test.dart`. If build_runner leaves
`test/api/supabase/supabase_igdb_client_test.mocks.dart` behind at Step 17, delete
it too — a generated file whose source is gone.

Step 11: run `dart run build_runner build --delete-conflicting-outputs` — rewires
`service_locator.config.dart`: `SupabaseIgdbClient` disappears from it and the
three API services now take `SupabaseIgdbProxyService`.

Step 12: `test/mocks/auth_mock.dart` — add a `mockRefreshedDiscordSession` getter
with a different access token from `mockDiscordSession`. Change nothing else.

Step 13: create `test/api/supabase/supabase_igdb_proxy_service_test.dart` — mock
`HttpClientAdapter` with `@GenerateMocks`, build a `Dio` with a stand-in Supabase
functions `baseUrl` and no interceptor, wrap it in `SupabaseIgdbProxyService`, and
drive it directly. See `code-plan.md` for the case list.

Step 14: `test/api/games/games_test.dart` — mock `SupabaseIgdbProxyService`
instead of `SupabaseIgdbClient` and rewrite the six `when`/`verify` argument lists
to the single-map form. Do not change a test name, a stubbed response or an
expectation.

Step 15: `test/api/game_detail/game_detail_test.dart` — the same change across its
four tests.

Step 16: create `test/api/supabase/igdb_proxy_auth_interceptor_test.dart` — mock
`HttpClientAdapter` and `GoTrueClient`, install the interceptor on a test `Dio`,
and drive it with `dio.post(...)`. See `code-plan.md` for the case list.

Step 17: run `dart run build_runner build --delete-conflicting-outputs` —
regenerates every `.mocks.dart` before any test runs.

Step 18: run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md`, quoted verbatim: `Analyzer baseline: 0 errors, 2
warnings, 32 info` and `Test baseline: +209 -11`, with `Pre-existing test
failures: test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`. **Expected
deviation:** the two deleted test files remove 7 passing tests between them
(`igdb_call_log_test.dart` 4, `supabase_igdb_client_test.dart` 3), so the pass
count legitimately drops by 7 before this task's new tests are counted. That drop
is not a regression. Only a new in-scope error or failure is yours to fix.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 10.1-AC-1 through 10.1-AC-24.

Six criteria read differently after the two Phase 3 decisions. None of them is a
licence to skip work elsewhere.

- AC-1, AC-3, AC-5 — every mention of `SupabaseIgdbClient` now means
  `SupabaseIgdbProxyService` and the Dio it runs on. AC-5 in particular is met
  more completely than written: the class that depended on `FunctionsClient` no
  longer exists.
- AC-14 — the method signature it protects belongs to a deleted class. What is
  still held constant, and what QA should check, is one layer up: the proxy
  returns the decoded body untouched, and `GamesApiService.fetchGames` /
  `fetchReleaseDates`, `GameDetailApiService.fetchGameDetail` and
  `FeaturedApiService.fetchGames` keep their names, parameters, return types and
  their `body is! List` → `fromJson` bodies. Nothing above the API services
  changes.
- AC-15 — its "with no edits" clause is void. The three services each take a
  one-line dependency edit; their *behaviour* is unchanged, which is the part
  that still holds. `BaseRepositoryMixin` and `ErrorType` are untouched.
- AC-16 — the endpoint/query line and the failure log survive via
  `TalkerDioLogger`'s request/error output. The 50-line response trim with its
  omitted-line count and the caller's own stack trace do not, and the human
  accepted that.
- AC-22 — superseded. The trim it protects no longer exists, so there is nothing
  to cover. Do not write a replacement test for it.
- AC-23 — **overturned, human-approved.** `test/api/games/games_test.dart` and
  `test/api/game_detail/game_detail_test.dart` are edited. Do not try to preserve
  them unedited; QA should mark this criterion as knowingly not met rather than
  as a failure.

## Constraints

- `supabase/functions/igdb-proxy/index.ts` and everything else under `supabase/`
  is off limits. It already verifies the caller's JWT and does its own
  retry-once against Twitch.
- `lib/core/di/network_module.dart` and
  `lib/core/services/api/twitch_auth_interceptor.dart` are read-only reference
  code. Read them for the `BaseOptions` shape and the retry idea, then write new
  files. They stay `@Deprecated` and unregistered.
- `pubspec.yaml` is read-only **except** for the single `talker_dio_logger` line
  in Step 1. `dio`, `retrofit`, `retrofit_generator`, `mockito` and
  `http_mock_adapter` are already there and need no change.
- `IgdbCallLog` is deleted, not modified and not turned into our own interceptor.
  No hand-written logging replaces it — `TalkerDioLogger` with default settings
  is the whole of it.
- AC-17's release/prod silence is achieved by only registering the logger when
  `kDebugMode && FlavorConfig.instance.flavor == Flavor.dev`, not by a settings
  flag. Keep the gate at registration.
- The three API services get a dependency swap and one changed call line each,
  nothing more. Do not rework their decoding, their error handling or their
  method signatures, and do not add a shared base class to hold the two body
  keys — three inline `{'endpoint': …, 'query': …}` literals is the accepted
  cost of deleting the wrapper.
- Do not edit `ErrorType`, `BaseRepositoryMixin`, any datasource or any
  repository. The change stops at the three services.
- `dart-style.md`: 80-character lines, single quotes, trailing commas on
  multi-line argument lists, no bare `dynamic`, package imports over relative,
  no top-level constants outside a `*Constants` class.
- Comments per `execution.md` and `project-conventions.md`: plain English, explain
  the why, few of them. No `///` line per constructor field. The three services'
  existing one-line header comments stay as they are.
- Retrofit service naming per `dart-style.md`: `abstract class [Name]Service`,
  `factory [Name]Service(Dio dio) = _[Name]Service;` — here
  `SupabaseIgdbProxyService` / `_SupabaseIgdbProxyService`.
- Generated files (`*.g.dart`, `*.config.dart`, `*.mocks.dart`) are never
  hand-written or hand-edited — fix the source and regenerate.
- **Test tooling deviation, deliberate:** `testing-conventions.md` names
  `DioAdapter` (http_mock_adapter) as the API-layer default. The two new
  `test/api/supabase/` files mock `HttpClientAdapter` with mockito instead,
  because AC-11 and AC-13 require counting HTTP requests and AC-7 to AC-9 require
  asserting per-request headers, neither of which `DioAdapter` supports.
  Everything else in `testing-conventions.md` still applies: `@GenerateMocks`
  immediately above `void main()`, `reset(mock)` in `tearDown`, `'should
  [behaviour] when [condition]'` naming, shared mock data from `test/mocks/`.
- In the two edited caller tests, keep `mockFunctionException` as the thrown
  stub. It is arbitrary — those tests assert that whatever the proxy throws
  reaches the datasource uncaught, not which type it is — and swapping it for a
  `DioException` would drag `test/mocks/error_mock.dart` into the diff for no
  added coverage. `test/repository/games/games_repository_test.dart` uses the same
  getter and is out of scope.
- No test is written for the logger. It is a third-party interceptor behind a
  build-mode gate; there is nothing of ours to assert.
- Never a golden test.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass, beyond the mechanical mock swap Steps 14 and 15 call for. Beyond the
one approved `talker_dio_logger` line, do not add packages to `pubspec.yaml` or
touch files outside the allowlist — escalate instead.

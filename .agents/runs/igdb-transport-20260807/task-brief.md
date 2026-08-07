# Task Brief
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07

## Context

Move `SupabaseIgdbClient` off `functions.invoke` and onto Dio + Retrofit against
the same `igdb-proxy` Edge Function, so the IGDB path uses the project's own HTTP
stack without changing anything its callers can see.

## Testing mode

`coverage` — Rule applied: auth/authorisation (AC-7 to AC-13 are token, fallback
and 401-refresh behaviour). Justification: the shared-utility rule matches too —
this one client serves `games`, `game_detail` and `featured`.

## File allowlist

### CREATE NEW
- `lib/core/services/supabase/igdb_proxy_service.dart` — Retrofit interface, one
  POST to the `igdb-proxy` function.
- `lib/core/services/supabase/igdb_proxy_auth_interceptor.dart` — puts the
  Supabase session credentials on each request and replays a 401 once.
- `lib/core/di/igdb_proxy_module.dart` — builds the Dio (flavour host, shared
  timeouts, the interceptor) and provides `IgdbProxyService`.

### MODIFY EXISTING
- `lib/core/services/supabase/supabase_igdb_client.dart` — depend on
  `IgdbProxyService` instead of `SupabaseClient`; drop the `.timeout(...)`; keep
  `invoke`'s signature, return value, logging calls and `rethrow` as they are.
- `lib/core/res/const.dart` — in `SupabaseIgdbProxyConstants`: rename
  `functionName` to `functionPath` with value `'/igdb-proxy'`, add
  `functionsBasePath = '/functions/v1'`, delete `requestTimeout`.

### TEST FILES
- `test/api/supabase/supabase_igdb_client_test.dart` — **rewrite**. Request
  target and body shape, the decoded return value, error propagation with the
  status preserved. The current file mocks `FunctionsClient` and cannot survive
  the transport change.
- `test/api/supabase/igdb_proxy_auth_interceptor_test.dart` — new. Both auth
  headers, the per-request token read, the no-session anon-key fallback, refresh
  and replay on 401, exactly two requests on a repeated 401, refresh failure, and
  no retry on a non-401.
- `test/mocks/auth_mock.dart` — add one refreshed-session getter. Nothing existing
  in this file changes.

Do not touch `test/api/games/games_test.dart`,
`test/api/game_detail/game_detail_test.dart`, the featured repository tests, or
`test/api/supabase/igdb_call_log_test.dart` — all four must pass unedited.

## Implementation plan

Step 1: `lib/core/res/const.dart` — update `SupabaseIgdbProxyConstants`: rename
`functionName` to `functionPath` (`'/igdb-proxy'`), add
`functionsBasePath` (`'/functions/v1'`), remove `requestTimeout`. Leave
`gamesEndpoint`, `releaseDatesEndpoint` and `maxLogBodyLines` alone.

Step 2: create `lib/core/services/supabase/igdb_proxy_service.dart` — the
`@RestApi()` interface with the single `@POST(SupabaseIgdbProxyConstants.functionPath)`
method taking a `@Body() Map<String, String>` and returning `Future<Object?>`.
Do **not** put a `baseUrl` in the `@RestApi` annotation; the Dio instance supplies
it at runtime.

Step 3: run `dart run build_runner build --delete-conflicting-outputs` — produces
`igdb_proxy_service.g.dart`, which is committed.

Step 4: create `lib/core/services/supabase/igdb_proxy_auth_interceptor.dart` —
`IgdbProxyAuthInterceptor extends Interceptor` (not `QueuedInterceptor`), taking
`GoTrueClient auth`, `String anonKey` and the `Dio` it will replay through.
`onRequest` sets `Authorization: Bearer <currentSession?.accessToken ?? anonKey>`
and `apikey: <anonKey>`, reading the session on every call. `onError` acts only on
a 401 that has not already been replayed: refresh the session, and if that throws
or yields no session pass the original error on unchanged; otherwise flag
`requestOptions.extra` and re-issue through the same Dio, resolving with the
replay's response or forwarding the replay's error.

Step 5: create `lib/core/di/igdb_proxy_module.dart` — `@module` with one
`@singleton` method that takes `SupabaseClient`, reads `FlavorConfig.instance`,
builds the Dio (`baseUrl` = the flavour Supabase URL plus `functionsBasePath`,
`ConfigConstants.connectTimeout` / `receiveTimeout` / `sendTimeout`,
`contentType: Headers.jsonContentType`), adds the interceptor, and returns
`IgdbProxyService(dio)`. Do not register the `Dio` itself.

Step 6: `lib/core/services/supabase/supabase_igdb_client.dart` — replace the
`SupabaseClient` field with `IgdbProxyService`, call
`_service.invoke({'endpoint': endpoint, 'query': query})`, drop the
`.timeout(...)` chain and the `supabase_flutter` import. Everything else in the
method — the three `IgdbCallLog` calls, the try/catch, the `rethrow`, the return
— stays as it is.

Step 7: run `dart run build_runner build --delete-conflicting-outputs` — rewires
`service_locator.config.dart` for the new module and the client's new dependency.

Step 8: `test/mocks/auth_mock.dart` — add a `mockRefreshedDiscordSession` getter
with a different access token from `mockDiscordSession`. Change nothing else.

Step 9: rewrite `test/api/supabase/supabase_igdb_client_test.dart` — mock
`HttpClientAdapter` with `@GenerateMocks`, build a `Dio` with a stand-in Supabase
functions `baseUrl` and no interceptor, wrap it in `IgdbProxyService`, and drive
`SupabaseIgdbClient` through it. See `code-plan.md` for the case list.

Step 10: create `test/api/supabase/igdb_proxy_auth_interceptor_test.dart` — mock
`HttpClientAdapter` and `GoTrueClient`, install the interceptor on a test `Dio`,
and drive it with `dio.post(...)`. See `code-plan.md` for the case list.

Step 11: run `dart run build_runner build --delete-conflicting-outputs` —
regenerates both `.mocks.dart` files before any test runs.

Step 12: run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md`, quoted verbatim: `Analyzer baseline: 0 errors, 2
warnings, 32 info` and `Test baseline: +209 -11`, with `Pre-existing test
failures: test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`. Only a new
in-scope error or failure is yours to fix.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 10.1-AC-1 through 10.1-AC-24.

## Constraints

- `supabase/functions/igdb-proxy/index.ts` and everything else under `supabase/`
  is off limits. It already verifies the caller's JWT and does its own
  retry-once against Twitch.
- `lib/core/di/network_module.dart` and
  `lib/core/services/api/twitch_auth_interceptor.dart` are read-only reference
  code. Read them for the `BaseOptions` shape and the retry idea, then write new
  files. They stay `@Deprecated` and unregistered.
- `pubspec.yaml` is read-only. `dio`, `retrofit`, `retrofit_generator`, `mockito`
  and `http_mock_adapter` are already there; `talker_dio_logger` is not, and must
  not be added.
- `IgdbCallLog` is not modified and is not turned into an interceptor. Its three
  call sites stay inside `SupabaseIgdbClient.invoke`, which is what keeps AC-16's
  endpoint/query line and its call-site stack trace working.
- Do not edit `ErrorType`, `BaseRepositoryMixin`, `GamesApiService`,
  `GameDetailApiService`, `FeaturedApiService`, or any repository.
- `dart-style.md`: 80-character lines, single quotes, trailing commas on
  multi-line argument lists, no bare `dynamic`, package imports over relative,
  no top-level constants outside a `*Constants` class.
- Comments per `execution.md` and `project-conventions.md`: plain English, explain
  the why, few of them. No `///` line per constructor field.
- Retrofit service naming per `dart-style.md`: `abstract class [Name]Service`,
  `factory [Name]Service(Dio dio) = _[Name]Service;`.
- Generated files (`*.g.dart`, `*.config.dart`, `*.mocks.dart`) are never
  hand-written or hand-edited — fix the source and regenerate.
- **Test tooling deviation, deliberate:** `testing-conventions.md` names
  `DioAdapter` (http_mock_adapter) as the API-layer default. These two files mock
  `HttpClientAdapter` with mockito instead, because AC-11 and AC-13 require
  counting HTTP requests and AC-7 to AC-9 require asserting per-request headers,
  neither of which `DioAdapter` supports. Everything else in
  `testing-conventions.md` still applies: `@GenerateMocks` immediately above
  `void main()`, `reset(mock)` in `tearDown`, `'should [behaviour] when
  [condition]'` naming, shared mock data from `test/mocks/`.
- Never a golden test.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead.

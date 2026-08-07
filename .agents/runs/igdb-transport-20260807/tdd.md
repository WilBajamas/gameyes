# Technical Design Document
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07
Revised: 2026-08-07 — Phase 3 human feedback (see `code-plan.md ## Approved
feedback delta`, which is authoritative on any conflict).

## Feature summary

`SupabaseIgdbClient` keeps its public shape and swaps what sits underneath it.
Instead of `supabase_flutter`'s `functions.invoke`, it calls a one-method Retrofit
interface (`SupabaseIgdbProxyService`) over a Dio instance built by a new
`@module` in `lib/core/di/`. That Dio carries the flavour's Supabase functions
host as its `baseUrl`, the three shared `ConfigConstants` timeouts, an
interceptor that attaches the Supabase session credentials per request and
replays a 401 once after refreshing the session, and — in debug builds on the dev
flavour only — a `TalkerDioLogger`. The hand-rolled `IgdbCallLog` is deleted and
its logging duty moves to that interceptor. Everything above the client — the
three API services, `BaseRepositoryMixin`, `ErrorType`, the UI — is untouched, and
so is the Edge Function and the deprecated `NetworkModule` /
`TwitchAuthInterceptor` pair. This is entirely a data-layer change; there is no
domain, state or UI work in it.

## Layer map

10.1-AC-1: data (Retrofit service, client)
10.1-AC-2: data (DI module, flavour config read)
10.1-AC-3: data (DI module baseUrl, Retrofit path)
10.1-AC-4: data (DI module BaseOptions)
10.1-AC-5: data (client)
10.1-AC-6: data (Retrofit service + generated `.g.dart`)
10.1-AC-7 … 10.1-AC-13: data (auth interceptor)
10.1-AC-14, 10.1-AC-15: data (client)
10.1-AC-16 … 10.1-AC-18: data (`TalkerDioLogger` interceptor + its registration
gate in the DI module — see Reuse; `IgdbCallLog` is deleted)
10.1-AC-19, 10.1-AC-20: no layer — static checks on the diff
10.1-AC-21 … 10.1-AC-24: test

## Data layer

### API contracts

**IgdbProxy** — `POST {supabaseUrl}/functions/v1/igdb-proxy`

- Request headers: `Content-Type: application/json`,
  `Authorization: Bearer <session access token, else the flavour anon key>`,
  `apikey: <flavour anon key>`
- Request body: `{"endpoint": String, "query": String}` — exactly these two keys
- 200: the IGDB response body verbatim, `Content-Type: application/json`.
  In practice a JSON array; Dio decodes it to `List`. Passed through untyped —
  the client does not model it, and each caller does its own `fromJson`.
- 400: `{"error": String}` — body not JSON, `endpoint` not in
  `{games, release_dates}`, or `query` empty
- 401: rejected by the Supabase gateway before the function body runs
- 405: `{"error": "Method not allowed"}` for a non-POST
- 502: `{"error": "Upstream IGDB request failed"}`

Source: `supabase/functions/igdb-proxy/index.ts` (read only, not modified) for
the body/status contract; `supabase-2.14.0/lib/src/supabase_client.dart:139`
for the `$supabaseUrl/functions/v1` host and `:373` for the two headers and the
`accessToken ?? anonKey` fallback. Nothing here is inferred from a sample.

### Models

None. AC-14 requires the decoded body to reach callers as the same untyped
`List`/`Map` they get today, so introducing a response DTO would break the
contract. The request body is a two-entry `Map<String, String>` literal built at
the one call site — a DTO for two strings would be a class with no behaviour.

### Repositories

None. This change sits below the repository layer; `GamesRepositoryImpl` and
friends are unchanged.

### Services

`SupabaseIgdbProxyService` (create) —
`lib/core/services/supabase/supabase_igdb_proxy_service.dart`
- `@RestApi()`, no `baseUrl` in the annotation. Retrofit falls back to the Dio
  instance's own `baseUrl`, which is the only way AC-2's runtime flavour host can
  work; a compile-time `baseUrl` would hardcode a project.
- `factory SupabaseIgdbProxyService(Dio dio) = _SupabaseIgdbProxyService;`,
  `part 'supabase_igdb_proxy_service.g.dart';`
- `@POST(SupabaseIgdbProxyConstants.functionPath)`
  `Future<Object?> invoke(@Body() Map<String, String> body);`
- Return type is `Object?` deliberately: retrofit's generator emits a plain
  `_dio.fetch(...)` + `return _result.data` for `Object`/`dynamic` returns, which
  is exactly the untyped pass-through AC-14 asks for.
- Name carries the `Supabase` prefix to match `SupabaseIgdbClient` and to say
  which backend the proxy belongs to. Only this class is renamed; the interceptor
  (`IgdbProxyAuthInterceptor`) and the DI module (`IgdbProxyModule`) keep their
  names.

`SupabaseIgdbClient` (modify) — `lib/core/services/supabase/supabase_igdb_client.dart`
- `invoke({required String endpoint, required String query}) -> Future<Object?>`
  — name, parameters and return type unchanged (AC-14).
- Constructor dependency changes from `SupabaseClient` to
  `SupabaseIgdbProxyService`. Per `ambiguities.md`, this is inside the agreed
  reading of "signature unchanged": the three callers depend on `invoke` only,
  and their tests mock `SupabaseIgdbClient` itself.
- `.timeout(...)` is dropped — Dio's `BaseOptions` now owns the deadline (AC-4).
- The three `IgdbCallLog` calls go, and with them the `try`/`catch`/`rethrow`
  that only existed to log the failure. `invoke` becomes a one-line delegation;
  errors propagate by doing nothing to them, which is what AC-15 asks for.

### Interceptors

`IgdbProxyAuthInterceptor` (create) —
`lib/core/services/supabase/igdb_proxy_auth_interceptor.dart`
- Extends `Interceptor`, not `QueuedInterceptor`. The replay re-enters the same
  Dio instance, and a `QueuedInterceptor` serialises its own queue — a nested
  request from inside `onError` would wait on the task that issued it.
- Constructor takes `GoTrueClient auth`, `String anonKey`, `Dio dio`. It depends
  on the auth client only, not the whole `SupabaseClient` (ISP), and the anon key
  arrives as a value so the interceptor never reads global config itself.
- `onRequest` reads `auth.currentSession?.accessToken ?? anonKey` on every call
  and sets `Authorization` and `apikey` (AC-7, AC-8, AC-9).
- `onError` handles only `statusCode == 401` on a request not already replayed.
  It awaits `auth.refreshSession()`; if that throws or returns a null session it
  forwards the original error untouched (AC-12). Otherwise it marks
  `requestOptions.extra` and re-issues through the same Dio, so `onRequest` picks
  up the refreshed token by itself (AC-10). The marker is what makes a second
  replay impossible (AC-11).
- Every other status and every transport failure falls straight through to
  `handler.next` (AC-13).
- Holding the `Dio` it is installed on is deliberate. The alternative —
  `TwitchAuthInterceptor`'s throwaway `Dio()` — would send the replay through an
  adapter no test can see, and AC-21 requires counting requests against a mock.

`TalkerDioLogger` (adopt, from the new `talker_dio_logger` package) — no file of
our own. Installed on the same Dio, after the auth interceptor, and only when
`kDebugMode && FlavorConfig.instance.flavor == Flavor.dev`. See Reuse decisions
for why this replaces `IgdbCallLog` and what that costs.

### Dependency injection

`IgdbProxyModule` (create) — `lib/core/di/igdb_proxy_module.dart`
- `@module abstract class`, one `@singleton` provider returning
  `SupabaseIgdbProxyService`, taking the already-registered `SupabaseClient`.
- Builds the Dio: `baseUrl` = flavour Supabase URL + `/functions/v1`,
  the three `ConfigConstants` timeouts, `contentType: Headers.jsonContentType`.
- Adds `IgdbProxyAuthInterceptor` first, then — behind the debug/dev gate —
  `TalkerDioLogger`. Auth first means a 401 that the replay rescues is logged as
  the success it ended up being, not as an error.
- Reads `FlavorConfig.instance`, which throws `StateError` when bootstrap has not
  run. `@singleton` is constructed eagerly during `configureDependencies()`, so a
  missing flavour config fails at startup rather than on the first game list —
  AC-2's failure case.
- The Dio is not registered in the container. Only this one service needs it, and
  a bare `Dio` singleton would be a magnet for unrelated callers.
- Separate file from `NetworkModule` and from `SupabaseModule`, so AC-19 holds by
  construction.

### Constants

`SupabaseIgdbProxyConstants` (modify) — `lib/core/res/const.dart`
- `functionName` becomes `functionPath = '/igdb-proxy'` — it is now a Retrofit
  path, and the leading slash is what joins it to the `/functions/v1` base.
- add `functionsBasePath = '/functions/v1'`.
- delete `requestTimeout` — its only reader was the `.timeout(...)` that AC-4
  replaces.
- delete `maxLogBodyLines` — its only reader was `IgdbCallLog.trimToLineCap`,
  which is deleted with it. `TalkerDioLogger` does its own formatting.
- `gamesEndpoint` and `releaseDatesEndpoint` are unchanged.

### Packages

`talker_dio_logger` (add) — `pubspec.yaml`, under `# Logging` beside
`talker_flutter`, constrained `^5.1.16` to sit on the same talker 5.1.x line the
lockfile already pins (`talker 5.1.20`, `talker_flutter 5.1.18`). Approved by the
human at the Phase 3 gate as a one-off deviation from this pipeline's
read-only-`pubspec.yaml` rule. No other dependency moves; if `flutter pub get`
cannot resolve without bumping something else, that is an escalation, not a fix.

## Domain layer

None — this feature does not reach the domain layer.

## State layer

None — no notifier, cubit or bloc changes.

## UI layer

None — no screen or widget changes.

## Testing mode

`coverage`. First matching rule is auth/authorisation: AC-7 to AC-13 are entirely
about bearer tokens, an anon-key fallback and a 401 refresh-and-replay. The
shared-utility rule matches independently — `SupabaseIgdbClient` is the single
IGDB path for `games`, `game_detail` and `featured`.

Unit tests only, no widget tests, no golden tests. Layer-based paths under
`test/api/supabase/`.

## Reuse decisions

`IgdbCallLog` at `lib/core/services/supabase/igdb_call_log.dart` — **deleted**,
along with its test `test/api/supabase/igdb_call_log_test.dart`. Overturns this
document's first pass, on the human's decision at the Phase 3 gate. Logging moves
to `TalkerDioLogger` from the newly added `talker_dio_logger` package, registered
as an interceptor on the new Dio. What that buys: one less hand-maintained
logging class, request and response logging that comes with the transport rather
than being called by hand at one call site, and a `SupabaseIgdbClient.invoke`
that is a pure delegation. What it costs, accepted by the human explicitly:
  1. The 50-line response trim and its "cut short: showing N of M lines" note are
     gone. `TalkerDioLoggerSettings`' own defaults stand in.
  2. `IgdbCallLog.failure` logged the *caller's* stack trace; `TalkerDioLogger`
     logs what Dio hands it. Not reproduced.
  3. AC-22 has nothing left to cover — the behaviour it protects no longer
     exists. Treat it as superseded, not failed.
  Settings are left at their defaults, which matters for one reason worth
  stating: `printRequestHeaders` defaults to `false`, so the bearer token never
  reaches the console. Do not turn it on.
  AC-17 (nothing in release builds or on prod) is met by *registration*, not by
  settings — the interceptor is only added when
  `kDebugMode && FlavorConfig.instance.flavor == Flavor.dev`, which is the same
  gate `IgdbCallLog._isOn` used. AC-18 (a logging failure never breaks the
  request) then holds by construction everywhere the gate is closed, since no
  logging code runs at all; inside a debug dev build it rests on
  `TalkerDioLogger` itself, which we do not wrap.

`Talker` from `talker_flutter` — reused as the `talker:` argument to
`TalkerDioLogger`, constructed with `TalkerSettings(useHistory: false)` exactly as
`IgdbCallLog` did. Nothing in this app can display log history, so keeping bodies
in memory would be pure cost. This is also what keeps `talker_flutter` a used
direct dependency after `IgdbCallLog` goes.

`ConfigConstants.connectTimeout` / `receiveTimeout` / `sendTimeout` at
`lib/core/res/const.dart` — reused verbatim, no new timeout constant (AC-4).

`FlavorConfig.instance` at `lib/config/flavor/flavor_config.dart` — reused for
the host, the anon key, and the logger's dev-flavour gate. Its existing
`StateError` is the loud failure AC-2 asks for, so no new guard is written.

`SupabaseClient` from `SupabaseModule` — reused as the source of the `GoTrueClient`
handed to the interceptor. Supabase is still initialised exactly once, in the same
place; only the IGDB path stops using its HTTP layer.

`BaseRepositoryMixin` and `ErrorType.dioError` at `lib/core/data/datasource/` and
`lib/core/data/models/` — reused unchanged. `ErrorType.dioError` already reads
`statusCode` and `data['error']` off a `DioException`, which is why AC-15 needs no
edit to either file.

`test/mocks/auth_mock.dart` — reused for `mockDiscordSession`; one refreshed-session
getter is added beside it rather than defining session data inline in a test.

`NetworkModule.getDioInstance` and `TwitchAuthInterceptor` — read as reference for
the `BaseOptions` shape and the retry-once idea, then deliberately not reused. Both
stay byte-for-byte as they are (AC-19).

## Out of scope

- Anything under `supabase/` (AC-20).
- Un-deprecating, reusing or deleting `NetworkModule` / `TwitchAuthInterceptor`.
- Moving any other Supabase call off the SDK — auth, database, storage and the
  connection ping all keep using `supabase_flutter`.
- Any package change other than adding `talker_dio_logger`. In particular
  `talker_flutter` stays and stays at its current constraint.
- Putting `TalkerDioLogger` on any other Dio instance in the project.
- Editing `ErrorType`, `BaseRepositoryMixin`, or the three API services.
- Extending the Dio/Retrofit pattern to any other API.
- Caching, offline handling, request deduplication, and deduplicating concurrent
  session refreshes. Two parallel 401s would each refresh; that is the same
  behaviour the SDK has today and no criterion asks for better.

## Open questions

None.

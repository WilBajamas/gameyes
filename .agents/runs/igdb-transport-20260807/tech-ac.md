# Technical Acceptance Criteria
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07
BA Agent version: 1.0

## Feature summary

Replace the transport inside `SupabaseIgdbClient` only. Today it reaches the
`igdb-proxy` Edge Function through `supabase_flutter`'s `functions.invoke`; after
this change it reaches the same function over HTTPS through a Dio client with a
Retrofit interface, a Supabase-session auth interceptor, and the shared timeout
constants. Nothing server-side moves, no caller changes, no new package. The
client's method signature, decoded return value and thrown-error behaviour are
held constant so the three services above it and their tests are untouched.

## Technical acceptance criteria

### Transport

[10.1-AC-1] DATA/TRANSPORT: `SupabaseIgdbClient.invoke` issues an HTTPS POST to
the `igdb-proxy` Edge Function URL through Dio, with a JSON body containing
exactly the keys `endpoint` and `query` carrying the method's two arguments, and
`Content-Type: application/json`.
  Failure case: a request whose body omits or renames either key gets a 400
  `{"error": ...}` from the function; that error must propagate to the caller,
  not be swallowed or retried.

[10.1-AC-2] DATA/TRANSPORT: The Dio instance's `baseUrl` resolves to the active
flavour's Supabase functions host, derived at runtime from the flavour's
configured Supabase URL. No project reference or host is hardcoded in source, and
a dev build and a prod build each hit their own project.
  Failure case: if the flavour config is unavailable at construction time, the
  client must fail loudly at startup rather than silently defaulting to a wrong
  or empty host.

[10.1-AC-3] DATA/TRANSPORT: No request originating from `SupabaseIgdbClient`
targets `api.igdb.com` or any IGDB host directly — every call goes through the
Edge Function.
  Failure case: any direct-to-IGDB URL in the client's request path fails this
  criterion outright, regardless of whether the request succeeds.

[10.1-AC-4] DATA/TRANSPORT: The Dio instance's `BaseOptions` uses
`ConfigConstants.connectTimeout`, `ConfigConstants.receiveTimeout` and
`ConfigConstants.sendTimeout`. No new timeout constant is introduced for this.
  Failure case: a request that gets no response terminates with a timeout error
  within those bounds. It must never hang indefinitely.

[10.1-AC-5] DATA/TRANSPORT: `functions.invoke` is no longer called anywhere on
the IGDB path, and `SupabaseIgdbClient` no longer depends on `FunctionsClient`.
  Failure case: n/a — this is a static check on the resulting source.

[10.1-AC-6] DATA/TRANSPORT: A single Retrofit interface declares the one
`igdb-proxy` call, with `endpoint` and `query` passed in the request body (not as
path segments or query parameters), and its generated implementation is committed.
  Failure case: if code generation has not been run, the build fails — a stale or
  missing generated file is not an acceptable end state.

### Authentication

[10.1-AC-7] DATA/AUTH: Every request carries both `Authorization: Bearer <access
token>` and `apikey: <flavour anon key>`, matching the two headers
`functions.invoke` sends today.
  Failure case: a request missing either header is rejected by the Supabase
  gateway with 401 before the function body runs.

[10.1-AC-8] DATA/AUTH: The access token is read from the current Supabase session
at request time, per request — not captured once when the Dio instance or the
interceptor is constructed. A token that changed since the previous call is used
on the next one without restarting the app.
  Failure case: a stale cached token produces a 401 that AC-9 then handles; a
  token cached for the app's lifetime fails this criterion.

[10.1-AC-9] DATA/AUTH: When there is no current session, the anon key is sent as
the bearer token, preserving today's behaviour.
  Failure case: if the gateway still rejects the call, the resulting error
  propagates to the caller unchanged.

[10.1-AC-10] DATA/AUTH: On a 401 response, the interceptor refreshes the Supabase
session and replays the same request once with the refreshed token. If the replay
succeeds, `invoke` returns its body normally and the caller never sees the 401.
  Failure case: if the replay also returns 401, that second response is what
  propagates to the caller.

[10.1-AC-11] DATA/AUTH: The replay happens at most once per originating request.
A second 401 is never retried, and the interceptor cannot recurse or loop.
  Failure case: a persistently 401ing endpoint produces exactly two HTTP requests
  and then an error — verifiable by counting requests against a mock.

[10.1-AC-12] DATA/AUTH: If the session refresh itself throws or returns no
session, the original 401 is what surfaces to the caller. The refresh failure
does not crash the app, is not retried, and does not replace the error with a
less specific one.
  Failure case: the caller receives an error carrying HTTP status 401.

[10.1-AC-13] DATA/AUTH: Statuses other than 401 (400, 405, 500, 502, and network
failures) are never retried and propagate on the first response.
  Failure case: a 502 from the function produces exactly one HTTP request.

### Client contract

[10.1-AC-14] DATA/CLIENT: `SupabaseIgdbClient.invoke({required String endpoint,
required String query})` keeps its name, parameters and `Future<Object?>` return
type. On a 2xx it returns the decoded JSON body — the same `List`/`Map` shape
callers receive today, not a raw response string and not a wrapper object.
  Failure case: a caller that today does `result as List` must keep working
  unchanged.

[10.1-AC-15] DATA/CLIENT: Errors are thrown out of `invoke`, not caught, not
converted to `null`, and not wrapped in a new project-specific exception type.
`BaseRepositoryMixin.fetchData` continues to convert them into
`Failure(ErrorType…)` with the HTTP status preserved, and `GamesApiService`,
`GameDetailApiService` and the featured repository compile and behave unchanged
with no edits.
  Failure case: a non-2xx from the proxy yields a `Failure` carrying the
  originating status code, never a `Success` and never an uncaught exception
  reaching the UI.

### Logging

[10.1-AC-16] DATA/LOGGING: In a debug build on the dev flavour, each IGDB call
writes to the console: the outgoing endpoint and query; the response body capped
at 50 lines with an explicit note stating how many lines were omitted when it was
cut; and, on failure, the error together with a full stack trace.
  Failure case: a response longer than 50 lines must be visibly marked as
  truncated, so a short log is never mistaken for a complete one.

[10.1-AC-17] DATA/LOGGING: Logging produces no output in release builds or on the
prod flavour.
  Failure case: n/a — absence of output is the pass condition.

[10.1-AC-18] DATA/LOGGING: A failure inside the logging path never fails or
delays the IGDB request itself.
  Failure case: an exception thrown while formatting a log line is swallowed and
  the request still resolves normally.

### Untouched code

[10.1-AC-19] DATA/REFERENCE: `NetworkModule` and `TwitchAuthInterceptor` are
byte-for-byte unchanged, remain `@Deprecated`, and remain unregistered in DI. The
new Dio instance and the new interceptor are separate from both.
  Failure case: n/a — static check on the diff.

[10.1-AC-20] SERVER: Nothing under `supabase/` changes. The Edge Function keeps
holding the Twitch secret, verifying the caller's JWT, and doing its own
retry-once-on-401 against Twitch.
  Failure case: n/a — static check on the diff.

### Tests

[10.1-AC-21] TEST: Unit tests cover, against a mocked Dio/HTTP layer: the request
target and body shape (AC-1); both auth headers present with the session token
(AC-7, AC-8); the anon-key fallback when there is no session (AC-9); refresh and
successful replay on 401 (AC-10); exactly two requests and no more on a repeated
401 (AC-11); no retry on a non-401 error (AC-13); the decoded return value
(AC-14); and error propagation with the status preserved (AC-15).
  Failure case: any of these behaviours must fail its test if the corresponding
  code path is removed.

[10.1-AC-22] TEST: The 50-line trim and its cut-short note keep direct test
coverage equivalent to what exists today, whatever the logging implementation
ends up being.
  Failure case: a body of exactly 50 lines is returned untouched; 51 lines is
  truncated and annotated.

[10.1-AC-23] TEST: The callers' existing test files are not edited.
`test/api/games/games_test.dart`, `test/api/game_detail/game_detail_test.dart`
and the featured repository tests pass as-is.
  Failure case: needing to touch any of them means AC-14 or AC-15 was broken.

[10.1-AC-24] TEST: `flutter analyze` and `flutter test` show no new errors or
failures against the baselines recorded in `orchestrator-state.md` (0 errors, 2
warnings, 32 info; +209 -11 with 11 known pre-existing failures).
  Failure case: any new in-scope failure is fixed or escalated per
  `.claude/pipeline/rules/execution.md`.

## Out of scope

- Any change under `supabase/` — the Edge Function, its `verify_jwt` setting, its
  Twitch token caching, its allowed-endpoint list, or item 9's server design.
- Repurposing, un-deprecating or deleting `NetworkModule` and
  `TwitchAuthInterceptor`.
- Migrating any other Supabase call (auth, database, storage, tracker) off the
  `supabase_flutter` SDK. Only the IGDB proxy path changes.
- Adding, removing or version-bumping any package. `dio`, `retrofit` and
  `retrofit_generator` are already direct dependencies; `talker_dio_logger` is
  not, and adopting it needs a deviation approval (see `ambiguities.md`).
- Changing `ErrorType`, `BaseRepositoryMixin`, or the error copy shown in the UI.
- Building the Retrofit/Dio pattern out for any other API (gaming news,
  OpenCritic, RAWG). This run establishes the pattern on one endpoint only.
- Response caching, offline handling, or request deduplication.

## Assumptions

ASSUMPTION: "Public signature unchanged" covers the `invoke` method only; the
constructor's injected dependency changes with the transport.

ASSUMPTION: With no session, the anon key is sent as the bearer token, matching
what `functions.invoke` does today.

ASSUMPTION: A timeout may now surface as `ErrorType.connectionTimeout()` /
`receiveTimeout()` rather than `ErrorType.unknown()`. No UI branches on the
variant; what is held constant is that it fails within the timeout and becomes a
`Failure`.

ASSUMPTION: A non-2xx body's `{"error": ...}` text now lands in
`ResponseError.error` rather than `ResponseError.message`. Status code is
preserved on both paths and no UI reads either field.

ASSUMPTION: `IgdbCallLog` is kept and `TalkerDioLogger` is not adopted — it is
not a dependency, and it covers neither the 50-line trim nor the call-site stack
trace out of the box. Full findings in `ambiguities.md`; AC-16 to AC-18 state the
bar in implementation-neutral terms if the Tech Lead overturns this.

ASSUMPTION: `test/api/supabase/supabase_igdb_client_test.dart` will be rewritten;
it mocks `FunctionsClient` and cannot survive the transport change.

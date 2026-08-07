# QA Report
Source: `.agents/week-1-task-briefs.md` §10.1 — IGDB client transport: Dio + Retrofit
Date: 2026-08-07

Overall result: PASS — pending manual checks

Commit verified: `5385338` on `claude/questloggd-item-10-1-igdb-ogvf5r`
(base `cf3ddc6`). Scope checked against `git diff`, not `diff-summary.md`.

## Manual verification required

10.1-AC-16 — Run a **debug dev** build, open the games list and one game
detail — expect each IGDB call to print its request line and the
`{endpoint, query}` body to the console, and a failed call to print status,
message and the function's error body. The 50-line response trim, its
omitted-line note, and the caller stack trace are gone by approved deviation;
do not expect them.

10.1-AC-17 — Run a **release** build and a **prod-flavour** build, exercise
the games list — expect zero IGDB transport output in the console.

10.1-AC-2 — Run a dev build and a prod build — expect each to hit its own
Supabase project host (verifiable from the logger output in the dev build).

10.1-AC-10 — With an expired access token (or after forcing a 401), open the
games list — expect the list to load normally with no error shown to the user.

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` ran clean and left
the working tree unchanged — every committed generated file is current, so
analysis ran against fresh output.

`flutter analyze`: 0 errors, 2 warnings, 32 info — matches the recorded
`Analyzer baseline` exactly. Both warnings are in
`lib/features/tracker/presentation/screens/task_detail_screen.dart`
(pre-existing, out of scope). No issue of any severity is attributed to an
allowlisted file.

## Test results

Status: PASS
Tests run: 229  |  Passed: 218  |  Failed: 11

All 11 failures are the recorded pre-existing ones, confirmed by file:
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3),
`test/widget_test.dart` (1). Zero new failures.

Count reconciliation independently verified, not taken from `diff-summary.md`:
the deleted `igdb_call_log_test.dart` held 4 tests and
`supabase_igdb_client_test.dart` held 3 (counted from the base commit); the new
`supabase_igdb_proxy_service_test.dart` holds 7 and
`igdb_proxy_auth_interceptor_test.dart` holds 9. 220 − 7 + 16 = 229, matching
the observed total. The arithmetic in `diff-summary.md` is correct.

`coverage/lcov.info` is modified in the working tree — QA-induced by
`flutter test --coverage`, not a scope violation. Nothing else is uncommitted.

## Coverage gaps (coverage mode only)

NONE. Every criterion AC-1 through AC-15 has both a success and a
failure/error case, except the three logging criteria (AC-16 to AC-18), which
the task brief deliberately leaves untested — the logger is a third-party
interceptor behind a build-mode gate with nothing of ours to assert. That is a
brief-level decision, not a gap this run introduced.

## Acceptance criteria

10.1-AC-1: PASS — `supabase_igdb_proxy_service.dart:13-14` (`@POST` to
`functionPath`, `@Body() Map<String, String>`); tests
`supabase_igdb_proxy_service_test.dart` 'should post to the igdb-proxy function
url when invoke is called', 'should send only the endpoint and query keys in
the body' (asserts exactly 2 keys), 'should send a json content type'. Failure
case covered by 'should throw the error with its status when the proxy answers
400'.

10.1-AC-2: MANUAL — code is right: `igdb_proxy_module.dart:19-21` builds
`baseUrl` from `FlavorConfig.instance.supabaseUrl` +
`SupabaseIgdbProxyConstants.functionsBasePath`; no host or project ref is
hardcoded (the only `api.igdb.com` literal in `lib/` is the pre-existing
`IGDBConfig.igdbBaseUrl`, unreachable from this path). Failure case holds:
`flavor_config.dart:42-51` throws `StateError` when uninitialised, and
`service_locator.config.dart:173` registers via `gh.singleton` (eager), so a
missing flavour config fails at `configureDependencies()`, not silently. Human
must confirm dev and prod builds each hit their own project.

10.1-AC-3: PASS — `supabase_igdb_proxy_service_test.dart` 'should not send
anything to an igdb host'; the request URI is asserted in full at
`supabase_igdb_proxy_service_test.dart:52-56`.

10.1-AC-4: PASS — `igdb_proxy_module.dart:26-28` uses
`ConfigConstants.connectTimeout` / `receiveTimeout` / `sendTimeout`. No new
timeout constant: `SupabaseIgdbProxyConstants.requestTimeout` was removed
(`const.dart` diff) and nothing replaced it.

10.1-AC-5: PASS — `grep` over `lib/` returns no `functions.invoke` and no
`FunctionsClient`. Met more completely than written: the class that held the
dependency, `supabase_igdb_client.dart`, is deleted.

10.1-AC-6: PASS — one `@RestApi()` interface with one method
(`supabase_igdb_proxy_service.dart:9-15`), body-passed not path/query;
`supabase_igdb_proxy_service.g.dart` is committed and confirmed current — a
fresh `build_runner` run produced no diff.

10.1-AC-7: PASS — `igdb_proxy_auth_interceptor.dart:28-30`; test 'should send
the session token and the anon key when somebody is signed in'.

10.1-AC-8: PASS — the token is read inside `onRequest`
(`igdb_proxy_auth_interceptor.dart:28`), not captured in the constructor; test
'should use the newer token when the session changed between calls' asserts the
second request carries the newer token with no re-construction.

10.1-AC-9: PASS — `?? _anonKey` at `igdb_proxy_auth_interceptor.dart:28`; test
'should send the anon key as the bearer token when nobody is signed in'.

10.1-AC-10: MANUAL — code and unit test are correct
(`igdb_proxy_auth_interceptor.dart:42-62`; test 'should refresh and try again
once when the proxy answers 401' asserts a 200 returns to the caller and the
replay carried the refreshed token). Marked MANUAL only for the real-network
confirmation listed above; the coded behaviour itself is PASS.

10.1-AC-11: PASS — the `_replayedKey` guard at
`igdb_proxy_auth_interceptor.dart:40,55`; test 'should make exactly two requests
when the second answer is also 401' asserts `.called(2)` on the adapter and
`.called(1)` on `refreshSession`.

10.1-AC-12: PASS — `igdb_proxy_auth_interceptor.dart:47-53` passes the original
error on both when refresh throws and when it yields a null session; tests
'should surface the original 401 when the refresh throws' and 'should surface
the original 401 when the refresh returns no session', each asserting status 401
and exactly one request.

10.1-AC-13: PASS — the `statusCode != 401` early return at
`igdb_proxy_auth_interceptor.dart:42-44`; tests 'should not try again when the
proxy answers 502' and 'should not try again when the request fails without a
response', both asserting one request and `verifyNever(refreshSession)`.

10.1-AC-14: PASS (read one layer up, per the Phase 3 delta) — `invoke` returns
the decoded body untouched (`supabase_igdb_proxy_service.g.dart` returns
`_result.data`; test 'should return the decoded list when the proxy answers
200' asserts `isA<List>()` and the first element's map). The three services keep
their names, parameters, return types and `body is! List` → `fromJson` bodies —
the diff on `games_api_service.dart`, `game_detail_api_service.dart` and
`featured_api_service.dart` touches only the field type, its name and the one
call line. Nothing above the API services changed.

10.1-AC-15: PASS ("no edits" clause void per approved deviation) — nothing
catches or wraps: the interceptor's `onError` only ever calls `handler.next(err)`
or forwards the replay's own `DioException`. `BaseRepositoryMixin` and
`ErrorType` are untouched (not in the diff). The datasource-level tests 'should
throw DioException when the proxy call fails' in both `games_test.dart` and
`game_detail_test.dart` confirm the error reaches the caller unconverted, and
`mockDioException` carries status 502 on both the exception and its response.

10.1-AC-16: MANUAL (partially waived by approved deviation) — the endpoint and
query survive: `TalkerDioLogger`'s defaults have `printRequestData = true`, so
the `{endpoint, query}` body prints; `printErrorData` and `printErrorMessage`
are also true, so a failure prints its error body. The 50-line trim, its
omitted-line note, and the caller stack trace are knowingly not delivered — this
is the human-approved deviation of 2026-08-07, not a defect. Console check
listed above.

10.1-AC-17: MANUAL — the gate is at registration, as required:
`igdb_proxy_module.dart:45` adds the logger only inside
`if (kDebugMode && config.flavor == Flavor.dev)`. Release/prod silence follows
from the gate but needs the build check listed above.

10.1-AC-18: PASS where the gate is closed (in release or on prod there is no
logging code in the chain at all — `igdb_proxy_module.dart:45`), and rests on
`TalkerDioLogger` where it is open, per the approved deviation. Worth recording
positively: the module leaves `printRequestHeaders` at its default `false`, and
`printErrorHeaders` (default `true`) prints the *response* headers, not the
request's — verified in the package at
`talker_dio_logger-5.1.20/lib/dio_logs.dart:197,216`. The bearer token is not
printed on either path.

10.1-AC-19: PASS — `git diff` shows no change to
`lib/core/di/network_module.dart` or
`lib/core/services/api/twitch_auth_interceptor.dart`. Both still carry
`@Deprecated` (`network_module.dart:8`, `twitch_auth_interceptor.dart:6`) and
neither appears in `service_locator.config.dart`. The new Dio is built inside
`IgdbProxyModule` and is not registered on its own.

10.1-AC-20: PASS — nothing under `supabase/` appears in
`git diff --name-status cf3ddc6..5385338`.

10.1-AC-21: PASS — every listed behaviour has a test, named above under its own
criterion: AC-1 (3 tests), AC-7/AC-8 (2), AC-9 (1), AC-10 (1), AC-11 (1),
AC-13 (2), AC-14 (1), AC-15 (2 error-propagation tests plus the 400 and 502
cases). 16 new tests across the two new files.

10.1-AC-22: NOT APPLICABLE — superseded, human-approved. The 50-line trim no
longer exists, so there is nothing to cover. No replacement test was written,
which is correct.

10.1-AC-23: NOT MET — knowingly and human-approved (Phase 3 gate, recorded in
`orchestrator-state.md ## Deviation approvals`). `games_test.dart` and
`game_detail_test.dart` are edited. The edits are confined to what the brief
authorised: the mock type swap, the single-map argument form, and the one
error-propagation test per file changing from `FunctionException` to
`DioException`. Every other test name, stub and assertion is byte-identical —
verified line by line in the diff. Not counted as a QA failure.

10.1-AC-24: PASS — analyzer identical to baseline (0/2/32); tests show zero new
failures against `+209 -11`, with the count movement fully explained by the two
deleted and two added test files.

## Architectural compliance

Status: PASS

Checked against `tdd.md`: `SupabaseIgdbProxyService` /
`_SupabaseIgdbProxyService` naming and the `factory … = _…` form
(`tdd.md:83-88`); `IgdbProxyAuthInterceptor` extends `Interceptor`, not
`QueuedInterceptor`, as `tdd.md:143-144` specifically requires so the replay can
re-enter the same Dio; `IgdbProxyModule` is an `@module abstract class` with one
`@singleton` provider taking the registered `SupabaseClient`
(`tdd.md:170-172`); the bare `Dio` is deliberately not registered
(`tdd.md:183`); file paths all match. One new package only,
`talker_dio_logger`, which is the approved one — `pubspec.yaml` gained exactly
one line and `pubspec.lock` gained exactly one entry (5.1.20).

FAILs: NONE

WARNINGs: `test/mocks/auth_mock.dart` shows ~90 changed lines where the brief
authorised only "add one refreshed-session getter. Nothing existing in this file
changes." The extra churn is entirely `dart format` reflowing the pre-existing
getters to the current formatter style — no value, name, type or behaviour of
any existing fixture changed, and `mockDiscordSession`, `mockGoogleSession` and
`mockAuthException` are semantically identical. Harmless, and it makes the file
consistent with the rest of `test/mocks/`, but it does inflate the diff beyond
what was authorised.

## Known and accepted, not findings

`BaseRepositoryMixin`'s `on FunctionException` branch, `ErrorType.
supabaseIgdbError`, `mockFunctionException` and `games_repository_test.dart`'s
"throws FunctionException" test are now unreachable — the only producer of
`FunctionException` was the deleted `supabase_igdb_client.dart`. Confirmed still
present and still passing, correctly left untouched per
`orchestrator-state.md ## Follow-up`. Deferred to a separate run by human
decision; not a defect in this one.

## Escalation required

NONE

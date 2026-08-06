# QA Report
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-06

QA re-run after the resolved REQ-9.3 escalation. Verified against HEAD
`d066267ececc3936a9b4e177ccffa4767809dd98` on `feature/igdb-client-repoint`.
`git diff ee52b4a..HEAD -- lib test` is empty — no source or test file changed
since the previous QA run, so unchanged criteria are re-confirmed rather than
re-derived. The three commits since then touch only `.agents/` and
`coverage/lcov.info`. Working tree clean.

Overall result: PASS

Both REQ-9.3 criteria now PASS under the reference-code carve-out added to
`tech-ac.md` on 2026-08-06 (human decision at the QA gate, recorded in
`orchestrator-state.md ## Deviation approvals`). All three carve-out conditions
are met — verified below, not assumed.

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` — clean, wrote 0
outputs, `git status --short` empty afterwards. Generated code is current.

`flutter analyze` — 34 issues: 0 errors, 2 warnings, 32 info. Baseline
(`orchestrator-state.md`): 0 errors, 2 warnings, 36 info. No new issue. Both
warnings are pre-existing, in
`lib/features/tracker/presentation/screens/task_detail_screen.dart:201, 204`
(outside the allowlist). The only allowlisted-file issue is
`test/repository/games/games_repository_test.dart:62 • avoid_redundant_argument_values`
(info — does not fail QA). The two restored `@Deprecated` reference files
produce no analyzer issue.

## Test results

Status: PASS
Tests run: 211  |  Passed: 200  |  Failed: 11
Testing mode: `coverage` (ran `flutter test --coverage`; `coverage/lcov.info`
rewritten by QA, not a scope violation)

Baseline: +187 -13. All 11 failures are exactly the recorded pre-existing set
minus the two `test/api/` files that were rewritten:

- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)
- `test/widget_test.dart` (1)

No regression. Every allowlisted test file passes.

## Coverage gaps (coverage mode only)

- REQ-9.2 (featured): no test exercises `FeaturedApiService` — success or
  failure. Accepted by design, not a defect: `task-brief.md ## Constraints`
  explicitly says "FeaturedApiService has no dedicated API test … Do not add
  one". Verified by code inspection instead; recorded for visibility.
- REQ-NC (repository error mapping): the `ErrorType.supabaseIgdbError` fallback
  branch — a `FunctionException` whose `details` is not a map carrying `error`,
  which must yield `ErrorType.unknown()` (`lib/core/data/models/error.dart:50`)
  — has no test. The map-carrying path is covered.
- REQ-NC (30s timeout): covered only at the client seam
  (`test/api/supabase/supabase_igdb_client_test.dart:69`). Deliberate per
  `code-plan.md ## Approved feedback delta 2`, Decision 1.

## Acceptance criteria

REQ-9.2 DATA (games list via proxy, no `api.igdb.com`): PASS —
`lib/features/games/data/datasources/games_datasource.dart:34` →
`lib/features/games/services/games_api_service.dart:14-18` →
`lib/core/services/supabase/supabase_igdb_client.dart:17-22`
(`functions.invoke('igdb-proxy', body: {endpoint, query})`). Asserted by
`test/api/games/games_test.dart` "should send the games endpoint and the built
query to the proxy when fetching games" and the search-branch case at :59. No
Dio remains on this path (`igdb_api_service.dart` deleted). Failure case:
"should throw FunctionException when the proxy call fails" (:113) plus the
repository mapping test below.

REQ-9.2 DATA (`games` array decoded to `Game`, same `GamesModel` wrapper): PASS —
`games_api_service.dart:27-39`; wrapper unchanged at `games_datasource.dart:36`.
Test "should return GamesModel with count 0 and decoded games when the proxy
returns a JSON array" (:85). Failure case: "should throw when the proxy reply is
not a JSON array" (:99) — errors out, never a silent empty list.

REQ-9.2 DATA (game detail, first element): PASS —
`lib/features/game_detail/services/game_detail_api_service.dart:13-26`,
`game_detail_datasource.dart:23-25` still `response.first`. Tests
`test/api/game_detail/game_detail_test.dart` :31, :56. Failure case: "should
throw when the proxy returns an empty array" (:70) asserts `StateError` — the
pre-existing rough edge is preserved, not fixed, as required.

REQ-9.2 DATA (featured's three reads via the proxy): PASS —
`lib/features/featured/data/repositories/featured_repository_impl.dart:84, 100,
144, 198, 213` all call `_featuredApiService.fetchGames`, routing through
`FeaturedApiService` → `SupabaseIgdbClient`. `IgdbApiService` import removed
(:9). The existing `catch` blocks returning `Failure(ErrorType.unknown())` are
untouched. Evidence is code-only — see the accepted coverage gap above.

REQ-9.2 DATA (release dates path): PASS — `games_api_service.dart:20-24` with
`SupabaseIgdbProxyConstants.releaseDatesEndpoint`. Test "should send the release
dates endpoint and decode into ReleaseDate when fetching release dates"
(`test/api/games/games_test.dart:127`). Failure handling is the shared
`_decodeList`, covered by the non-array and `FunctionException` cases.

REQ-NC DATA (query text byte-identical): PASS — `git diff da60905..HEAD` on both
datasources and `featured_repository_impl.dart` shows no change to any
`IGDBQueryBuilder` chain: field sets, `limit`, `offset((page - 1) * pageSize)`,
the search-suppresses-sort branch (`games_datasource.dart:28-32`) and the
`where`/`sort` clauses are untouched; only the injected dependency, the call
target and two stale comments changed. Independently asserted by the two games
tests, which rebuild the expected query with the real builder and match exactly.

REQ-NC REPOSITORY (repositories never throw; status + message preserved): PASS —
`lib/core/data/datasource/base_repository_mixin.dart:15-16` adds the
`on FunctionException` branch; `lib/core/data/models/error.dart:46-56` maps
`details['error']` + `exception.status` to `ErrorType.responseError`, and
anything else to `ErrorType.unknown()`. Test
`test/repository/games/games_repository_test.dart` — "should return Failure
carrying the proxy status code and message when the datasource throws
FunctionException". Pre-existing `DioException` branch and generic `catch`
unchanged.

REQ-NC DATA (30s timeout, not a hang): PASS — `supabase_igdb_client.dart:22`
chains `.timeout(SupabaseIgdbProxyConstants.requestTimeout)` (30s, defined in
`lib/core/res/const.dart`). Test "should fail rather than hang when the function
does not answer within 30 seconds"
(`test/api/supabase/supabase_igdb_client_test.dart:69`) — a never-completing
stub throws `TimeoutException` after a 31s pump. Non-IGDB Supabase traffic is
untouched: only `SupabaseIgdbClient` applies the timeout.

REQ-9.3 CONFIG (Twitch ID and secret gone from the build): PASS, under the
reference-code carve-out — the criterion's failure case is now "any hit not
covered by the reference-code carve-out". A case-insensitive search for `twitch`
under `lib/` returns 14 hits in exactly two files, both carve-out files:
`lib/core/services/api/twitch_auth_interceptor.dart` (11) and
`lib/core/di/network_module.dart` (3). No hit anywhere else. All three carve-out
conditions verified at HEAD:
- `@Deprecated` — `twitch_auth_interceptor.dart:15-18`, `network_module.dart:25-28`.
- No real credential — `twitch_auth_interceptor.dart:20-21` holds the literal
  placeholder `'REMOVED_BY_ITEM_9'` for both id and secret. No
  `TWITCH_CLIENT_ID` / `TWITCH_CLIENT_SECRET` envied field and no `Env.twitch*`
  accessor exists (the single `Env.twitch` string under `lib/` is prose in the
  comment at `twitch_auth_interceptor.dart:11`); the envied generated output
  contains no `twitch`.
- Unregistered in DI — no `@injectable`/`@module`/`@singleton` annotation on
  either class, and `lib/core/di/service_locator.config.dart` contains no
  `Twitch`, `NetworkModule` or `Dio` match.

REQ-9.3 NETWORKING (direct-to-IGDB stack deleted from active use): PASS, under
the same carve-out — the amended criterion reads "deleted from active use, not
left wired up". Both Retrofit services and their `.g.dart` files are deleted
(`igdb_api_service.dart`, `game_detail_service.dart`, both `.g.dart`, per
`git diff --name-only da60905..HEAD`), and DI generated output is regenerated
without them. The only remaining reference to either carve-out file is
`network_module.dart:5` importing `twitch_auth_interceptor.dart` — internal to
the carve-out pair, not a dangling import, and nothing else under `lib/` imports
either file. `NetworkModule`'s two Retrofit provider methods are a comment
(:20-24) since their return types are gone. No unresolvable DI registration:
`build_runner` runs clean and `service_locator.config.dart` has no entry for
`Dio`, `IgdbApiService`, `GameDetailService`, `NetworkModule` or
`TwitchAuthInterceptor`. No new analyzer error against the Phase 0 baseline.

REQ-NC APP (both flavours build and start, screens load real data): PASS —
recorded in `orchestrator-state.md ## Code review outcomes`: human on-device
testing at `434c50f` covering games list, search, pagination, game detail, all
three Featured sections, offline/retry and a fresh install/startup check. `lib/`
at HEAD is byte-identical to `434c50f`, so that result still applies. DI graph
resolves — all four new classes are registered
(`service_locator.config.dart:185-234, 273`).

REQ-NC TEST (API tests exercise the proxy path, not Dio): PASS —
`test/api/games/games_test.dart` and `test/api/game_detail/game_detail_test.dart`
are rewritten against `MockSupabaseIgdbClient`; no `DioAdapter` and no IGDB
stand-in URL remains in either. Repository, bloc, cubit and use-case expectations
are unchanged apart from the one appended proxy-failure case. No new test failure
beyond baseline.

## Architectural compliance

Status: PASS
FAILs: NONE

Checked against `code-plan.md ## Approved feedback delta 2` and `task-brief.md`,
which supersede `tdd.md` on class names and design. All four class names, file
paths and constructor field names match; `SupabaseIgdbClient` returns `Object?`
and never names a model type, so `lib/core/` still does not import
`lib/features/`; the three-way `if (body is! List)` repeat is intact and
`_decodeList<T>` is private to `games_api_service.dart`; the timeout exists in
exactly one place with no constructor parameter; all four classes are plain
`@injectable`; no package added to `pubspec.yaml`; no `getIt<T>()` in a feature
class; no generated file hand-edited.

WARNINGs:
1. Two names drift from `task-brief.md` — `IgdbProxyConstants` is
   `SupabaseIgdbProxyConstants` (`lib/core/res/const.dart:90`) and
   `ErrorType.functionError` is `ErrorType.supabaseIgdbError`
   (`lib/core/data/models/error.dart:46`). Both from human commits `8f9f9bf` /
   `5cd8a4f`, applied consistently at every call site, no behaviour change.
   Approved deviation — `orchestrator-state.md ## Deviation approvals`
   2026-08-06 records that `task-brief.md` and `code-plan.md` delta 1 are left
   naming the old identifiers by explicit human instruction. Recorded as a
   WARNING for the next reader of those two documents, not as an open issue.
2. `test/repository/games/games_repository_test.dart` — the two pre-existing
   cases were reformatted to the newer trailing-comma style, against the "change
   nothing existing" instruction. Formatting only; assertions and results
   unchanged. Same reformatting in `test/mocks/error_mock.dart`.
3. `.agents/references/flutter-arch.md` and `api-contracts.md` remain stale
   (Dio/Retrofit/Twitch described as current). Deliberately out of scope per
   `code-plan.md` delta 2; the documentation follow-up is still open.

## Scope

Verified with `git diff --name-only da60905..HEAD` and `git status --short`, not
from `diff-summary.md`'s self-report.

- Working tree clean — no uncommitted change.
- Every `lib/` and `test/` path in the diff is on the allowlist or is a generated
  output of an allowlisted source (`service_locator.config.dart`, `*.mocks.dart`).
  Nothing outside the allowlist was touched. `coverage/lcov.info` is QA-induced.
- `lib/core/services/api/twitch_auth_interceptor.dart` and
  `lib/core/di/network_module.dart` are listed under **DELETE** but git shows
  them as `M` at HEAD. Both are on the allowlist, so not a scope violation; the
  allowlisted DELETE action was deliberately not performed, now covered by the
  approved deviation and the `tech-ac.md` carve-out. `task-brief.md`'s two DELETE
  entries are knowingly stale.
- `diff-summary.md` is accurate for the Dev commit `df1456f` it describes; it
  does not cover the four later commits and so still lists both files as deleted
  and the old identifier names. Nothing appears in git that `diff-summary.md`
  failed to mention.

## Escalation required

NONE

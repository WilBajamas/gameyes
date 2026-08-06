# QA Report
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-06

Verified against HEAD `ee52b4acc2b21d70f696dbbbb0440df32a72b576` on
`feature/igdb-client-repoint` (`lib/` and `test/` are byte-identical to the
reviewed commit `434c50f`). Working tree clean.

Overall result: FAIL

Both REQ-9.3 criteria fail as written, caused solely by the human-directed
restoration of `TwitchAuthInterceptor` and `NetworkModule` as deprecated
reference. Everything else — the transport swap, the timeout, the error mapping,
analysis and tests — passes. This is a criteria-vs-decision conflict for the
human, not a Dev defect.

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` — clean, wrote 0
outputs, no git diff. Generated code is current.

`flutter analyze` — 34 issues: 0 errors, 2 warnings, 32 info. Baseline
(`orchestrator-state.md`): 0 errors, 2 warnings, 36 info. No new issue. Both
warnings are pre-existing and in `lib/features/tracker/presentation/screens/task_detail_screen.dart`
(outside the allowlist). The only allowlisted-file issue is
`test/repository/games/games_repository_test.dart:62 • avoid_redundant_argument_values`
(info — does not fail QA). The restored deprecated files produce no analyzer
issue.

## Test results

Status: PASS
Tests run: 211  |  Passed: 200  |  Failed: 11
Testing mode: `coverage` (ran `flutter test --coverage`; `coverage/lcov.info`
rewritten by QA, not a scope violation)

Baseline: +187 -13. All 11 failures are the recorded pre-existing set minus the
two `test/api/` files that were rewritten:

- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)
- `test/widget_test.dart` (1)

No regression. Every allowlisted test file passes.

## Coverage gaps (coverage mode only)

- REQ-9.2 (featured): no test exercises `FeaturedApiService` — success or
  failure. Accepted by design, not a defect: `task-brief.md ## Constraints`
  explicitly says "FeaturedApiService has no dedicated API test … Do not add
  one". Verified by code inspection instead; recorded here for visibility.
- REQ-NC (repository error mapping): the `ErrorType.supabaseIgdbError` fallback
  branch — a `FunctionException` whose `details` is not a map carrying `error`,
  which must yield `ErrorType.unknown()` (`lib/core/data/models/error.dart:50`)
  — has no test. The map-carrying path is covered.
- REQ-NC (30s timeout): covered only at the client seam
  (`supabase_igdb_client_test.dart:69`). Deliberate per
  `code-plan.md ## Approved feedback delta 2`, Decision 1.

## Acceptance criteria

REQ-9.2 DATA (games list via proxy, no `api.igdb.com`): PASS —
`lib/features/games/data/datasources/games_datasource.dart:34` →
`lib/features/games/services/games_api_service.dart:14-18` →
`lib/core/services/supabase/supabase_igdb_client.dart:17-22`. Asserted by
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
144, 198, 213` all call `_featuredApiService.fetchGames`, which routes through
`FeaturedApiService` → `SupabaseIgdbClient`. `IgdbApiService` import removed
(:9). The existing `catch` blocks returning `Failure(ErrorType.unknown())` are
untouched. Evidence is code-only — see the accepted coverage gap above.

REQ-9.2 DATA (release dates path): PASS —
`games_api_service.dart:20-24` with
`SupabaseIgdbProxyConstants.releaseDatesEndpoint`. Test "should send the release
dates endpoint and decode into ReleaseDate when fetching release dates"
(`games_test.dart:127`). Failure handling is the shared `_decodeList`, covered by
the non-array and `FunctionException` cases.

REQ-NC DATA (query text byte-identical): PASS — `git diff base..HEAD` on both
datasources and `featured_repository_impl.dart` shows no change to any
`IGDBQueryBuilder` chain: field sets, `limit`, `offset((page - 1) * pageSize)`,
the search-suppresses-sort branch (`games_datasource.dart:28-32`) and the
`where`/`sort` clauses are untouched; only the injected dependency, the call
target and two stale comments changed. Independently asserted by the two
games tests, which rebuild the expected query with the real builder and match it
exactly.

REQ-NC REPOSITORY (repositories never throw; status + message preserved): PASS —
`lib/core/data/datasource/base_repository_mixin.dart:15-16` adds the
`on FunctionException` branch; `lib/core/data/models/error.dart:46-56` maps
`details['error']` + `exception.status` to `ErrorType.responseError`, and
anything else to `ErrorType.unknown()`. Test
`test/repository/games/games_repository_test.dart` — "should return Failure
carrying the proxy status code and message when the datasource throws
FunctionException". Pre-existing `DioException` branch and generic `catch`
unchanged.

REQ-NC DATA (30s timeout, not a hang): PASS —
`supabase_igdb_client.dart:22` chains
`.timeout(SupabaseIgdbProxyConstants.requestTimeout)` (30s,
`lib/core/res/const.dart`). Test "should fail rather than hang when the function
does not answer within 30 seconds" (`supabase_igdb_client_test.dart:69`) — a
never-completing stub throws `TimeoutException` after a 31s pump. Non-IGDB
Supabase traffic is untouched: only `SupabaseIgdbClient` applies the timeout and
nothing else injects it.

REQ-9.3 CONFIG (Twitch ID and secret gone from the build): **FAIL** — the
criterion's own failure case is "a case-insensitive search for `twitch` under
`lib/` returning any hit is a fail". There are 13 hits, all in the two restored
files:
- `lib/core/services/api/twitch_auth_interceptor.dart` — 11 hits, including the
  class name, the live endpoint `https://id.twitch.tv/oauth2/` (:29), and
  `_twitchClientId` / `_twitchClientSecret` (:20-21).
- `lib/core/di/network_module.dart` — 2 hits (:5 import, :10 comment).

The narrower clause of the criterion does hold: no `TWITCH_CLIENT_ID`,
`TWITCH_CLIENT_SECRET` or `Env.twitch*` reference survives — both `@EnviedField`s
are gone from `lib/config/config_envied.dart`, both constants are gone from
`ConfigConstants`, the envied generated output is regenerated without them, and
the two restored references are the literal placeholder `'REMOVED_BY_ITEM_9'`.
**No real credential is in the build.** The failure is against the criterion as
written, not a security regression.

REQ-9.3 NETWORKING (direct-to-IGDB stack deleted, not left unused): **FAIL** —
`TwitchAuthInterceptor` and `NetworkModule` are present at HEAD and unused, which
is the exact state the criterion forbids ("deleted, not left unused"). What does
pass: both Retrofit services and their `.g.dart` files are deleted, the DI
annotations are stripped so nothing is registered (`injectable_builder` reports
2 no-op; `lib/core/di/service_locator.config.dart` contains no `Dio`,
`IgdbApiService`, `GameDetailService`, `NetworkModule` or `TwitchAuthInterceptor`
entry), there is no dangling import, and no new analyzer error.

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
   (`lib/core/data/models/error.dart:46`). Both come from the human follow-up
   commits `8f9f9bf` / `5cd8a4f`, both are applied consistently at every call
   site, and neither changes behaviour. Harmless, but `task-brief.md` and
   `code-plan.md` delta 1 now name classes that do not exist.
2. `test/repository/games/games_repository_test.dart` — the two pre-existing
   cases were reformatted to the newer trailing-comma style, against the
   "change nothing existing" instruction. Formatting only; assertions and
   results are unchanged. Same reformatting appears in `test/mocks/error_mock.dart`.
3. `.agents/references/flutter-arch.md` and `api-contracts.md` remain stale
   (Dio/Retrofit/Twitch described as current). Deliberately out of scope per
   `code-plan.md` delta 2; the documentation follow-up is still open.

## Scope

Verified with `git diff --name-only da60905..ee52b4a` and `git status --short`,
not from `diff-summary.md`'s self-report.

- Working tree clean — no uncommitted change.
- Every `lib/` and `test/` path in the diff is on the allowlist or is a generated
  output of an allowlisted source (`service_locator.config.dart`, `*.mocks.dart`).
  No file outside the allowlist was touched.
- One departure from the allowlist's intent, not from its file set:
  `lib/core/services/api/twitch_auth_interceptor.dart` and
  `lib/core/di/network_module.dart` are listed under **DELETE**. Git shows them
  as `M` (modified), not `D`, at HEAD — the Dev commit `df1456f` deleted both
  correctly; commit `434c50f` restored them. Both files are on the allowlist, so
  this is not a scope violation, but the allowlisted action was not performed.
- `diff-summary.md` is accurate for the Dev commit `df1456f` it describes; it
  does not cover the three later commits and so still lists both files as
  deleted. Nothing appears in git that `diff-summary.md` failed to mention.
- `orchestrator-state.md ## Deviation approvals` reads NONE, yet the restoration
  is a live deviation from two acceptance criteria. It is documented in the same
  file's notes as human-directed and reviewed, but there is no approval line
  covering it.

## Escalation required

REQ-9.3 CONFIG and REQ-9.3 NETWORKING both FAIL as written, because two files the
allowlist marks DELETE were deliberately restored after the Dev commit at the
human's request → route to: **Human**

Routing rationale: nothing here is a Dev defect and nothing is a `tdd.md`
deviation, so neither Dev Agent nor Tech Lead Agent can resolve it. The conflict
is between a human decision already made and two criteria that passed the Phase 1
gate. It needs the human to pick one:

1. Re-delete both files (QA then re-runs and this becomes a full PASS), or
2. Amend REQ-9.3 to permit deprecated, unregistered reference code containing the
   string `twitch` but no credential, and record a
   `## Deviation approvals` line for it.

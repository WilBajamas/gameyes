# Task Brief
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-05

## Context

Move every IGDB read onto the deployed `igdb-proxy` Edge Function and delete the
direct-to-IGDB stack, so no Twitch or IGDB credential ships in the client.

## Testing mode

`coverage` — Rule applied: shared utility used by 3+ features (`IgdbProxyService`
is consumed by games, game_detail and featured). Justification: it also carries the
timeout and array-decode logic that three acceptance criteria turn on.

## File allowlist

### CREATE NEW
lib/core/services/supabase/igdb_proxy_client.dart — thin wrapper that invokes the `igdb-proxy` function and returns its reply untouched
lib/core/services/api/igdb_proxy_service.dart — applies the 30s timeout and decodes the returned JSON array into models

### MODIFY EXISTING
lib/core/res/const.dart — add `IgdbProxyConstants`; delete `twitchClientId` and `twitchClientSecret`
lib/config/config_envied.dart — delete the `twitchClientId` and `twitchClientSecret` fields
lib/core/data/models/error.dart — add an `ErrorType.functionError` factory next to `dioError`
lib/core/data/datasource/base_repository_mixin.dart — add one `on FunctionException` branch to `fetchData`
lib/features/games/data/datasources/games_datasource.dart — inject `IgdbProxyService`; query building unchanged
lib/features/game_detail/data/datasources/game_detail_datasource.dart — inject `IgdbProxyService`; query building unchanged
lib/features/featured/data/repositories/featured_repository_impl.dart — inject `IgdbProxyService`; five call sites, nothing else

### DELETE
lib/features/games/services/igdb_api_service.dart — Retrofit IGDB service (delete its generated `.g.dart` with it)
lib/features/game_detail/services/game_detail_service.dart — Retrofit IGDB service (delete its generated `.g.dart` with it)
lib/core/services/api/twitch_auth_interceptor.dart — Twitch token fetch and 401 retry, now server-side
lib/core/di/network_module.dart — only registers the IGDB `Dio` instance and the two deleted services

### TEST FILES
test/api/games/games_test.dart — rewrite against the proxy path: invoke body, array decode, release dates, timeout, failure
test/api/game_detail/game_detail_test.dart — rewrite against the proxy path: invoke body, array decode, failure
test/mocks/game_mock.dart — add a raw IGDB games JSON array fixture
test/mocks/game_detail_response_mock.dart — add a raw IGDB game-detail JSON array fixture
test/mocks/release_date_mock.dart — release date model and raw JSON array fixtures
test/mocks/error_mock.dart — add a `FunctionException` fixture
test/repository/games/games_repository_test.dart — append one case for the proxy failure mapping; change nothing existing

Never list generated files (`*.freezed.dart`, `*.g.dart`, `*.gr.dart`,
`*.config.dart`, `*.mocks.dart`) — they're implicit for any allowlisted
annotated source.

## Implementation plan

Step 1: `lib/core/res/const.dart` — add an `IgdbProxyConstants` class holding the
function name `igdb-proxy`, the endpoint names `games` and `release_dates`, and a
30-second `requestTimeout`; delete `ConfigConstants.twitchClientId` and
`twitchClientSecret`. Leave every other constant alone.

Step 2: `lib/config/config_envied.dart` — delete the `twitchClientId` and
`twitchClientSecret` `@EnviedField`s and their static members. `Env.apiKey`,
`EnvDev` and `EnvProd` stay.

Step 3: `lib/core/data/models/error.dart` — add a
`factory ErrorType.functionError({required FunctionException exception})` that
returns `responseError` with the proxy's message and status when `details` is a map
carrying `error`, and `unknown()` otherwise. Import
`package:supabase_flutter/supabase_flutter.dart`. Touch nothing else in the file.

Step 4: `lib/core/data/datasource/base_repository_mixin.dart` — add one
`on FunctionException` branch to `fetchData` returning
`Failure(ErrorType.functionError(...))`. Leave the `DioException` branch and the
generic `catch` exactly as they are.

Step 5: create `lib/core/services/supabase/igdb_proxy_client.dart` — `@injectable`
`IgdbProxyClient`, injecting `SupabaseClient`, with a single
`invoke({required String endpoint, required String query})` returning the
`FunctionResponse.data` untouched. No decoding, no error handling, no timeout here.

Step 6: create `lib/core/services/api/igdb_proxy_service.dart` — `@injectable`
`IgdbProxyService`, injecting `IgdbProxyClient`, with `fetchGames`,
`fetchReleaseDates` and the generic `fetchList`. `fetchList` applies
`IgdbProxyConstants.requestTimeout`, throws a `FormatException` if the reply is not
a list, and maps each element through the supplied `fromJson`.

Step 7: run `dart run build_runner build --delete-conflicting-outputs` — regenerates
the envied output without the Twitch fields, the freezed error model, and the DI
config with the two new classes.

Step 8: `lib/features/games/data/datasources/games_datasource.dart` — swap the
injected `IgdbApiService` for `IgdbProxyService` and call `fetchGames(...)` with the
built query. Do not touch the `IGDBQueryBuilder` chain, the search/sort branch, the
offset arithmetic or the `GamesModel(count: 0, ...)` wrapper.

Step 9: `lib/features/game_detail/data/datasources/game_detail_datasource.dart` —
swap to `IgdbProxyService` and call `fetchList<GameDetailModel>` with the `games`
endpoint and `GameDetailModel.fromJson`. Keep `response.first` as is.

Step 10: `lib/features/featured/data/repositories/featured_repository_impl.dart` —
swap the injected `IgdbApiService` for `IgdbProxyService` and change the five
`fetchGames(query)` call sites to the new service. Do not touch `_gameFields`, the
queries, the sorting, the fallbacks or the `catch` blocks.

Step 11: delete `lib/features/games/services/igdb_api_service.dart` and its
generated `igdb_api_service.g.dart`.

Step 12: delete `lib/features/game_detail/services/game_detail_service.dart` and its
generated `game_detail_service.g.dart`.

Step 13: delete `lib/core/services/api/twitch_auth_interceptor.dart`.

Step 14: delete `lib/core/di/network_module.dart`.

Step 15: run `dart run build_runner build --delete-conflicting-outputs` — regenerates
`service_locator.config.dart` without the `Dio`, `IgdbApiService`,
`GameDetailService` and `TwitchAuthInterceptor` registrations.

Step 16: `test/mocks/release_date_mock.dart` (new), plus additions to
`test/mocks/game_mock.dart`, `test/mocks/game_detail_response_mock.dart` and
`test/mocks/error_mock.dart` — raw JSON array fixtures for each model and a
`FunctionException` fixture. Getters, not `final`, per `testing-conventions.md`.

Step 17: rewrite `test/api/games/games_test.dart` — mock `IgdbProxyClient`, use the
real `IgdbProxyService` and real `GamesDataSource`. Delete the `DioAdapter` setup
and both existing Dio tests.

Step 18: rewrite `test/api/game_detail/game_detail_test.dart` — same shape, with the
real `GameDetailRemoteDatasource`. Delete the `DioAdapter` setup and both existing
Dio tests.

Step 19: `test/repository/games/games_repository_test.dart` — append one case
asserting a `FunctionException` from the datasource becomes a `Failure` carrying the
proxy's status code and message. Change nothing already in the file.

Step 20: run `dart run build_runner build --delete-conflicting-outputs` — regenerates
`*.mocks.dart` for the rewritten tests and for `MockGamesDataSource`, whose
constructor dependency changed.

Final step: confirm a case-insensitive search for `twitch` under `lib/` returns
nothing, then run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s baselines, quoted verbatim:
`Analyzer baseline: 0 errors, 2 warnings, 36 info` and `Test baseline: +187 -13`.
Pre-existing failures are recorded there as
`test/api/games/games_test.dart (1), test/api/game_detail/game_detail_test.dart (1),
test/cubit/games/games_bloc_test.dart (3), test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/repository/tracker/tracker_repository_test.dart (4), test/widget_test.dart (1)`.
The two `test/api/` failures are expected to disappear because those files are
rewritten; fewer failures than the baseline is fine. Any other new failure or new
analyzer error is in scope to fix or escalate.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: REQ-9.2, REQ-9.3, REQ-NC

Never paste the criteria text here — Dev and QA read the canonical section
directly.

## Constraints

- Clean Architecture, 3 layers per feature; `lib/core/` must never import from
  `lib/features/`. That is why `IgdbProxyService` exposes a generic `fetchList`
  rather than a `fetchGameDetail` method.
- DI is GetIt + injectable. Annotate and regenerate; never edit
  `service_locator.config.dart` by hand, and never call `getIt<T>()` inside a
  feature class — inject through the constructor.
- Repositories return `Future<Result<T>>` and never throw.
- Never edit a generated file. If a generated file you cannot regenerate gets
  touched, restore it with `git checkout -- <path>`.
- `IGDBQueryBuilder` is the only way queries are built, and it is not changing —
  REQ-NC's byte-identical query requirement depends on the builder chains in the
  three call sites staying exactly as they are.
- Import `package:supabase_flutter/supabase_flutter.dart` for `SupabaseClient` and
  `FunctionException`. Do not import `package:functions_client/...` directly — it is
  a transitive dependency.
- `dart-style.md`: single quotes, trailing commas, 80-char lines, no `dynamic`
  (`Object?` where the SDK hands back an untyped body), constants only inside a
  `*Constants` class, package imports over relative.
- Comments in plain English explaining why, and few of them. No dartdoc that just
  restates a name.
- Only unit and widget tests. Never a golden test.
- Test paths are layer-based (`test/api|repository|use_case|cubit|widget/[feature]/`),
  mock data lives in `test/mocks/` as getters, mocks come from `@GenerateMocks`.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.

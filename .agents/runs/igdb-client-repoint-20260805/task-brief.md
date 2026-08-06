# Task Brief
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-05

## Context

Move every IGDB read onto the deployed `igdb-proxy` Edge Function and delete the
direct-to-IGDB stack, so no Twitch or IGDB credential ships in the client.

## Testing mode

`coverage` — Rule applied: shared utility used by 3+ features (`SupabaseIgdbClient`
is injected by `GamesApiService`, `GameDetailApiService` and `FeaturedApiService`,
i.e. games, game_detail and featured). Justification: it is the single `invoke` every
IGDB read in the app passes through, and it carries the function name, the request
body shape and the 30-second bound that three acceptance criteria turn on. Re-checked
at the second Phase 3 revision after decode moved out to the feature services — see
`code-plan.md ## Approved feedback delta 2 — Testing mode`.

## File allowlist

### CREATE NEW
lib/core/services/supabase/supabase_igdb_client.dart — invokes the `igdb-proxy` function under a 30s timeout and returns its reply untouched
lib/features/games/services/games_api_service.dart — decodes the proxy reply into `Game` and `ReleaseDate`
lib/features/game_detail/services/game_detail_api_service.dart — decodes the proxy reply into `GameDetailModel`
lib/features/featured/services/featured_api_service.dart — decodes the proxy reply into `Game` (new folder for this feature)

### MODIFY EXISTING
lib/core/res/const.dart — add `IgdbProxyConstants`; delete `twitchClientId` and `twitchClientSecret`
lib/config/config_envied.dart — delete the `twitchClientId` and `twitchClientSecret` fields
lib/core/data/models/error.dart — add an `ErrorType.functionError` factory next to `dioError`
lib/core/data/datasource/base_repository_mixin.dart — add one `on FunctionException` branch to `fetchData`
lib/features/games/data/datasources/games_datasource.dart — inject `GamesApiService`; query building unchanged
lib/features/game_detail/data/datasources/game_detail_datasource.dart — inject `GameDetailApiService`; query building unchanged
lib/features/featured/data/repositories/featured_repository_impl.dart — inject `FeaturedApiService`; five call sites, nothing else

### DELETE
lib/features/games/services/igdb_api_service.dart — Retrofit IGDB service, superseded by `games_api_service.dart` (delete its generated `.g.dart` with it)
lib/features/game_detail/services/game_detail_service.dart — Retrofit IGDB service, superseded by `game_detail_api_service.dart` (delete its generated `.g.dart` with it)
lib/core/services/api/twitch_auth_interceptor.dart — Twitch token fetch and 401 retry, now server-side
lib/core/di/network_module.dart — only registers the IGDB `Dio` instance and the two deleted services

### TEST FILES
test/api/supabase/supabase_igdb_client_test.dart — new: invoke body, untouched passthrough, 30s timeout
test/api/games/games_test.dart — rewrite against the proxy path: invoke body, array decode, release dates, failure
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
generic `catch` exactly as they are — a `TimeoutException` is meant to land in the
generic `catch`.

Step 5: create `lib/core/services/supabase/supabase_igdb_client.dart` —
`@injectable` `SupabaseIgdbClient`, injecting `SupabaseClient`, with a single
`invoke({required String endpoint, required String query})` that calls
`functions.invoke(IgdbProxyConstants.functionName, body: {...})`, chains
`.timeout(IgdbProxyConstants.requestTimeout)` on it, and returns
`FunctionResponse.data` untouched. No decoding and no error handling here. No
constructor timeout parameter — reference the constant directly.

Step 6: create `lib/features/games/services/games_api_service.dart` — `@injectable`
`GamesApiService`, injecting `SupabaseIgdbClient`, with `fetchGames(String query)`
and `fetchReleaseDates(String query)` returning `List<Game>` and `List<ReleaseDate>`.
A private `_decodeList<T>` helper throws `FormatException` if the reply is not a list
and maps each element through the supplied `fromJson`. No timeout anywhere in this
file.

Step 7: create `lib/features/game_detail/services/game_detail_api_service.dart` —
`@injectable` `GameDetailApiService`, injecting `SupabaseIgdbClient`, with
`fetchGameDetail(String query)` returning `Future<List<GameDetailModel>>` — same
method name and return type as the Retrofit service it replaces. Same array check
inline; no shared helper.

Step 8: create `lib/features/featured/services/featured_api_service.dart` (new
folder) — `@injectable` `FeaturedApiService`, injecting `SupabaseIgdbClient`, with
`fetchGames(String query)` returning `Future<List<Game>>`. Same array check inline.

Step 9: run `dart run build_runner build --delete-conflicting-outputs` — regenerates
the envied output without the Twitch fields, the freezed error model, and the DI
config with the four new classes.

Step 10: `lib/features/games/data/datasources/games_datasource.dart` — swap the
injected `IgdbApiService` for `GamesApiService` (field `gamesApiService`) and call
`fetchGames(...)` with the built query. Do not touch the `IGDBQueryBuilder` chain,
the search/sort branch, the offset arithmetic or the `GamesModel(count: 0, ...)`
wrapper.

Step 11: `lib/features/game_detail/data/datasources/game_detail_datasource.dart` —
swap `GameDetailService` for `GameDetailApiService` (field `_gameDetailApiService`).
The call line and `response.first` are otherwise unchanged.

Step 12: `lib/features/featured/data/repositories/featured_repository_impl.dart` —
swap the injected `IgdbApiService` for `FeaturedApiService` (field
`_featuredApiService`) and change the five `fetchGames(query)` call sites to it. Do
not touch `_gameFields`, the queries, the sorting, the fallbacks or the `catch`
blocks.

Step 13: delete `lib/features/games/services/igdb_api_service.dart` and its
generated `igdb_api_service.g.dart`.

Step 14: delete `lib/features/game_detail/services/game_detail_service.dart` and its
generated `game_detail_service.g.dart`.

Step 15: delete `lib/core/services/api/twitch_auth_interceptor.dart`.

Step 16: delete `lib/core/di/network_module.dart`.

Step 17: run `dart run build_runner build --delete-conflicting-outputs` — regenerates
`service_locator.config.dart` without the `Dio`, `IgdbApiService`,
`GameDetailService` and `TwitchAuthInterceptor` registrations.

Step 18: `test/mocks/release_date_mock.dart` (new), plus additions to
`test/mocks/game_mock.dart`, `test/mocks/game_detail_response_mock.dart` and
`test/mocks/error_mock.dart` — raw JSON array fixtures for each model and a
`FunctionException` fixture. Getters, not `final`, per `testing-conventions.md`.

Step 19: create `test/api/supabase/supabase_igdb_client_test.dart` — mock
`SupabaseClient` and the `FunctionsClient` its `functions` getter returns, use the
real `SupabaseIgdbClient`. Assert the function name and `{endpoint, query}` body,
that `response.data` comes back undecoded, and that a never-completing stub fails
rather than hangs — `testWidgets` with `Completer<FunctionResponse>().future` and
`tester.pump(const Duration(seconds: 31))`, same shape as
`test/repository/supabase/supabase_connection_checker_test.dart`. This is the only
file in the run that mocks the Supabase SDK. If mockito cannot generate a usable
`MockSupabaseClient` / `MockFunctionsClient`, escalate — do not move the timeout.

Step 20: rewrite `test/api/games/games_test.dart` — mock `SupabaseIgdbClient`, use
the real `GamesApiService` and real `GamesDataSource`. Delete the `DioAdapter` setup
and both existing Dio tests. No timeout case here; it lives in step 19 now.

Step 21: rewrite `test/api/game_detail/game_detail_test.dart` — same shape, with the
real `GameDetailApiService` and real `GameDetailRemoteDatasource`. Delete the
`DioAdapter` setup and both existing Dio tests.

Step 22: `test/repository/games/games_repository_test.dart` — append one case
asserting a `FunctionException` from the datasource becomes a `Failure` carrying the
proxy's status code and message. Change nothing already in the file.

Step 23: run `dart run build_runner build --delete-conflicting-outputs` — regenerates
`*.mocks.dart` for the new and rewritten tests and for `MockGamesDataSource`, whose
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

(Steps 9, 17 and 23 are build_runner checkpoints and do not count toward the 20-step
ceiling. That leaves 20 substantive steps — at the ceiling, none spare. Anything
needing an extra step is an escalation, not an improvised step 21.)

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: REQ-9.2, REQ-9.3, REQ-NC

Never paste the criteria text here — Dev and QA read the canonical section
directly.

## Constraints

- Class and file naming for the four new classes is fixed by
  `code-plan.md ## Approved feedback delta 2` (second Phase 3 human decision):
  `SupabaseIgdbClient`, `GamesApiService`, `GameDetailApiService`,
  `FeaturedApiService`. `tdd.md` and delta 1 still describe a single shared
  `SupabaseIgdbService`; that class does not exist. Delta 2 wins over both.
- The 30-second timeout lives in exactly one place: `SupabaseIgdbClient.invoke`.
  No service, datasource or repository applies `.timeout` to an IGDB call, and
  `SupabaseIgdbClient` takes no timeout constructor parameter.
- Clean Architecture, 3 layers per feature; `lib/core/` must never import from
  `lib/features/`. That is why `SupabaseIgdbClient` returns `Object?` and never
  names a model type — each feature service imports its own model and decodes it.
- The repeated `if (body is! List) throw const FormatException(...)` across the
  three services is deliberate. Do not extract it into `lib/core/` or into a shared
  base class or mixin. `GamesApiService`'s `_decodeList<T>` stays private to that
  file.
- The three services are plain `@injectable` classes, not Retrofit `@RestApi`
  abstracts. `flutter-arch.md`'s "register every Retrofit service in NetworkModule"
  rule does not apply — `NetworkModule` is deleted in this run.
- DI is GetIt + injectable. Annotate and regenerate; never edit
  `service_locator.config.dart` by hand, and never call `getIt<T>()` inside a
  feature class — inject through the constructor.
- Repositories return `Future<Result<T>>` and never throw.
- Never edit a generated file. If a generated file you cannot regenerate gets
  touched, restore it with `git checkout -- <path>`.
- `IGDBQueryBuilder` is the only way queries are built, and it is not changing —
  REQ-NC's byte-identical query requirement depends on the builder chains in the
  three call sites staying exactly as they are.
- Import `package:supabase_flutter/supabase_flutter.dart` for `SupabaseClient`,
  `FunctionsClient`, `FunctionResponse` and `FunctionException`. Do not import
  `package:functions_client/...` directly — it is a transitive dependency.
- `.agents/references/flutter-arch.md` is stale after this run (the `services/`
  deviation line, the `NetworkModule` section, the Dio/Retrofit section and the
  `TwitchAuthInterceptor` section). It is deliberately **not** in the allowlist —
  do not edit it. Reasons and the follow-up are in `code-plan.md ## Approved
  feedback delta 2`.
- `dart-style.md`: single quotes, trailing commas, 80-char lines, no `dynamic`
  (`Object?` where the SDK hands back an untyped body), constants only inside a
  `*Constants` class, package imports over relative.
- Comments in plain English explaining why, and few of them. No dartdoc that just
  restates a name.
- Only unit and widget tests. Never a golden test.
- Test paths are layer-based (`test/api|repository|use_case|cubit|widget/[feature]/`),
  mock data lives in `test/mocks/` as getters, mocks come from `@GenerateMocks`.
- `FeaturedApiService` has no dedicated API test — the last step slot went to the
  shared client's timeout test instead. Do not add one; if you think it is needed,
  escalate.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.

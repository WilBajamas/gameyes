# Diff Summary
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-06
Branch: feature/igdb-client-repoint
Commit: df1456f8725855c95c7732f33226148a89066b0a

## Files created
lib/core/services/supabase/supabase_igdb_client.dart — `@injectable SupabaseIgdbClient`, wraps `functions.invoke('igdb-proxy', body: {endpoint, query})` in a 30s timeout, returns the raw reply
lib/features/games/services/games_api_service.dart — `@injectable GamesApiService`, `fetchGames`/`fetchReleaseDates` decoding the proxy reply into `Game`/`ReleaseDate` via a private `_decodeList<T>`
lib/features/game_detail/services/game_detail_api_service.dart — `@injectable GameDetailApiService`, `fetchGameDetail` decoding into `GameDetailModel`
lib/features/featured/services/featured_api_service.dart — `@injectable FeaturedApiService` (new `featured/services/` folder), `fetchGames` decoding into `Game`
test/api/supabase/supabase_igdb_client_test.dart — mocks `SupabaseClient`/`FunctionsClient`, asserts invoke body, passthrough data, and the 31s-pump timeout
test/mocks/release_date_mock.dart — `mockReleaseDate` and `mockReleaseDatesJson` fixtures

## Files modified
lib/core/res/const.dart — added `IgdbProxyConstants` (function name, endpoint names, 30s `requestTimeout`); deleted `twitchClientId`/`twitchClientSecret`
lib/config/config_envied.dart — deleted the two Twitch `@EnviedField`s and their static members
lib/core/data/models/error.dart — added `ErrorType.functionError({required FunctionException exception})`, imports `supabase_flutter`
lib/core/data/datasource/base_repository_mixin.dart — added `on FunctionException` branch to `fetchData`
lib/features/games/data/datasources/games_datasource.dart — injects `GamesApiService` (field `gamesApiService`) instead of `IgdbApiService`; query building unchanged
lib/features/game_detail/data/datasources/game_detail_datasource.dart — injects `GameDetailApiService` (field `_gameDetailApiService`) instead of `GameDetailService`
lib/features/featured/data/repositories/featured_repository_impl.dart — injects `FeaturedApiService` (field `_featuredApiService`); five `fetchGames` call sites swapped, nothing else touched
lib/core/di/service_locator.config.dart — regenerated (implicit, DI graph)
test/api/games/games_test.dart — rewritten against the proxy path: mocks `SupabaseIgdbClient`, uses real `GamesApiService`/`GamesDataSource`; Dio/DioAdapter tests removed
test/api/game_detail/game_detail_test.dart — rewritten against the proxy path: mocks `SupabaseIgdbClient`, uses real `GameDetailApiService`/`GameDetailRemoteDatasource`; Dio/DioAdapter tests removed
test/mocks/game_mock.dart — added `mockGamesJson` (raw array from `mockListGames`)
test/mocks/game_detail_response_mock.dart — added `mockGameDetailJson` (hand-built raw array, not via `toJson()` because nested `cover` doesn't serialize to a map) and `mockEmptyGameDetailJson`
test/mocks/error_mock.dart — added `mockFunctionException`
test/repository/games/games_repository_test.dart — appended one case for the proxy failure mapping; existing cases untouched
test/repository/games/games_repository_test.mocks.dart — regenerated (implicit)

## Files deleted
lib/features/games/services/igdb_api_service.dart (+ .g.dart) — superseded by `games_api_service.dart`
lib/features/game_detail/services/game_detail_service.dart (+ .g.dart) — superseded by `game_detail_api_service.dart`
lib/core/services/api/twitch_auth_interceptor.dart — Twitch auth now server-side
lib/core/di/network_module.dart — only registered the deleted IGDB `Dio` instance and the two deleted Retrofit services

## Test files
test/api/supabase/supabase_igdb_client_test.dart — invoke body shape, untouched passthrough, 30s timeout (own file per delta 2, the only Supabase-SDK mock in the run)
test/api/games/games_test.dart — invoke body/query for the default and search branches, GamesModel decode, non-list failure, FunctionException failure, release-dates fetch
test/api/game_detail/game_detail_test.dart — invoke body/query, first-decoded-element, empty-array failure (preserved rough edge), FunctionException failure
test/repository/games/games_repository_test.dart — one appended case: FunctionException from the datasource becomes a `Failure` carrying the proxy's status and message

## Self-corrections
File: test/mocks/game_detail_response_mock.dart — Error: `mockGameDetailJson` built via `mockGameDetailResponse.toJson()` left the nested `cover` field as a `GameCover` object rather than a map (json_serializable's generated `toJson()` doesn't recurse), causing a cast failure decoding it back — Fix: hand-built the fixture map instead of deriving it from `toJson()` — Attempts: 1

## Deviations from implementation plan
NONE — all 20 substantive steps followed as written; build_runner ran at steps 9, 17 and 23 as specified.

## Verification against baseline
- Case-insensitive search for `twitch` under `lib/`: no matches.
- `flutter analyze`: 0 errors, 2 warnings, 34 info (baseline: 0 errors, 2 warnings, 36 info — no new issue; the two fewer info entries come from deleted Retrofit files).
- `flutter test`: 200 passed, 11 failed (baseline: 187 passed, 13 failed). The 11 failures are exactly the baseline's pre-existing set minus the two `test/api/` files (`test/repository/tracker/tracker_repository_test.dart` (4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3), `test/cubit/games/games_bloc_test.dart` (3), `test/widget_test.dart` (1)) — the two `test/api/` failures disappeared as expected since those files were rewritten. No new failure.

## Acceptance criteria status
REQ-9.2: satisfied
REQ-9.3: satisfied
REQ-NC: satisfied

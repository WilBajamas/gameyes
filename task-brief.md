# Task Brief
Source: [tech-ac.md](file:///w:/Projects/gameyes/tech-ac.md)
Date: 2026-05-30
Tech Lead Agent version: 1.0

## Context
This task implements a revamped dashboard screen layout under a completely new feature folder [lib/features/featured_revamp](file:///w:/Projects/gameyes/lib/features/featured_revamp) without affecting the legacy featured screen code. This provides a fresh, responsive home screen showcasing personal stats, upcoming wishlisted or global releases, and critic score discovery filtered by user interests.

## Testing mode
`coverage`
Rule applied: Feature touches local storage/persistence (Isar local database schema modifications, SharedPreferences integration) and state management with active countdown timers.
Justification: Comprehensive coverage testing is required to verify the offline state behavior, the correctness of hours calculations (rolling 7 days), and accurate timer ticks.

## File allowlist

### CREATE NEW
- [lib/features/featured_revamp/data/datasources/featured_revamp_local_datasource.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/datasources/featured_revamp_local_datasource.dart) — local source wrapper for SharedPreferences and Isar.
- [lib/features/featured_revamp/data/datasources/featured_revamp_remote_datasource.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/datasources/featured_revamp_remote_datasource.dart) — remote datasource querying IGDB.
- [lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart) — repository interface definition.
- [lib/features/featured_revamp/data/repositories/featured_revamp_repository_impl.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/repositories/featured_revamp_repository_impl.dart) — repository implementation class.
- [lib/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case.dart) — gets library snapshot for Zone 1.
- [lib/features/featured_revamp/domain/use_cases/get_countdown_game_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_countdown_game_use_case.dart) — selects next release/anticipated game.
- [lib/features/featured_revamp/domain/use_cases/get_out_this_week_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_out_this_week_use_case.dart) — queries weekly releases with fallback window.
- [lib/features/featured_revamp/domain/use_cases/get_critics_choice_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_critics_choice_use_case.dart) — returns top critic games matching preferences.
- [lib/features/featured_revamp/domain/use_cases/save_genre_preferences_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/save_genre_preferences_use_case.dart) — stores user selected genre filters.
- [lib/features/featured_revamp/domain/use_cases/get_genre_preferences_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_genre_preferences_use_case.dart) — retrieves current genre settings.
- [lib/features/featured_revamp/presentation/blocs/library_stats_cubit.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/library_stats_cubit.dart) — Cubit for Zone 1 library stats and onboarding checklist.
- [lib/features/featured_revamp/presentation/blocs/library_stats_state.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/library_stats_state.dart) — State for Zone 1 Cubit.
- [lib/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart) — Cubit for Zone 2 countdown and release list.
- [lib/features/featured_revamp/presentation/blocs/countdown_releases_state.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/countdown_releases_state.dart) — State for Zone 2 Cubit.
- [lib/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart) — Cubit for Zone 3 critic grid and genre preferences.
- [lib/features/featured_revamp/presentation/blocs/critics_grid_state.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/critics_grid_state.dart) — State for Zone 3 Cubit.
- [lib/features/featured_revamp/presentation/screens/featured_revamp_screen.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/screens/featured_revamp_screen.dart) — revamped main home view.
- [lib/features/featured_revamp/presentation/widgets/library_stats.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/library_stats.dart) — checklist/stats widget.
- [lib/features/featured_revamp/presentation/widgets/countdown_releases.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/countdown_releases.dart) — countdown and releases list widget.
- [lib/features/featured_revamp/presentation/widgets/critics_grid.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/critics_grid.dart) — critics grid and genre picker widget.
- [lib/features/tracker/data/models/play_session_log.dart](file:///w:/Projects/gameyes/lib/features/tracker/data/models/play_session_log.dart) — Isar model for rolling hours.

### MODIFY EXISTING
- [lib/core/data/models/game.dart](file:///w:/Projects/gameyes/lib/core/data/models/game.dart) — add critic score, genres, and hypes fields.
- [lib/core/domain/entities/game_entity.dart](file:///w:/Projects/gameyes/lib/core/domain/entities/game_entity.dart) — add critic score, genreIds, and hypes properties.
- [lib/core/data/models/release_date.dart](file:///w:/Projects/gameyes/lib/core/data/models/release_date.dart) — add release date category property.
- [lib/features/tracker/data/models/saved_game.dart](file:///w:/Projects/gameyes/lib/features/tracker/data/models/saved_game.dart) — add status, hoursLogged, averageCompletionHours, manualProgressPercentage, isWishlisted, genres properties.
- [lib/core/services/storage/isar_local_storage_service.dart](file:///w:/Projects/gameyes/lib/core/services/storage/isar_local_storage_service.dart) — register new [PlaySessionLog](file:///w:/Projects/gameyes/lib/features/tracker/data/models/play_session_log.dart) schema.
- [lib/config/route/auto_route_config.dart](file:///w:/Projects/gameyes/lib/config/route/auto_route_config.dart) — add revamped screen route map.
- [lib/features/home/presentation/screens/home_screen.dart](file:///w:/Projects/gameyes/lib/features/home/presentation/screens/home_screen.dart) — map tab to [FeaturedRevampRoute](file:///w:/Projects/gameyes/lib/config/route/auto_route_config.gr.dart) instead of [FeaturedRoute](file:///w:/Projects/gameyes/lib/config/route/auto_route_config.gr.dart).

### TEST FILES
- [test/features/featured_revamp/presentation/blocs/library_stats_cubit_test.dart](file:///w:/Projects/gameyes/test/features/featured_revamp/presentation/blocs/library_stats_cubit_test.dart) — unit tests library stats/checklist Cubit.
- [test/features/featured_revamp/presentation/blocs/countdown_releases_cubit_test.dart](file:///w:/Projects/gameyes/test/features/featured_revamp/presentation/blocs/countdown_releases_cubit_test.dart) — unit tests countdown/weekly release Cubit and timer ticks.
- [test/features/featured_revamp/presentation/blocs/critics_grid_cubit_test.dart](file:///w:/Projects/gameyes/test/features/featured_revamp/presentation/blocs/critics_grid_cubit_test.dart) — unit tests critics choice grid/genre preference picker Cubit.
- [test/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case_test.dart](file:///w:/Projects/gameyes/test/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case_test.dart) — unit tests snapshot calculation logic.
- [test/features/featured_revamp/domain/use_cases/get_countdown_game_use_case_test.dart](file:///w:/Projects/gameyes/test/features/featured_revamp/domain/use_cases/get_countdown_game_use_case_test.dart) — tests countdown anticipated selector.

## Implementation plan
- Step 1: Add new properties (criticScore, hypes, genres) to [lib/core/data/models/game.dart](file:///w:/Projects/gameyes/lib/core/data/models/game.dart), [lib/core/domain/entities/game_entity.dart](file:///w:/Projects/gameyes/lib/core/domain/entities/game_entity.dart) and add category to [lib/core/data/models/release_date.dart](file:///w:/Projects/gameyes/lib/core/data/models/release_date.dart).
- Step 2: Add status, hoursLogged, averageCompletionHours, manualProgressPercentage, isWishlisted, and genres properties to [lib/features/tracker/data/models/saved_game.dart](file:///w:/Projects/gameyes/lib/features/tracker/data/models/saved_game.dart).
- Step 3: Create [lib/features/tracker/data/models/play_session_log.dart](file:///w:/Projects/gameyes/lib/features/tracker/data/models/play_session_log.dart) to define the schema for logging user play sessions.
- Step 4: Register the new schema inside [lib/core/services/storage/isar_local_storage_service.dart](file:///w:/Projects/gameyes/lib/core/services/storage/isar_local_storage_service.dart).
- Step 5: Run command `dart run build_runner build --delete-conflicting-outputs` to regenerate Freezed classes, Json DTO serializers, and Isar adapter files.
- Step 6: Create the domain repository interface [lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart) detailing required local and remote methods.
- Step 7: Create local data source [lib/features/featured_revamp/data/datasources/featured_revamp_local_datasource.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/datasources/featured_revamp_local_datasource.dart) to interface with Isar and SharedPreferences, and remote data source [lib/features/featured_revamp/data/datasources/featured_revamp_remote_datasource.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/datasources/featured_revamp_remote_datasource.dart) to query the IGDB endpoint using [GamesServices](file:///w:/Projects/gameyes/lib/features/games/services/games_service.dart).
- Step 8: Create repository implementation [lib/features/featured_revamp/data/repositories/featured_revamp_repository_impl.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/repositories/featured_revamp_repository_impl.dart) combining the local and remote sources with [BaseRepositoryMixin](file:///w:/Projects/gameyes/lib/core/data/datasource/base_repository_mixin.dart) error handling.
- Step 9: Create clean architecture use case files for fetching library snapshots, upcoming countdown targets, weekly releases, critic suggestions, and managing genre preferences.
- Step 10: Run command `dart run build_runner build --delete-conflicting-outputs` to wire up the Injectable framework dependency graph.
- Step 11: Create state models and controllers for each Zone: [LibraryStatsCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/library_stats_cubit.dart), [CountdownReleasesCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart), and [CriticsGridCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart), along with their Freezed states.
- Step 12: Build the UI skeleton and widgets for Zone 1 ([LibraryStatsWidget](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/library_stats.dart)) rendering onboarding checkpoints or play progress stats.
- Step 13: Build the UI widgets for Zone 2 ([CountdownReleasesWidget](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/countdown_releases.dart)) featuring localized midnight release timers and rolling horizontal scroll cards.
- Step 14: Build the UI widgets for Zone 3 ([CriticsGridWidget](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/critics_grid.dart)) showing the color-coded score grids and preference pills selection.
- Step 15: Create the page view widget [lib/features/featured_revamp/presentation/screens/featured_revamp_screen.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/screens/featured_revamp_screen.dart) integrating the Cubit providers and lifecycles (foreground checking, pull-to-refresh).
- Step 16: Update [lib/config/route/auto_route_config.dart](file:///w:/Projects/gameyes/lib/config/route/auto_route_config.dart) and [lib/features/home/presentation/screens/home_screen.dart](file:///w:/Projects/gameyes/lib/features/home/presentation/screens/home_screen.dart) routes to load the revamped home screen screen layout.
- Step 17: Run command `dart run build_runner build --delete-conflicting-outputs` to regenerate the AutoRoute configuration routes.
- Step 18: Add unit and widget tests under `test/features/featured_revamp/` verifying state updates, timer actions, fallback API queries, and offline scenarios.

## Acceptance criteria reference
[Z1-BL-01] UI / STATE: If the local Isar database contains exactly 0 games, the `featured_revamp` home screen Bloc/Cubit must yield a state that renders the welcome checklist card in Zone 1. This card must display a 3-step list ("Add a game you've played", "Mark what you're playing now", "Wishlist an upcoming game") with a progress track and an inline "+ Add" tap handler for each.
  Failure case: If the local library database has 0 games but the checklist card is not displayed, or if any step/button is non-functional.

[Z1-BL-02] UI / STATE: If the local Isar database contains 1 or more games, the `featured_revamp` LibraryStatsCubit must replace the welcome checklist card with the standard library stats view. Once replaced, the checklist card must never render again in the current or future sessions.
  Failure case: If the welcome checklist remains visible after library count becomes >= 1, or if it returns on subsequent launches.

[Z1-BL-03] UI / STATE: If the local Isar database contains exactly 1 game with the status set to "Playing", the Now Playing card in Zone 1 must display that game's cover art, title, and a progress bar (if hours are logged).
  Failure case: If a single active game has "Playing" status but the Now Playing card fails to display its info, or shows a ghost state.

[Z1-BL-04] UI / STATE / ROUTING: If the local Isar database contains 2 or more games with the status set to "Playing", the Now Playing card must display the game with the most recently updated timestamp. The card subtitle must show "+ [N-1] more playing", and tapping the card must route via AutoRoute to the library filter screen showing only games with "Playing" status.
  Failure case: If a game other than the most recently updated is shown, the subtitle number is incorrect, or tapping does not navigate to the filtered library route.

[Z1-BL-05] UI: If the local Isar database contains 0 games with the status "Playing" (but library count >= 1), the Now Playing card must render as a ghost card with a dashed border, showing a placeholder icon, a description "No game in progress", and a text CTA button "Mark something as playing →".
  Failure case: If the Now Playing card collapses, shows blank space, or fails to render the CTA button when no games are active.

[Z1-BL-06] STATE: The progress percentage for the Now Playing card must be calculated in the Cubit layer: use manual percentage if set on the library entry; else if hours logged and average completion hours exist in the database, calculate `(hours logged / average completion hours) * 100` capped at 100%; otherwise, display only the logged hours text and omit the progress bar.
  Failure case: If the calculation fails or throws an exception when average completion hours are missing, or if progress percentage exceeds 100%.

[Z1-BL-07] STATE / LOCAL STORAGE: The "This week" hours calculation must sum the user's session play logs in the Isar database within a rolling 7-day window (last 168 hours) from the current system timestamp. If no session logs exist in this window, it must return "0h".
  Failure case: If the value displays null, "—", or calculates based on fixed calendar week boundaries instead of a rolling 168-hour window.

[Z1-BL-08] STATE: Each welcome checklist step completion must be calculated by the Cubit independently: Step 1 (Add a played game) completes when library count >= 1; Step 2 (Mark now playing) completes when at least 1 game has the status "Playing"; Step 3 (Wishlist game) completes when wishlist count >= 1.
  Failure case: If step status updates do not trigger a state change and visual update of the progress bar in the welcome card.

[Z2-BL-01] STATE / API: The countdown selector must fetch the user's wishlist from local storage/Isar and select the game with the nearest future release date. If the wishlist has 0 upcoming games, it must fall back to querying the API for the globally most anticipated game.
  Failure case: If the countdown card remains blank, shows an error, or fails to query the global anticipated game when wishlist is empty.

[Z2-BL-02] UI / STATE: The countdown card must calculate and display Days, Hours, and Minutes remaining until midnight (00:00:00) in the user's local time zone on the release date. The state must update the remaining time every 60 seconds in the background.
  Failure case: If the timer displays seconds, ticks on every second, or calculates timezone offsets incorrectly.

[Z2-BL-03] STATE / API: The countdown card must exclude games from selection that do not have a day-level release date (e.g. TBA, Q4 2026).
  Failure case: If a game with a generic release year or quarter is selected for the countdown card.

[Z2-BL-04] STATE / API: The "Out This Week" API client must query for games with a release date within a rolling 7-day window from today (inclusive) to today + 6 days.
  Failure case: If the API query uses calendar-week boundaries instead of a rolling 7-day offset.

[Z2-BL-05] STATE / UI: If the API returns 0 games for the rolling 7-day window, the repository must expand the query to 14 days. The UI must then update the section header label from "Out this week" to "Coming soon".
  Failure case: If the section renders empty, collapses, or fails to update the label when the window is expanded.

[Z2-BL-06] STATE / UI: On the release date of the countdown game, the UI must display a release celebration state: the badge must read "Out today!" and the timer blocks must be replaced by a release announcement. This celebration state must persist for the release date only (local time) before advancing to the next upcoming game.
  Failure case: If the countdown timer displays negative values on release day, or fails to transition to the next game on the day after release.

[Z2-BL-07] STATE / UI: The "Out This Week" list must display a maximum of 10 items. The items must be sorted placing user-wishlisted games first, followed by global popularity score descending.
  Failure case: If the scroll list exceeds 10 items, or if sorting fails to prioritize wishlisted games.

[Z3-BL-01] STATE / API: The Critics grid must query the API for games with reviews published in the last 7 days, sorted by score descending, and display exactly 4 games. If the user has genre preferences set, it must filter by those genres first; if fewer than 4 results are found, it must backfill the remaining slots with global top-scored games from the last 7 days.
  Failure case: If the grid displays fewer than 4 games when data is available, or if the genre preference filter is ignored.

[Z3-BL-02] UI: The Critic score text color must use green (`#4caf7d`) for scores >= 80%, amber (`#e6a430`) for scores 60%–79%, and red (`#e05555`) for scores below 60%. Card backgrounds must remain neutral.
  Failure case: If score colors do not map correctly to the defined thresholds, or if card backgrounds change color.

[Z3-BL-03] UI / STATE: On first load with no saved genre preferences in local storage/user profile, the Genre Picker must pre-select the top 2 genres globally based on user statistics. The pre-selection must remain consistent across app launches.
  Failure case: If pre-selected genres are randomized on each load, or if no genres are pre-selected on first launch.

[Z3-BL-04] STATE / LOCAL STORAGE: Genre selections made in the picker must be persisted to local storage immediately upon tapping a pill. Tapping the "Skip" link must store an explicit "no preference" flag in local storage, which collapses the genre picker immediately and prevents it from displaying on future app opens.
  Failure case: If genre choices require a confirmation button to save, or if skipping the picker does not prevent it from appearing on the next launch.

[SYS-BL-01] STATE / LOCAL STORAGE: Zone 1 must load data from the local database (Isar) immediately upon home screen initialization and must not wait for any network API responses.
  Failure case: If Zone 1 shows a loading spinner or remains blank while waiting for network API requests.

[SYS-BL-02] UI: No zone on the revamped home screen is permitted to render as a blank space. Every zone must display either its populated state, its designated cold/empty/ghost state, or an inline error state with a retry button.
  Failure case: If any zone collapses into an empty gap or displays a blank space under any network or data condition.

[SYS-BL-03] UI: The application must utilize skeleton shimmer loading states (`Skeletonizer`) for lazy-loaded network data in Zones 2 and 3. The UI must not use full-screen blocking spinners or loading indicators.
  Failure case: If the screen displays a spinning loading indicator that blocks user interaction or does not show shimmer placeholders.

[SYS-BL-04] UI: Games displayed in Zone 2 ("Out This Week") and Zone 3 ("Critics This Week") that are already present in the user's local library must be visually marked with a status/library checkmark badge.
  Failure case: If a game in the user's library is displayed in Zone 2 or 3 without any visual indicator showing it is already owned/tracked.

[SYS-BL-05] STATE: When the application returns to the foreground after being in the background for 15 minutes or longer, it must execute a silent background refresh of the API data for Zone 2 and Zone 3. The UI must not block user scrolling or navigation during this refresh.
  Failure case: If the screen triggers a full-page loading skeleton when coming to the foreground, or if the refresh interrupts the user's current scroll position.

[SYS-STATE-01] UI / STATE: On first launch (empty state), Zone 1 must render the onboarding checklist, Zone 2 must render the global countdown card and wishlist nudge, and Zone 3 must render the genre picker.
  Failure case: If the user's first launch displays success states or empty lists instead of the onboarding guide and nudges.

[SYS-STATE-02] UI / STATE: When the device is completely offline on app launch, Zone 1 must load and display user library stats from the local Isar database. Zones 2 and 3 must render an inline "No connection" error message with a retry button.
  Failure case: If the app crashes or shows a global error screen when offline, or if Zone 1 fails to render local data.

[SYS-STATE-03] UI / STATE: Under slow network conditions (API response time > 2 seconds), Zone 1 must display local data immediately, while Zones 2 and 3 must display skeleton shimmer animations.
  Failure case: If Zone 1 is delayed in rendering due to slow API responses for Zones 2/3.

[SYS-STATE-04] UI / STATE: If a network API request fails for a single zone, that zone must display an inline error card with a retry button. The other zones must render their data normally without showing error states.
  Failure case: If a network failure in Zone 3 causes a global screen error or affects the rendering of Zone 1 or Zone 2.

[SYS-STATE-05] UI / STATE / ROUTING: If a network request returns a 401 Unauthorized status indicating an expired session, the application must immediately redirect the user to the login screen and clear any displayed session data.
  Failure case: If the screen displays cached user stats or allows interaction after a session expires.

[SYS-STATE-06] UI / STATE: Tapping or pulling to trigger a pull-to-refresh on the home screen must initiate parallel API queries for Zones 2 and Zone 3 and a local database reload for Zone 1. The refresh indicator must be non-intrusive and existing content must remain visible during loading.
  Failure case: If pulling to refresh clears existing content from the screen before the new data arrives, or if queries are executed sequentially.

## Constraints
- Use DioClient/GamesServices for all HTTP - do not use http package directly.
- Inject dependencies via constructor injection using Injectable annotations; never call GetIt locator directly inside feature code.
- Do not modify generated files manually.
- All states must use Freezed sealed class.
- All repositories must return Success/Failure Results and never throw exceptions.
- Do not alter the legacy featured feature files under [lib/features/featured](file:///w:/Projects/gameyes/lib/features/featured).

## Self-correction budget
Max attempts per failure: 3
On budget exhaustion: write escalation.md, halt.
Do not modify test files to make tests pass.
Do not add packages to pubspec.yaml — escalate instead.
Do not touch files outside the allowlist — escalate instead.

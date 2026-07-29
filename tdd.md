# Technical Design Document
Source: [tech-ac.md](file:///w:/Projects/gameyes/tech-ac.md)
Date: 2026-05-30
Tech Lead Agent version: 1.0

## Feature summary
The `featured_revamp` feature implements a completely new Dashboard/Home tab layout inside a new feature folder [lib/features/featured_revamp](file:///w:/Projects/gameyes/lib/features/featured_revamp) without altering the existing [lib/features/featured](file:///w:/Projects/gameyes/lib/features/featured) folder. The design divides the home screen into three key functional zones:
- Zone 1 ("You"): Displays a personalized library snapshot (or onboarding checklist if the library contains 0 games) driven by local data from the Isar database.
- Zone 2 ("Right Now"): Contains an interactive countdown timer to the user's nearest future wishlist release (or a global anticipated title query from the API as a fallback) and a rolling list of games released this week.
- Zone 3 ("Discover"): Features a Critic Score grid with pre-filtered or backfilled top-rated games based on user genre preferences stored in SharedPreferences.

State management is handled via distinct Cubits for each zone (LibraryStatsCubit, CountdownReleasesCubit, CriticsGridCubit) using screen-scoped caching, skeleton shimmers via Skeletonizer, and background silent updates to prevent blocking navigation.

## Layer map
[tech-ac.md](file:///w:/Projects/gameyes/tech-ac.md): domain, data, state, UI

## Data layer

### API contracts
IGDB_Games: POST /games
  Request body: query: String (required)
  Response body: games: List<Game>
  Handled status codes: 200, 401, 403, 500
  Source: [api-contracts.md](file:///w:/Projects/gameyes/.agents/references/api-contracts.md)

IGDB_ReleaseDates: POST /release_dates
  Request body: query: String (required)
  Response body: release_dates: List<ReleaseDate>
  Handled status codes: 200, 401, 403, 500
  Source: [api-contracts.md](file:///w:/Projects/gameyes/.agents/references/api-contracts.md)

### Models
[Game](file:///w:/Projects/gameyes/lib/core/data/models/game.dart) (modify) — [lib/core/data/models/game.dart](file:///w:/Projects/gameyes/lib/core/data/models/game.dart)
  Fields: criticScore: double? (json key: 'total_rating'), hypes: int? (json key: 'hypes'), genres: List<int>? (json key: 'genres')
  Serialisation: fromJson/toJson
  Source: API response

[GameEntity](file:///w:/Projects/gameyes/lib/core/domain/entities/game_entity.dart) (modify) — [lib/core/domain/entities/game_entity.dart](file:///w:/Projects/gameyes/lib/core/domain/entities/game_entity.dart)
  Fields: criticScore: double?, hypes: int?, genreIds: List<int>?
  Serialisation: none
  Source: mapped from [Game](file:///w:/Projects/gameyes/lib/core/data/models/game.dart) DTO

[ReleaseDate](file:///w:/Projects/gameyes/lib/core/data/models/release_date.dart) (modify) — [lib/core/data/models/release_date.dart](file:///w:/Projects/gameyes/lib/core/data/models/release_date.dart)
  Fields: category: int?
  Serialisation: fromJson/toJson
  Source: API response

[SavedGame](file:///w:/Projects/gameyes/lib/features/tracker/data/models/saved_game.dart) (modify) — [lib/features/tracker/data/models/saved_game.dart](file:///w:/Projects/gameyes/lib/features/tracker/data/models/saved_game.dart)
  Fields: status: String?, hoursLogged: double?, averageCompletionHours: double?, manualProgressPercentage: double?, isWishlisted: bool, genres: List<int>?
  Serialisation: none (Isar collection)
  Source: local storage

[PlaySessionLog](file:///w:/Projects/gameyes/lib/features/tracker/data/models/play_session_log.dart) (create) — [lib/features/tracker/data/models/play_session_log.dart](file:///w:/Projects/gameyes/lib/features/tracker/data/models/play_session_log.dart)
  Fields: id: Id, gameId: int?, hoursPlayed: double?, timestamp: DateTime?
  Serialisation: none (Isar collection)
  Source: local storage

### Repositories
[FeaturedRevampRepository](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart) interface (create) — [lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart)
  getLibrarySnapshot(): Future<Result<LibrarySnapshot>>
  getCountdownGame(): Future<Result<GameEntity?>>
  getOutThisWeekGames(bool forceExtendWindow): Future<Result<List<GameEntity>>>
  getCriticsChoiceGames(List<int> genrePreferences): Future<Result<List<GameEntity>>>
  saveGenrePreferences(List<int> genreIds, bool isSkipped): Future<Result<void>>
  getGenrePreferences(): Future<Result<GenrePreferences>>

[FeaturedRevampRepositoryImpl](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/repositories/featured_revamp_repository_impl.dart) implementation (create) — [lib/features/featured_revamp/data/repositories/featured_revamp_repository_impl.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/data/repositories/featured_revamp_repository_impl.dart)
  Implements all methods of [FeaturedRevampRepository](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart) using local and remote data sources.

## Domain layer

### Use cases
[GetLibrarySnapshotUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case.dart) (create) — [lib/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case.dart)
  Input: none
  Returns: LibrarySnapshot
  Calls: [FeaturedRevampRepository.getLibrarySnapshot](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart)
  Errors: [ErrorType](file:///w:/Projects/gameyes/lib/core/data/models/error.dart)

[GetCountdownGameUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_countdown_game_use_case.dart) (create) — [lib/features/featured_revamp/domain/use_cases/get_countdown_game_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_countdown_game_use_case.dart)
  Input: none
  Returns: GameEntity?
  Calls: [FeaturedRevampRepository.getCountdownGame](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart)
  Errors: [ErrorType](file:///w:/Projects/gameyes/lib/core/data/models/error.dart)

[GetOutThisWeekUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_out_this_week_use_case.dart) (create) — [lib/features/featured_revamp/domain/use_cases/get_out_this_week_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_out_this_week_use_case.dart)
  Input: bool forceExtendWindow
  Returns: List<GameEntity>
  Calls: [FeaturedRevampRepository.getOutThisWeekGames](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart)
  Errors: [ErrorType](file:///w:/Projects/gameyes/lib/core/data/models/error.dart)

[GetCriticsChoiceUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_critics_choice_use_case.dart) (create) — [lib/features/featured_revamp/domain/use_cases/get_critics_choice_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_critics_choice_use_case.dart)
  Input: List<int> genrePreferences
  Returns: List<GameEntity>
  Calls: [FeaturedRevampRepository.getCriticsChoiceGames](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart)
  Errors: [ErrorType](file:///w:/Projects/gameyes/lib/core/data/models/error.dart)

[SaveGenrePreferencesUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/save_genre_preferences_use_case.dart) (create) — [lib/features/featured_revamp/domain/use_cases/save_genre_preferences_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/save_genre_preferences_use_case.dart)
  Input: (List<int> genreIds, bool isSkipped)
  Returns: void
  Calls: [FeaturedRevampRepository.saveGenrePreferences](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart)
  Errors: [ErrorType](file:///w:/Projects/gameyes/lib/core/data/models/error.dart)

[GetGenrePreferencesUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_genre_preferences_use_case.dart) (create) — [lib/features/featured_revamp/domain/use_cases/get_genre_preferences_use_case.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_genre_preferences_use_case.dart)
  Input: none
  Returns: GenrePreferences
  Calls: [FeaturedRevampRepository.getGenrePreferences](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/repositories/featured_revamp_repository.dart)
  Errors: [ErrorType](file:///w:/Projects/gameyes/lib/core/data/models/error.dart)

## State layer

### Notifiers / Cubits
[LibraryStatsCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/library_stats_cubit.dart) (create) — [lib/features/featured_revamp/presentation/blocs/library_stats_cubit.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/library_stats_cubit.dart)
  Scope: screen
  State variants:
    - [LibraryStatsStatus.initial]: Empty loading placeholder.
    - [LibraryStatsStatus.loading]: Loading details using [Skeletonizer].
    - [LibraryStatsStatus.success]: Standard populated library snapshot.
    - [LibraryStatsStatus.failed]: Inline error rendering with retry handlers.
  Calls:
    - [GetLibrarySnapshotUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case.dart) on initialization and foreground refresh.

[CountdownReleasesCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart) (create) — [lib/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart)
  Scope: screen
  State variants:
    - [CountdownReleasesStatus.initial]: Empty loading placeholder.
    - [CountdownReleasesStatus.loading]: Loading details using [Skeletonizer].
    - [CountdownReleasesStatus.success]: Standard populated countdown and releases list.
    - [CountdownReleasesStatus.failed]: Inline error rendering with retry handlers.
  Calls:
    - [GetCountdownGameUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_countdown_game_use_case.dart) on initialization, timer updates, and foreground refresh.
    - [GetOutThisWeekUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_out_this_week_use_case.dart) on initialization and foreground refresh.

[CriticsGridCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart) (create) — [lib/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart)
  Scope: screen
  State variants:
    - [CriticsGridStatus.initial]: Empty loading placeholder.
    - [CriticsGridStatus.loading]: Loading details using [Skeletonizer].
    - [CriticsGridStatus.success]: Standard populated critics grid.
    - [CriticsGridStatus.failed]: Inline error rendering with retry handlers.
  Calls:
    - [GetCriticsChoiceUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_critics_choice_use_case.dart) when genre preferences are loaded or updated.
    - [SaveGenrePreferencesUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/save_genre_preferences_use_case.dart) when user saves or skips genre selection.
    - [GetGenrePreferencesUseCase](file:///w:/Projects/gameyes/lib/features/featured_revamp/domain/use_cases/get_genre_preferences_use_case.dart) on initialization.

## UI layer

### Screens
[FeaturedRevampScreen](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/screens/featured_revamp_screen.dart) (create) — [lib/features/featured_revamp/presentation/screens/featured_revamp_screen.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/screens/featured_revamp_screen.dart)
  Type: stateful
  Consumes: [LibraryStatsCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/library_stats_cubit.dart), [CountdownReleasesCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/countdown_releases_cubit.dart), and [CriticsGridCubit](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/blocs/critics_grid_cubit.dart)
  Handles: Pull-to-refresh, lifecycle listener (foreground checking for 15 min refresh).
  Navigates to: library filters screen, game details screen.

### Widgets
[LibraryStatsWidget](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/library_stats.dart) (create) — [lib/features/featured_revamp/presentation/widgets/library_stats.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/library_stats.dart)
  Type: stateless
  Consumes: library snapshot state.
  Handles: Tapping checklist buttons, tapping now playing cards.

[CountdownReleasesWidget](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/countdown_releases.dart) (create) — [lib/features/featured_revamp/presentation/widgets/countdown_releases.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/countdown_releases.dart)
  Type: stateless
  Consumes: countdown and upcoming games state.
  Handles: Tapping release announcement, horizontal releases navigation.

[CriticsGridWidget](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/critics_grid.dart) (create) — [lib/features/featured_revamp/presentation/widgets/critics_grid.dart](file:///w:/Projects/gameyes/lib/features/featured_revamp/presentation/widgets/critics_grid.dart)
  Type: stateless
  Consumes: critics games and genre preferences state.
  Handles: Genre selection pills, skipping preference, tapping critics cards.

## Reuse decisions
- [GamesServices](file:///w:/Projects/gameyes/lib/features/games/services/games_service.dart) — Used for making IGDB queries.
- [SavedGameStatusTag](file:///w:/Projects/gameyes/lib/widgets/saved_game_status_tag.dart) — Reused to display game status tags.
- [BaseRepositoryMixin](file:///w:/Projects/gameyes/lib/core/data/datasource/base_repository_mixin.dart) — Used in implementation of repository data fetching.
- [AppRouter](file:///w:/Projects/gameyes/lib/config/route/auto_route_config.dart) — Integrates revamped screen route.

## Out of scope
- Cosmetic UI detailing, colors, or fonts outside the custom design parameters (e.g. strict RGB score coloring rules).
- Multi-platform custom filters (only global agnostic dashboard elements are implemented).
- Routing to sub-screens like "See All" details.
- Real-time multiplayer synchronization.

## Open questions
None.

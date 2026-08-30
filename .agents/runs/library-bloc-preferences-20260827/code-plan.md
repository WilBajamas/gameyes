# Code Plan
Source: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (item 3.4)
Date: 2026-08-28 (revised 2026-08-30 for D17)

> **Split note (D16).** Item 3.4 is split at the Featured seam and this plan deliberately
> still covers **both halves** — 3.4b's task brief is cut from it and from `tdd.md`
> without re-deriving anything.
> **3.4b** (a later run — criteria AC26–AC36) owns exactly these entries:
> `now_playing_game_entity.dart`, `library_snapshot_entity.dart`,
> `featured_repository_impl.dart`, `featured_local_datasource.dart`,
> `library_stats.dart`, `featured_repository_test.dart`,
> `library_stats_cubit_test.dart` and `library_stats_test.dart`.
> **3.4a** (this run — criteria AC1–AC25, AC37–AC43) owns everything else here.
> `task-brief.md` is scoped to 3.4a and wins on any conflict.

> **D17 revision note.** Every change from the human's Phase 3 review is folded into the
> skeletons below and summarised in `## Approved feedback delta` at the foot of this file.
> `tdd.md` and `task-brief.md` were corrected in place too, because the allowlist and the
> step list both moved.

## CREATE NEW

### lib/core/enums/library_view_mode.dart
```dart
enum LibraryViewMode { grid, list }
```

### lib/core/utils/postgrest_utils.dart
```dart
/// Wraps [term] as a PostgREST `ilike` pattern that matches it literally.
String postgrestLikePattern(String term) {
  // Backslash is what LIKE escapes with, so it has to be doubled first or the
  // escapes added below would themselves be escaped.
  final escaped = term
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');

  return '%$escaped%';
}
```
A top-level function, not a class: no state and no builder chain to hold. Sits beside
`igdb_query_builder.dart` because it is query syntax, not Library knowledge (D17.4).

### lib/features/library/data/datasources/library_preferences_datasource.dart
```dart
@injectable
class LibraryPreferencesDatasource {
  LibraryPreferencesDatasource(this._preferences);

  final SharedPreferences _preferences;

  String? readViewModeName();
  Future<void> writeViewModeName(String name);

  String? readSortName();
  Future<void> writeSortName(String name);
}
```
Every body is the shape already in `tracker_preferences_datasource.dart`: a
`_preferences.getString(StorageConstants.<key>)` or `setString` wrapped in
`try { ... } catch (_) { }`, returning `null` on a failed read and swallowing a failed
write. One comment, on the write side, saying persistence is best-effort.

**`TrackerPreferencesDatasource` is not renamed, moved, extended, edited or deleted**
(D17.1, 3.4-AC22). It is not in the allowlist, and neither is
`tracker_sort_repository_impl.dart` or its test. The small try/catch duplication between
the two datasources is the deliberate, human-approved cost of leaving the live
`tracker_sort_tag` key completely alone.

### lib/features/library/domain/entities/library_counts_entity.dart
```dart
@freezed
sealed class LibraryCountsEntity with _$LibraryCountsEntity {
  const factory LibraryCountsEntity({
    required Map<LibraryStatus, int> byStatus,
    required int total,
  }) = _LibraryCountsEntity;
}
```

### lib/features/library/domain/entities/library_page_entity.dart
```dart
@freezed
sealed class LibraryPageEntity with _$LibraryPageEntity {
  const factory LibraryPageEntity({
    required List<LibraryEntryEntity> entries,
    required int matchedCount,
  }) = _LibraryPageEntity;
}
```

### lib/features/featured/domain/entities/now_playing_game_entity.dart
```dart
@freezed
sealed class NowPlayingGameEntity with _$NowPlayingGameEntity {
  const factory NowPlayingGameEntity({
    required String title,
    String? coverUrl,
    double? progressPercent,
    double? playtimeHours,
    // Nothing writes this yet: library_entries has no average-completion
    // column, so the card's middle progress branch cannot fire.
    double? averageCompletionHours,
  }) = _NowPlayingGameEntity;
}
```

### lib/features/library/domain/repositories/library_preferences_repository.dart
```dart
/// Persistence boundary for the Library's view mode and sort.
///
/// Every member is contractually non-throwing. The getters always return a
/// valid value, defaulting to [LibraryViewMode.grid] and
/// [LibrarySort.recentlyAdded] when the stored value is absent, unreadable or
/// unrecognised.
abstract interface class LibraryPreferencesRepository {
  LibraryViewMode getViewMode();
  Future<void> saveViewMode(LibraryViewMode mode);

  LibrarySort getSort();
  Future<void> saveSort(LibrarySort sort);
}
```

### lib/features/library/data/repositories/library_preferences_repository_impl.dart
```dart
@Injectable(as: LibraryPreferencesRepository)
class LibraryPreferencesRepositoryImpl implements LibraryPreferencesRepository {
  LibraryPreferencesRepositoryImpl(this._datasource);

  final LibraryPreferencesDatasource _datasource;

  @override
  LibraryViewMode getViewMode() { /* match .name over values, else grid */ }

  @override
  Future<void> saveViewMode(LibraryViewMode mode) =>
      _datasource.writeViewModeName(mode.name);

  @override
  LibrarySort getSort() { /* match .name over values, else recentlyAdded */ }

  @override
  Future<void> saveSort(LibrarySort sort) =>
      _datasource.writeSortName(sort.name);
}
```

### lib/features/library/domain/use_cases/fetch_library_counts_use_case.dart
```dart
@injectable
class FetchLibraryCountsUseCase {
  const FetchLibraryCountsUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryCountsEntity>> call() => _repository.fetchCounts();
}
```

### lib/features/library/domain/use_cases/get_library_preferences_use_case.dart
```dart
@injectable
class GetLibraryPreferencesUseCase {
  const GetLibraryPreferencesUseCase(this._repository);

  final LibraryPreferencesRepository _repository;

  // Synchronous and outside Result: the repository below cannot fail or throw.
  ({LibraryViewMode viewMode, LibrarySort sort}) call() =>
      (viewMode: _repository.getViewMode(), sort: _repository.getSort());
}
```

### lib/features/library/domain/use_cases/save_library_view_mode_use_case.dart
```dart
@injectable
class SaveLibraryViewModeUseCase {
  const SaveLibraryViewModeUseCase(this._repository);

  final LibraryPreferencesRepository _repository;

  Future<void> call(LibraryViewMode mode) => _repository.saveViewMode(mode);
}
```

### lib/features/library/domain/use_cases/save_library_sort_use_case.dart
```dart
@injectable
class SaveLibrarySortUseCase {
  const SaveLibrarySortUseCase(this._repository);

  final LibraryPreferencesRepository _repository;

  Future<void> call(LibrarySort sort) => _repository.saveSort(sort);
}
```

### lib/features/library/presentation/blocs/library_state.dart
```dart
enum LibraryLoadStatus { initial, loading, success, failed, empty }

enum LibraryNextPageStatus { initial, loading, failed }

@freezed
sealed class LibraryState with _$LibraryState {
  const factory LibraryState({
    LibraryStatus? activeStatus,
    @Default(LibrarySort.recentlyAdded) LibrarySort sort,
    @Default(LibraryViewMode.grid) LibraryViewMode viewMode,
    @Default('') String searchTerm,
    @Default(<LibraryEntryEntity>[]) List<LibraryEntryEntity> entries,
    @Default(LibraryLoadStatus.initial) LibraryLoadStatus status,
    @Default(LibraryNextPageStatus.initial) LibraryNextPageStatus nextPageStatus,
    @Default(false) bool hasReachedEnd,
    // Null means the counts have not been read, which is not the same as a
    // library where every status is genuinely zero.
    LibraryCountsEntity? counts,
    @Default(0) int matchedCount,
    ErrorType? error,
    ErrorType? nextPageError,
  }) = _LibraryState;
}
```
No generation counter here — it lives on the bloc as a private field, so state equality
and every UI rebuild are unaffected (D17.7).

### lib/features/library/presentation/blocs/library_event.dart
```dart
part of 'library_bloc.dart';

sealed class LibraryEvent extends Equatable {
  const LibraryEvent();
}

/// Anything that resets pagination and refetches the first page.
sealed class LibraryQueryChanged extends LibraryEvent {
  const LibraryQueryChanged();
}

final class LibraryStarted extends LibraryQueryChanged {
  const LibraryStarted();

  @override
  List<Object?> get props => [];
}

final class LibraryStatusSelected extends LibraryQueryChanged {
  const LibraryStatusSelected(this.status);

  final LibraryStatus? status;

  @override
  List<Object?> get props => [status];
}

final class LibrarySortSelected extends LibraryQueryChanged {
  const LibrarySortSelected(this.sort);

  final LibrarySort sort;

  @override
  List<Object?> get props => [sort];
}

final class LibrarySearchTermChanged extends LibraryQueryChanged {
  const LibrarySearchTermChanged(this.term);

  final String term;

  @override
  List<Object?> get props => [term];
}

final class LibraryRetried extends LibraryQueryChanged {
  const LibraryRetried();

  @override
  List<Object?> get props => [];
}

final class LibraryViewModeSelected extends LibraryEvent {
  const LibraryViewModeSelected(this.viewMode);

  final LibraryViewMode viewMode;

  @override
  List<Object?> get props => [viewMode];
}

final class LibraryNextPageRequested extends LibraryEvent {
  const LibraryNextPageRequested();

  @override
  List<Object?> get props => [];
}
```

### lib/features/library/presentation/blocs/library_bloc.dart
```dart
part 'library_event.dart';

// Typing waits until it stops; a chip or sort tap is deliberate and runs at
// once. Merging the two back together keeps one handler, so the newest query
// always supersedes the one before it.
EventTransformer<LibraryQueryChanged> _latestQuery() {
  return (events, mapper) {
    final searches = events
        .where((event) => event is LibrarySearchTermChanged)
        .debounce(LibraryConstants.searchDebounce);
    final rest = events.where((event) => event is! LibrarySearchTermChanged);

    return restartable<LibraryQueryChanged>()(rest.merge(searches), mapper);
  };
}

@injectable
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc(
    this._fetchLibraryPageUseCase,
    this._fetchLibraryCountsUseCase,
    this._getLibraryPreferencesUseCase,
    this._saveLibraryViewModeUseCase,
    this._saveLibrarySortUseCase,
  ) : super(const LibraryState()) {
    on<LibraryQueryChanged>(_onQueryChanged, transformer: _latestQuery());
    on<LibraryViewModeSelected>(_onViewModeSelected);
    on<LibraryNextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  final FetchLibraryPageUseCase _fetchLibraryPageUseCase;
  final FetchLibraryCountsUseCase _fetchLibraryCountsUseCase;
  final GetLibraryPreferencesUseCase _getLibraryPreferencesUseCase;
  final SaveLibraryViewModeUseCase _saveLibraryViewModeUseCase;
  final SaveLibrarySortUseCase _saveLibrarySortUseCase;

  // Goes up every time the query changes. A page that comes back under an
  // older number was asked for on behalf of a list nobody is looking at now.
  int _queryGeneration = 0;

  Future<void> _onQueryChanged(
    LibraryQueryChanged event,
    Emitter<LibraryState> emit,
  ) async {
    _queryGeneration++;

    final preferences = event is LibraryStarted
        ? _getLibraryPreferencesUseCase()
        : null;

    final activeStatus = event is LibraryStatusSelected
        ? event.status
        : state.activeStatus;
    final sort = switch (event) {
      LibrarySortSelected(:final sort) => sort,
      _ => preferences?.sort ?? state.sort,
    };
    final searchTerm = event is LibrarySearchTermChanged
        ? event.term.trim()
        : state.searchTerm;

    // The stored view mode and sort land in the same emit as the first loading
    // state, so nothing ever paints in the wrong view. The entries already on
    // screen are left alone so a search never blanks the list.
    emit(
      state.copyWith(
        activeStatus: activeStatus,
        sort: sort,
        viewMode: preferences?.viewMode ?? state.viewMode,
        searchTerm: searchTerm,
        status: LibraryLoadStatus.loading,
        nextPageStatus: LibraryNextPageStatus.initial,
        hasReachedEnd: false,
        error: null,
        nextPageError: null,
      ),
    );

    if (event is LibrarySortSelected) {
      _saveLibrarySortUseCase(sort).ignore();
    }

    // Both calls are started before either is awaited so they run side by
    // side; awaiting the page first would leave the counts queued behind it.
    final pageCall = _fetchLibraryPageUseCase(
      status: activeStatus,
      sort: sort,
      limit: LibraryConstants.pageSize,
      offset: 0,
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
    );
    // Whole-status figures never change with the filter, so they are read
    // once per visit rather than on every chip tap.
    final countsCall = state.counts == null
        ? _fetchLibraryCountsUseCase()
        : null;

    final pageResult = await pageCall;
    final countsResult = countsCall == null ? null : await countsCall;

    final counts = switch (countsResult) {
      Success(value: final value) => value,
      _ => state.counts,
    };

    emit(
      switch (pageResult) {
        Success(value: final page) => state.copyWith(
          status: page.entries.isEmpty
              ? LibraryLoadStatus.empty
              : LibraryLoadStatus.success,
          entries: page.entries,
          matchedCount: page.matchedCount,
          hasReachedEnd: page.entries.length >= page.matchedCount,
          counts: counts,
        ),
        Failure(error: final error) => state.copyWith(
          status: LibraryLoadStatus.failed,
          error: error,
          counts: counts,
        ),
      },
    );
  }

  void _onViewModeSelected(
    LibraryViewModeSelected event,
    Emitter<LibraryState> emit,
  ) {
    if (event.viewMode == state.viewMode) return;

    emit(state.copyWith(viewMode: event.viewMode));

    // Fire-and-forget: a slow or failing write must not delay the toggle.
    _saveLibraryViewModeUseCase(event.viewMode).ignore();
  }

  Future<void> _onNextPageRequested(
    LibraryNextPageRequested event,
    Emitter<LibraryState> emit,
  ) async {
    if (state.hasReachedEnd || state.status != LibraryLoadStatus.success) {
      return;
    }

    final generation = _queryGeneration;

    emit(state.copyWith(nextPageStatus: LibraryNextPageStatus.loading));

    final result = await _fetchLibraryPageUseCase(
      status: state.activeStatus,
      sort: state.sort,
      limit: LibraryConstants.pageSize,
      offset: state.entries.length,
      searchTerm: state.searchTerm.isEmpty ? null : state.searchTerm,
    );

    // The filter, sort or search changed while this page was on its way, so
    // these rows would be appended under the wrong heading. Drop them; the
    // query that replaced it has already reset the next-page state.
    if (generation != _queryGeneration) return;

    emit(
      switch (result) {
        Success(value: final page) => state.copyWith(
          nextPageStatus: LibraryNextPageStatus.initial,
          entries: List.of(state.entries)..addAll(page.entries),
          matchedCount: page.matchedCount,
          hasReachedEnd:
              state.entries.length + page.entries.length >= page.matchedCount,
        ),
        Failure(error: final error) => state.copyWith(
          nextPageStatus: LibraryNextPageStatus.failed,
          nextPageError: error,
        ),
      },
    );
  }
}
```

---

## MODIFY EXISTING

### pubspec.yaml
```yaml
  # Bloc Transformer
  bloc_concurrency: ^0.3.0

  # Stream transformer, for the search debounce
  stream_transform: ^2.1.1
```
One line plus its comment, and nothing else. `bloc_concurrency` **stays** —
`restartable()` and `droppable()` have no `stream_transform` equivalent. The package is
already resolved at 2.1.1 in `pubspec.lock` as a transitive dependency, so
`flutter pub get` only flips that entry's `dependency:` field to `direct main`. This is
the single human-authorised exception to `execution.md`'s read-only rule on this file
(D17.6).

### lib/core/res/const.dart
```dart
class StorageConstants {
  static const firstUseKey = 'first_use';
  static const trackerSortTagKey = 'tracker_sort_tag';
  static const libraryViewModeKey = 'library_view_mode';
  static const librarySortKey = 'library_sort';
}
```
`trackerSortTagKey` is untouched — the two library keys are additions beside it.

### lib/features/library/const.dart
```dart
class LibraryEntryConstants { /* unchanged */ }

class LibraryConstants {
  static const pageSize = 20;
  static const searchDebounce = Duration(milliseconds: 300);
}
```

### lib/features/library/data/datasources/library_remote_datasource.dart
```dart
  Future<(List<LibraryEntryModel>, int)> fetchPage({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
    String? searchTerm,
  }) async {
    final userId = _currentUserId();
    final (column, isDescending) = _sortColumn(sort);

    var query = _client
        .from(LibraryEntryConstants.table)
        .select()
        .count()
        .eq(LibraryEntryConstants.userId, userId);

    if (status != null) {
      query = query.eq(LibraryEntryConstants.status, status.columnValue);
    }
    if (searchTerm != null) {
      query = query.ilike(
        LibraryEntryConstants.title,
        postgrestLikePattern(searchTerm),
      );
    }

    final response = await query
        .order(column, ascending: !isDescending)
        .range(offset, offset + limit - 1);

    return (
      response.data.map(LibraryEntryModel.fromJson).toList(),
      response.count,
    );
  }

  // Six head counts, run together. The total is their sum: status is NOT NULL
  // with a six-value check constraint, so every row lands in exactly one.
  Future<Map<LibraryStatus, int>> fetchCounts() async {
    final userId = _currentUserId();

    final counts = await Future.wait(
      LibraryStatus.values.map(
        (status) => _client
            .from(LibraryEntryConstants.table)
            .count()
            .eq(LibraryEntryConstants.userId, userId)
            .eq(LibraryEntryConstants.status, status.columnValue),
      ),
    );

    return Map.fromIterables(LibraryStatus.values, counts);
  }

  Future<List<LibraryEntryModel>> fetchAllEntries({
    LibraryStatus? status,
  }) async { /* eq(user), optional eq(status), order(updatedAt, desc) */ }
```
**No `_pattern` helper in this file** — the escaping is `postgrestLikePattern` in
`lib/core/utils/postgrest_utils.dart` (D17.4). The precise builder-chain typing around
`.count()` and the conditional `.eq` / `.ilike` reassignment is Dev's to settle against the
analyzer; the request shape above is the contract. `add`, `update`, `remove`,
`_currentUserId` and `_sortColumn` are unchanged.

### lib/features/library/domain/repositories/library_repository.dart
```dart
abstract interface class LibraryRepository {
  Future<Result<LibraryPageEntity>> fetchPage({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
    String? searchTerm,
  });

  Future<Result<LibraryCountsEntity>> fetchCounts();

  /// Every entry for the signed-in user, unpaged, newest change first.
  Future<Result<List<LibraryEntryEntity>>> fetchAllEntries({
    LibraryStatus? status,
  });

  // add / update / remove unchanged
}
```

### lib/features/library/data/repositories/library_repository_impl.dart
```dart
  @override
  Future<Result<LibraryPageEntity>> fetchPage({...}) =>
      fetchData(apiCall: _page(...));

  @override
  Future<Result<LibraryCountsEntity>> fetchCounts() =>
      fetchData(apiCall: _counts());

  @override
  Future<Result<List<LibraryEntryEntity>>> fetchAllEntries({
    LibraryStatus? status,
  }) => fetchData(apiCall: _allEntries(status: status));

  Future<LibraryPageEntity> _page({...}) async {
    final (rows, matchedCount) = await _datasource.fetchPage(...);

    return LibraryPageEntity(
      entries: rows.map((row) => row.toEntity()).toList(),
      matchedCount: matchedCount,
    );
  }

  Future<LibraryCountsEntity> _counts() async {
    final byStatus = await _datasource.fetchCounts();

    return LibraryCountsEntity(
      byStatus: byStatus,
      total: byStatus.values.fold(0, (sum, count) => sum + count),
    );
  }
```

### lib/features/library/domain/use_cases/fetch_library_page_use_case.dart
```dart
  Future<Result<LibraryPageEntity>> call({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
    String? searchTerm,
  }) => _repository.fetchPage(
    status: status,
    sort: sort,
    limit: limit,
    offset: offset,
    searchTerm: searchTerm,
  );
```

### lib/features/featured/domain/entities/library_snapshot_entity.dart
```dart
class LibrarySnapshotEntity {
  final int totalGamesCount;
  final List<NowPlayingGameEntity> nowPlayingGames;
  final double thisWeekPlayHours;
  final int wishlistCount;
  final Set<int> ownedGameIds;
  // constructor unchanged
}
```

### lib/features/featured/data/repositories/featured_repository_impl.dart
```dart
  FeaturedRepositoryImpl(
    this._localDatasource,
    this._featuredApiService,
    this._libraryRepository,
  );

  final LibraryRepository _libraryRepository;

  @override
  Future<Result<LibrarySnapshotEntity>> getLibrarySnapshot() async {
    try {
      // Both reads are started before either is awaited so they run side by
      // side; awaiting the entries first would leave the counts queued.
      final entriesCall = _libraryRepository.fetchAllEntries();
      final countsCall = _libraryRepository.fetchCounts();
      final playHours = await _localDatasource.getThisWeekPlayHours();

      // A library read that fails or is signed out shows the zeroes these
      // tiles have always shown; it does not fail the whole screen.
      final entries = switch (await entriesCall) {
        Success(value: final value) => value,
        Failure() => const <LibraryEntryEntity>[],
      };
      final counts = switch (await countsCall) {
        Success(value: final value) => value,
        Failure() => null,
      };

      return Success(
        LibrarySnapshotEntity(
          totalGamesCount: counts?.total ?? 0,
          nowPlayingGames: entries
              .where((entry) => entry.status == LibraryStatus.playing)
              .map(_nowPlaying)
              .toList(),
          thisWeekPlayHours: playHours,
          wishlistCount: counts?.byStatus[LibraryStatus.wishlist] ?? 0,
          ownedGameIds: entries.map((entry) => entry.igdbId).toSet(),
        ),
      );
    } catch (e, stacktrace) {
      // unchanged
    }
  }

  NowPlayingGameEntity _nowPlaying(LibraryEntryEntity entry) =>
      NowPlayingGameEntity(
        title: entry.title,
        coverUrl: entry.coverUrl,
        progressPercent: entry.progressPercent,
        playtimeHours: entry.playtimeHours,
      );

  Future<Set<int>> _wishlistIds() async {
    final result = await _libraryRepository.fetchAllEntries(
      status: LibraryStatus.wishlist,
    );

    return switch (result) {
      Success(value: final entries) =>
        entries.map((entry) => entry.igdbId).toSet(),
      Failure() => const <int>{},
    };
  }
```
`getCountdownGame` and `getOutThisWeekGames` replace their
`_localDatasource.getWishlistedGames()` blocks with `await _wishlistIds()`. Everything
else in both methods, and all of `getCriticsChoiceGames` and the genre-preference
methods, is unchanged. **3.4b's file.**

### lib/features/featured/data/datasources/featured_local_datasource.dart
```dart
// Removed: countSavedGames, getOwnedGameIds, getWishlistedGames,
// getNowPlayingGames — all four filtered on Isar fields nothing writes.
// Kept unchanged: getThisWeekPlayHours, saveGenrePreferences,
// getSavedGenrePreferences, getSavedGames, _getDb.
```
**3.4b's file.**

### lib/features/featured/presentation/widgets/library_stats.dart
```dart
class _NowPlayingCard extends StatelessWidget {
  const _NowPlayingCard(this.playingGames);

  final List<NowPlayingGameEntity> playingGames;

  @override
  Widget build(BuildContext context) {
    if (playingGames.isEmpty) { /* EmptyStateCard, unchanged */ }

    final topGame = playingGames.first;
    final int extraCount = playingGames.length - 1;

    double? progressPercent;
    String? progressLabel;

    if (topGame.progressPercent != null) {
      progressPercent = topGame.progressPercent! / 100.0;
      progressLabel = S.current.completed_percentage(
        topGame.progressPercent!.toInt().toString(),
      );
    } else if (topGame.playtimeHours != null &&
        topGame.averageCompletionHours != null &&
        topGame.averageCompletionHours! > 0) {
      // unchanged arithmetic, reading playtimeHours / averageCompletionHours
    } else if (topGame.playtimeHours != null) {
      progressLabel = S.current.played_hours(
        topGame.playtimeHours!.toStringAsFixed(1),
      );
    }

    return Card(
      // ...
      child: InkWell(
        onTap: () => AutoTabsRouter.of(context).setActiveIndex(1),
        // ...
              Text(topGame.title, maxLines: 2, ...),
  }
}
```
`_buildNowPlayingCard` becomes this `StatelessWidget` (D17.2) — a method cannot be
`const` and rebuilds with its parent. `topGame.imageUrl` becomes `topGame.coverUrl`; the
`name ?? emptyStringPlaceholder` fallback goes because `title` is non-nullable. The
`config/route/auto_route_config.gr.dart` import is removed with the push. No comments.
**3.4b's file.**

### .agents/week-3-task-briefs.md (lines 82–84 only)
```markdown
**Consequence:** the deliberate `_TaskReminder` pair lives in
`task_detail_screen.dart` and that file survives, so **2 warnings stays the
invariant all week.** The *total* is not an invariant — it has moved three times
(30 → 28 → 29) and moves again whenever an item adds or deletes files. Measure
both on the untouched tree at Phase 0 of every item; a changed total on its own
proves nothing.
```

---

## TEST FILES

### test/repository/library/library_remote_datasource_test.dart
- `'should filter by user and sort by created_at descending for a default paged fetch'`
- `'should add a status predicate when a status is supplied'`
- `'should add a case-insensitive title predicate when a search term is supplied'`
- `'should keep both predicates when a status and a search term are supplied'`
- `'should escape percent, underscore and backslash in the search term'` — the built
  pattern matches them literally and adds no wildcard (3.4-AC19, and the coverage
  `postgrestLikePattern` gets in place of its own test file)
- `'should keep a comma in the search term inside a single predicate'`
- `'should use the expected column and direction for each sort option'`
- `'should request the second page when a non-zero offset is supplied'`
- `'should send the supplied fields on an add'`
- `'should omit unsupplied fields on a partial update'`
- `'should send an explicit null for the rating column when clearRating is set'` (3.4-AC38)
- `'should omit the rating key when neither a rating nor clearRating is supplied'` (3.4-AC38)
- `'should request one count per status'`

Harness per `tdd.md ## Caveats` item 3: loopback `HttpServer`, real `SupabaseClient`,
`auth.setInitialSession`, and `tearDown` that disposes both. No new package.

### test/repository/library/library_preferences_repository_test.dart
Mocks `LibraryPreferencesDatasource`.
- `'should return grid and recently added when nothing is stored'`
- `'should return the stored view mode and sort'`
- `'should fall back to the defaults when the stored value is unrecognised'`
- `'should write the enum name for the view mode and the sort'`
- `'should not surface an error when a write fails'`

### test/repository/library/library_repository_test.dart (modify)
- existing `fetchPage` tests updated for `LibraryPageEntity`, plus
  `'should carry the matched count through from the datasource'`
- `'should sum the six status counts into the library total'`
- `'should return zero for a status with no rows'` (3.4-AC15)
- `'should return a failure when the session is missing'` (3.4-AC17)
- `'should return every entry ordered by the datasource for an unpaged read'`

### test/use_case/library/fetch_library_page_use_case_test.dart (modify)
- existing tests updated for the new signature, plus
  `'should forward the search term to the repository'`

### test/use_case/library/fetch_library_counts_use_case_test.dart
- `'should return the counts when the repository succeeds'`
- `'should return the failure when the repository fails'`

### test/cubit/library/library_bloc_test.dart
Plain `test()` first, because it is the 3.4-AC12 guard:
- `'initial state is the declared LibraryState and no use case is called'`

Then `blocTest`s:
- `'emits loading then success when the first page loads'`
- `'emits loading then failed when the first page fails'`
- `'resets to the first page and keeps sort, view mode and term when the status changes'`
- `'resets to the first page and keeps status, view mode and term when the sort changes'`
- `'emits a new view mode without fetching'`
- `'sends both the status and the search term when a term is entered under an active status'`
- `'issues one query for three keystrokes inside the debounce window'`
- `'emits nothing and keeps the loaded entries until the debounce window elapses'` (3.4-AC42)
- `'appends the next page rather than replacing the loaded entries'`
- `'sets the end-of-results flag once the loaded count reaches the matched count'` (3.4-AC7)
- `'does not set the end-of-results flag on a full page that is not the last'` (3.4-AC7 —
  the 40-rows-at-20 case the old short-page rule got wrong)
- `'discards a next-page response that arrives after the status changed'` (3.4-AC43)
- `'applies the stored view mode and sort before the first fetch'`
- `'reads the counts once and not again when the status changes'`

Debounce and generation tests need `bloc_test`'s `wait:` and a page future the test
controls (a `Completer`), so the status change can land while the next page is still out.

### test/repository/featured/featured_repository_test.dart (modify)
- both existing countdown tests restubbed onto `LibraryRepository.fetchAllEntries`
- `'should return a non-empty now-playing list when library entries are playing'` (3.4-AC35)
- `'should return a successful snapshot with zeroes when the library read fails'` (3.4-AC33)
- `'should count owned ids across every status'` (3.4-AC28)

**3.4b's file.**

### test/features/featured/presentation/blocs/library_stats_cubit_test.dart (modify)
The one `TrackerSavedGameEntity` at line 101 becomes a `NowPlayingGameEntity`. No other
change; the assertions stand. **3.4b's file.**

### test/widget/featured/library_stats_test.dart
- `'shows the playing game title when a game is playing'` (3.4-AC35's second half —
  the card, not `EmptyStateCard`)
- `'shows the empty state card when nothing is playing'`

Two tests, no dimension or colour assertions, no tap test — the tap destination is
3.4-AC36's on-device manual check. **3.4b's file.**

**Not a test file any more:** `test/repository/tracker/tracker_sort_repository_test.dart`
was in the pre-D17 plan as a MODIFY, to swap the mocked datasource type. With the rename
withdrawn there is nothing to swap, so it is out of the allowlist and must not be edited
(D17.1, 3.4-AC22). Leaving it untouched and green is itself the evidence the tracker key
did not move.

---

## Approved feedback delta

The human's Phase 3 review of this plan, recorded as **D17** in
`orchestrator-state.md ## Human decisions`. All seven are folded into the skeletons above
and into `tdd.md` and `task-brief.md` in place; this list is here so the Phase 3 diff
stays readable. Where anything below conflicts with an older reading of the plan, this
list wins.

1. **D17.1 — no shared preferences datasource.** `AppPreferencesDatasource` is withdrawn
   entirely. `TrackerPreferencesDatasource` is not renamed, moved, extended, edited or
   deleted; a separate `LibraryPreferencesDatasource` is added at
   `lib/features/library/data/datasources/library_preferences_datasource.dart`. Out of the
   allowlist: `tracker_preferences_datasource.dart`, `tracker_sort_repository_impl.dart`
   and `tracker_sort_repository_test.dart`. Two plan steps disappear with them.
   **Changes 3.4-AC22** — the BA has already rewritten it.
2. **D17.2 — `_buildNowPlayingCard` becomes a `StatelessWidget`.** Applied to the
   `library_stats.dart` entry above. **3.4b's file and 3.4b's change**; not in 3.4a's
   allowlist.
3. **D17.3 — the parallel-call idiom is commented.** Two plain-English lines where
   `pageCall`/`countsCall` (bloc) and `entriesCall`/`countsCall`
   (`FeaturedRepositoryImpl`) are assigned before either is awaited.
4. **D17.4 — `_pattern` moves out of the datasource** to
   `lib/core/utils/postgrest_utils.dart` as a public `postgrestLikePattern(String term)`,
   beside `igdb_query_builder.dart`. New allowlist entry; new plan step. **No dedicated
   test file** — the escaping is asserted through the datasource test, which sees the
   built URL and therefore the percent-encoding too, and `testing-conventions.md` has no
   utility test layer to put one in. Reversible in one step if the human wants it.
5. **D17.5 — the search debounce must not clear the list or flash a loader.** The loading
   emit no longer sets `entries: const []`, and it now happens *after* the debounce rather
   than before it, so a keystroke inside the window emits nothing at all. **Adds
   3.4-AC42.**
6. **D17.6 — `stream_transform` is declared and a named `debounce()` transformer replaces
   the hand-rolled `Future.delayed`.** `pubspec.yaml` joins the allowlist for this one
   line, as an explicit human-authorised exception to `execution.md`'s read-only rule.
   `bloc_concurrency` stays — `restartable()` and `droppable()` have no equivalent in
   `stream_transform`. New plan step.
7. **D17.7 — a stale next-page response is discarded.** A private `int _queryGeneration`
   on the bloc — deliberately **not** a `LibraryState` field, so equality and rebuilds are
   unaffected — bumped by the query handler, captured by the next-page handler before its
   await and re-checked after. On a mismatch the handler returns without emitting.
   "Cancel" means discarding the response; the Supabase client exposes no request
   cancellation and the observable behaviour is identical. **Adds 3.4-AC43.**
8. **D17.8 — `hasReachedEnd` comes from `matchedCount`.** Both handlers now compare the
   loaded count against `page.matchedCount`; `entries.length < pageSize` is gone from the
   query handler and the next-page handler alike. **Reverses 3.4-AC7.**

Step count after all seven: **20 non-generation steps, still at the ceiling** — two added
(`postgrest_utils.dart`, `pubspec.yaml`), two removed (the tracker impl and its test).
Nothing was trimmed to fit.

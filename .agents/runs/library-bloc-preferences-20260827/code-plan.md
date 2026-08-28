# Code Plan
Source: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (item 3.4)
Date: 2026-08-28

## CREATE NEW

### lib/core/enums/library_view_mode.dart
```dart
enum LibraryViewMode { grid, list }
```

### lib/core/data/datasource/app_preferences_datasource.dart
```dart
@injectable
class AppPreferencesDatasource {
  AppPreferencesDatasource(this._preferences);

  final SharedPreferences _preferences;

  String? readTrackerSortTagName();
  Future<void> writeTrackerSortTagName(String name);

  String? readLibraryViewModeName();
  Future<void> writeLibraryViewModeName(String name);

  String? readLibrarySortName();
  Future<void> writeLibrarySortName(String name);
}
```
Every body is the shape already in `tracker_preferences_datasource.dart`: a
`_preferences.getString(StorageConstants.<key>)` or `setString` wrapped in
`try { ... } catch (_) { }`, returning `null` on a failed read and swallowing a failed
write. `StorageConstants.trackerSortTagKey` is reused unchanged; the two library keys are
new. One comment, on the write side, saying persistence is best-effort — the existing
one, kept.

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

  final AppPreferencesDatasource _datasource;

  @override
  LibraryViewMode getViewMode() { /* match .name over values, else grid */ }

  @override
  Future<void> saveViewMode(LibraryViewMode mode) =>
      _datasource.writeLibraryViewModeName(mode.name);

  @override
  LibrarySort getSort() { /* match .name over values, else recentlyAdded */ }

  @override
  Future<void> saveSort(LibrarySort sort) =>
      _datasource.writeLibrarySortName(sort.name);
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

@injectable
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc(
    this._fetchLibraryPageUseCase,
    this._fetchLibraryCountsUseCase,
    this._getLibraryPreferencesUseCase,
    this._saveLibraryViewModeUseCase,
    this._saveLibrarySortUseCase,
  ) : super(const LibraryState()) {
    // One handler for the whole family, so the newest query always wins:
    // separate registrations would let a chip tap and a search race.
    on<LibraryQueryChanged>(_onQueryChanged, transformer: restartable());
    on<LibraryViewModeSelected>(_onViewModeSelected);
    on<LibraryNextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  final FetchLibraryPageUseCase _fetchLibraryPageUseCase;
  final FetchLibraryCountsUseCase _fetchLibraryCountsUseCase;
  final GetLibraryPreferencesUseCase _getLibraryPreferencesUseCase;
  final SaveLibraryViewModeUseCase _saveLibraryViewModeUseCase;
  final SaveLibrarySortUseCase _saveLibrarySortUseCase;

  Future<void> _onQueryChanged(
    LibraryQueryChanged event,
    Emitter<LibraryState> emit,
  ) async {
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

    // The stored view mode and sort land in the same emit as the first
    // loading state, so nothing ever paints in the wrong view.
    emit(
      state.copyWith(
        activeStatus: activeStatus,
        sort: sort,
        viewMode: preferences?.viewMode ?? state.viewMode,
        searchTerm: searchTerm,
        status: LibraryLoadStatus.loading,
        nextPageStatus: LibraryNextPageStatus.initial,
        entries: const [],
        hasReachedEnd: false,
        error: null,
        nextPageError: null,
      ),
    );

    if (event is LibrarySearchTermChanged) {
      await Future<void>.delayed(LibraryConstants.searchDebounce);
      // A newer event superseded this one while we waited.
      if (emit.isDone) return;
    }

    if (event is LibrarySortSelected) {
      _saveLibrarySortUseCase(sort).ignore();
    }

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
          hasReachedEnd: page.entries.length < LibraryConstants.pageSize,
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

    emit(state.copyWith(nextPageStatus: LibraryNextPageStatus.loading));

    final result = await _fetchLibraryPageUseCase(
      status: state.activeStatus,
      sort: state.sort,
      limit: LibraryConstants.pageSize,
      offset: state.entries.length,
      searchTerm: state.searchTerm.isEmpty ? null : state.searchTerm,
    );

    emit(
      switch (result) {
        Success(value: final page) => state.copyWith(
          nextPageStatus: LibraryNextPageStatus.initial,
          entries: List.of(state.entries)..addAll(page.entries),
          matchedCount: page.matchedCount,
          hasReachedEnd: page.entries.length < LibraryConstants.pageSize,
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

### lib/core/res/const.dart
```dart
class StorageConstants {
  static const firstUseKey = 'first_use';
  static const trackerSortTagKey = 'tracker_sort_tag';
  static const libraryViewModeKey = 'library_view_mode';
  static const librarySortKey = 'library_sort';
}
```

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
      query = query.ilike(LibraryEntryConstants.title, _pattern(searchTerm));
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

  // Backslash is what LIKE escapes with, so it has to be doubled first or the
  // escapes we add below get escaped themselves.
  String _pattern(String term) {
    final escaped = term
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');

    return '%$escaped%';
  }
```
The precise builder-chain typing around `.count()` and the conditional `.eq` /
`.ilike` reassignment is Dev's to settle against the analyzer; the request shape above is
the contract. `add`, `update`, `remove`, `_currentUserId` and `_sortColumn` are unchanged.

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

### lib/features/tracker/data/repositories/tracker_sort_repository_impl.dart
```dart
class TrackerSortRepositoryImpl implements TrackerSortRepository {
  TrackerSortRepositoryImpl(this._datasource);

  final AppPreferencesDatasource _datasource;

  @override
  SavedGameFilterTag getSortTag() {
    final name = _datasource.readTrackerSortTagName();
    // body unchanged
  }

  @override
  Future<void> saveSortTag(SavedGameFilterTag tag) =>
      _datasource.writeTrackerSortTagName(tag.name);
}
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
methods, is unchanged.

### lib/features/featured/data/datasources/featured_local_datasource.dart
```dart
// Removed: countSavedGames, getOwnedGameIds, getWishlistedGames,
// getNowPlayingGames — all four filtered on Isar fields nothing writes.
// Kept unchanged: getThisWeekPlayHours, saveGenrePreferences,
// getSavedGenrePreferences, getSavedGames, _getDb.
```

### lib/features/featured/presentation/widgets/library_stats.dart
```dart
  Widget _buildNowPlayingCard(
    BuildContext context,
    List<NowPlayingGameEntity> playingGames,
  ) {
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
```
`topGame.imageUrl` becomes `topGame.coverUrl`; the `name ?? emptyStringPlaceholder`
fallback goes because `title` is non-nullable. The
`config/route/auto_route_config.gr.dart` import is removed with the push. No comments.

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
  pattern matches them literally and adds no wildcard
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
- `'appends the next page rather than replacing the loaded entries'`
- `'sets the end-of-results flag on a short page and issues no further query'`
- `'applies the stored view mode and sort before the first fetch'`
- `'reads the counts once and not again when the status changes'`

### test/repository/tracker/tracker_sort_repository_test.dart (modify)
Mock type swaps to `AppPreferencesDatasource` and the stubbed methods to
`readTrackerSortTagName` / `writeTrackerSortTagName`. **Every assertion stays as it is** —
unchanged assertions are what prove the key and its semantics did not move.

### test/repository/featured/featured_repository_test.dart (modify)
- both existing countdown tests restubbed onto `LibraryRepository.fetchAllEntries`
- `'should return a non-empty now-playing list when library entries are playing'` (3.4-AC35)
- `'should return a successful snapshot with zeroes when the library read fails'` (3.4-AC33)
- `'should count owned ids across every status'` (3.4-AC28)

### test/features/featured/presentation/blocs/library_stats_cubit_test.dart (modify)
The one `TrackerSavedGameEntity` at line 101 becomes a `NowPlayingGameEntity`. No other
change; the assertions stand.

### test/widget/featured/library_stats_test.dart
- `'shows the playing game title when a game is playing'` (3.4-AC35's second half —
  the card, not `EmptyStateCard`)
- `'shows the empty state card when nothing is playing'`

Two tests, no dimension or colour assertions, no tap test — the tap destination is
3.4-AC36's on-device manual check.

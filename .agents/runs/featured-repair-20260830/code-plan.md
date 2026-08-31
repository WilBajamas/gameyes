# Code Plan
Source: `.agents/runs/featured-repair-20260830/tech-ac.md` (item 3.4b — the Featured repair)
Date: 2026-08-30

> **Reused, not re-derived.** Every skeleton below is carried across from
> `.agents/runs/library-bloc-preferences-20260827/code-plan.md`, which covered both halves
> of item 3.4 and marked these entries **3.4b's**. Additions this run are marked **NEW**
> inline. `task-brief.md` wins on any conflict.

## CREATE NEW

### lib/features/featured/domain/entities/now_playing_game_entity.dart
*Carried verbatim.*
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
No int identifier of any kind — that is the point (3.4-AC31, `tdd.md` D-A).

---

## MODIFY EXISTING

### lib/features/featured/domain/entities/library_snapshot_entity.dart
*Carried.*
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
The `core/domain/entities/tracker_saved_game_entity.dart` import is replaced by the new
entity's.

### lib/features/featured/data/datasources/featured_local_datasource.dart
*Carried.*
```dart
// Removed: countSavedGames, getOwnedGameIds, getWishlistedGames,
// getNowPlayingGames — all four filtered on Isar fields nothing writes.
// Kept unchanged: getThisWeekPlayHours, saveGenrePreferences,
// getSavedGenrePreferences, getSavedGames, _getDb.
```
**NEW —** every import stays. `isar_community` is still used by `_getDb`'s return type and
by `getThisWeekPlayHours`'s `playSessionLogs` query; `saved_game.dart` by `getSavedGames()`'s
`List<SavedGame?>` return type; `play_session_log.dart` and `shared_preferences` are
untouched. Removing one is an error, not a tidy-up. No `SavedGame` field is removed
(3.4-AC32).

### lib/features/featured/data/repositories/featured_repository_impl.dart
*Carried.*
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
`getCountdownGame` (`:63`) and `getOutThisWeekGames` (`:131`) replace their
`_localDatasource.getWishlistedGames()` blocks — the fetch **and** the
`.map(...).where(...).cast<int>().toSet()` that follows each one — with a single
`await _wishlistIds()`. Everything else in both methods, and all of
`getCriticsChoiceGames`, `saveGenrePreferences` and `getGenrePreferences`, is unchanged.
`_countdownFrom` keeps its comment and its logic: the ids are IGDB ids and still match
`GameEntity.id` (3.4-AC27).

`_libraryRepository` is the domain interface. Injectable resolves it from
`LibraryRepositoryImpl`'s `@Injectable(as: LibraryRepository)`.

### lib/features/featured/presentation/widgets/library_stats.dart
*Carried, with the **NEW** `onMarkNowPlaying` parameter (`tdd.md` D-K).*
```dart
class _NowPlayingCard extends StatelessWidget {
  const _NowPlayingCard({
    required this.playingGames,
    required this.onMarkNowPlaying,
  });

  final List<NowPlayingGameEntity> playingGames;
  final VoidCallback onMarkNowPlaying;

  @override
  Widget build(BuildContext context) {
    if (playingGames.isEmpty) {
      return EmptyStateCard(
        // unchanged, onActionPressed: onMarkNowPlaying
      );
    }

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
              topGame.coverUrl != null
                  ? DefaultCachedNetworkImage(imageUrl: topGame.coverUrl!)
                  : /* unchanged fallback container */,
        // ...
              Text(topGame.title, maxLines: 2, ...),
  }
}
```
and the call site inside `_buildLibraryStats`, replacing `:262`:
```dart
        _NowPlayingCard(
          playingGames: playingGames,
          onMarkNowPlaying: onMarkNowPlaying,
        ),
```
`_buildNowPlayingCard` becomes this `StatelessWidget` (D17.2) — a method cannot be `const`
and rebuilds with its parent. `topGame.imageUrl` becomes `topGame.coverUrl`; the
`name ?? StringConstants.emptyStringPlaceholder` fallback at `:345` goes because `title` is
non-nullable. The `TrackerGameDetailRoute` push and the
`config/route/auto_route_config.gr.dart` and `tracker_saved_game_entity.dart` imports are
removed. The `extraCount` badge, the `Active` pill and all three progress branches are
structurally unchanged. **No comments**, and the pre-existing `/// TODO: Refactor this
widget` at `:13` stays.

---

## TEST FILES

### test/repository/featured/featured_repository_test.dart (modify)
*Carried, with the **NEW** harness note.*
- both existing countdown tests restubbed onto `LibraryRepository.fetchAllEntries`
- `'should return a non-empty now-playing list when library entries are playing'` (3.4-AC35)
- `'should return a successful snapshot with zeroes when the library read fails'` (3.4-AC33)
- `'should count owned ids across every status'` (3.4-AC28)

**NEW —** `@GenerateMocks([FeaturedLocalDatasource, FeaturedApiService, LibraryRepository])`,
the mock passed as the third constructor argument, and a `provideDummy` in `setUp` for
`Result<List<LibraryEntryEntity>>` and `Result<LibraryCountsEntity>` alongside the existing
`Result<CountdownGameEntity>` one (`testing-conventions.md`). `GetIt.instance.reset()` in
`tearDown` stays.

### test/features/featured/presentation/blocs/library_stats_cubit_test.dart (modify)
*Carried.*
The one `TrackerSavedGameEntity` at `:101` becomes a `NowPlayingGameEntity`, and the
`core/domain/entities/tracker_saved_game_entity.dart` import at `:10` swaps with it. No
other change; the assertions stand.

### test/widget/featured/library_stats_test.dart (create)
*Carried, with the **NEW** harness constraints.*
- `'shows the playing game title when a game is playing'` (3.4-AC35's second half — the
  card, not `EmptyStateCard`)
- `'shows the empty state card when nothing is playing'`

Two tests, no dimension or colour assertions, **no tap test** — the tap destination is
3.4-AC36's on-device manual check.

**NEW —** both supply a snapshot with `totalGamesCount >= 1`, or the widget renders the
checklist card instead of the stats (`tdd.md` D-L). Both pass `coverUrl: null` so the
fallback icon renders and no image state is manufactured. `await S.load(const Locale('en'))`
in `setUp` and a `MaterialApp` around the subject (`tdd.md ## Caveats` 1). For the empty
branch prefer `find.byType(EmptyStateCard)` over the headline text — the card renders its
headline in caps from a normal-case string (caveat 2).

### test/cubit/library/library_bloc_test.dart (modify) — **NEW this run**
One added `blocTest`, beside the existing next-page tests, reusing the file's `_entry`,
`_pageOf` and `_counts` helpers. Nothing already in the file is edited.

- `'sets the end-of-results flag when a full appended page reaches the matched count'`
  (3.4-AC44)

```dart
  blocTest<LibraryBloc, LibraryState>(
    'sets the end-of-results flag when a full appended page reaches the '
    'matched count',
    seed: () => LibraryState(
      status: LibraryLoadStatus.success,
      entries: _pageOf(LibraryConstants.pageSize),
      matchedCount: LibraryConstants.pageSize * 2,
      counts: _counts,
    ),
    setUp: () {
      when(
        fetchLibraryPageUseCase.call(
          sort: LibrarySort.recentlyAdded,
          limit: anyNamed('limit'),
          offset: LibraryConstants.pageSize,
        ),
      ).thenAnswer(
        (_) async => Success(
          LibraryPageEntity(
            entries: _pageOf(
              LibraryConstants.pageSize,
              startAt: LibraryConstants.pageSize,
            ),
            matchedCount: LibraryConstants.pageSize * 2,
          ),
        ),
      );
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const LibraryNextPageRequested()),
    verify: (bloc) => expect(bloc.state.hasReachedEnd, isTrue),
  );
```
The appended page is exactly `LibraryConstants.pageSize` long and the matched count is
exactly the sum, so the matched-count rule gives `true` and the withdrawn short-page rule
gives `false`. Reverting **only** `library_bloc.dart:188-189` to
`page.entries.length < LibraryConstants.pageSize` must make this fail. See `tdd.md` D-J and
caveat 3. Adding the import of `features/library/const.dart` is part of this edit.

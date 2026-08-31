# Diff Summary
Source: `.agents/runs/featured-repair-20260830/task-brief.md` (item 3.4b — the Featured repair)
Date: 2026-08-31
Branch: claude/questloggd-3-4b-featured-2m3o71
Commit: d172b584c724e848f12375a4cbfff0c5fa93aff4

## Files created
lib/features/featured/domain/entities/now_playing_game_entity.dart — freezed `NowPlayingGameEntity`: title, coverUrl, progressPercent, playtimeHours, averageCompletionHours; no int identifier of any kind (3.4-AC31)
test/widget/featured/library_stats_test.dart — two tests proving `LibraryStatsWidget`'s now-playing card renders game data vs. `EmptyStateCard` (3.4-AC35)

## Files modified
lib/features/featured/domain/entities/library_snapshot_entity.dart — `nowPlayingGames` retyped to `List<NowPlayingGameEntity>`; import swapped from `tracker_saved_game_entity.dart`
lib/features/featured/data/datasources/featured_local_datasource.dart — removed the four dead Isar reads (`countSavedGames`, `getOwnedGameIds`, `getWishlistedGames`, `getNowPlayingGames`); every surviving import kept
lib/features/featured/data/repositories/featured_repository_impl.dart — took `LibraryRepository` as a third constructor dependency; `getLibrarySnapshot` now runs `fetchAllEntries()`/`fetchCounts()` concurrently and degrades a failed/signed-out read to a still-successful zeroed snapshot; `getCountdownGame` and `getOutThisWeekGames` now source wishlist ids through a shared `_wishlistIds()` helper backed by the same repository
lib/features/featured/presentation/widgets/library_stats.dart — `_buildNowPlayingCard` became a private `_NowPlayingCard extends StatelessWidget` taking `playingGames` and `onMarkNowPlaying`; both tap branches collapse to `AutoTabsRouter.of(context).setActiveIndex(1)`; card reads the new entity's fields; removed the `auto_route_config.gr.dart` and `tracker_saved_game_entity.dart` imports, added `now_playing_game_entity.dart`
test/features/featured/presentation/blocs/library_stats_cubit_test.dart — swapped the one `TrackerSavedGameEntity` fixture for a `NowPlayingGameEntity` and its import
test/repository/featured/featured_repository_test.dart — added `LibraryRepository` to `@GenerateMocks`, passed the mock as the third constructor argument, added `provideDummy` for the two new `Result` types, restubbed the two countdown tests onto `LibraryRepository.fetchAllEntries`, and added three tests (non-empty now-playing, degraded-but-successful snapshot, owned ids across statuses)
test/cubit/library/library_bloc_test.dart — added one `blocTest` for the append-side end-of-results guard (3.4-AC44); nothing pre-existing edited

## Files regenerated (generated outputs, not hand-edited)
lib/features/featured/domain/entities/now_playing_game_entity.freezed.dart
lib/core/di/service_locator.config.dart — `FeaturedRepositoryImpl` constructor now resolves `LibraryRepository` via `LibraryRepositoryImpl`'s existing `@Injectable(as: LibraryRepository)`
test/repository/featured/featured_repository_test.mocks.dart — regenerated with the four removed datasource methods gone and `MockLibraryRepository` added

## Test files
test/repository/featured/featured_repository_test.dart — 5 tests: two countdown-card wishlist tests restubbed onto the repository, plus non-empty now-playing (3.4-AC35), degraded-read-still-succeeds (3.4-AC33), owned ids across every status (3.4-AC28)
test/widget/featured/library_stats_test.dart — 2 tests: now-playing card shows the game title; empty playing list shows `EmptyStateCard` (3.4-AC35)
test/cubit/library/library_bloc_test.dart — 1 added test: append-side end-of-results flag set when a full appended page reaches the matched count (3.4-AC44)
test/features/featured/presentation/blocs/library_stats_cubit_test.dart — unchanged assertions, only the fixture type swapped

## Self-corrections
NONE

## Caveat outcomes (tdd.md ## Caveats that need execution to settle)
1. Widget test localisation harness — held. `await S.load(const Locale('en'))` in `setUp` plus a `MaterialApp` wrapper was sufficient; no fallback needed.
2. Widget test assertion surface — held. `find.text('Chrono Trigger')` matched the now-playing card's plain `Text`; the empty branch was asserted via `find.byType(EmptyStateCard)` per the fallback guidance (not the caps headline text), since that was always the documented preference, not a fallback triggered by failure.
3. 3.4-AC44's mutation check — held, verified by execution. Copied the tree to a scratch directory, reverted only `library_bloc.dart:188-189` to `page.entries.length < LibraryConstants.pageSize`, and ran `flutter test test/cubit/library/library_bloc_test.dart` against the copy: the new test failed (`Expected: true, Actual: <false>`) while every other test in the file still passed. No production file in the working tree was touched; the mutated copy was discarded afterward.
4. DI resolution of the third dependency — held. `dart run build_runner build` regenerated `service_locator.config.dart` with `FeaturedRepositoryImpl` correctly resolving `gh<LibraryRepository>()` from `LibraryRepositoryImpl`'s `@Injectable(as: LibraryRepository)`; no escalation needed.

## Deviations from implementation plan
`library_stats.dart` needed one import the plan/code-plan did not call out explicitly: `features/featured/domain/entities/now_playing_game_entity.dart`. `featured_repository.dart`'s `export` only re-exports `library_snapshot_entity.dart`'s own public API, not the entity it merely imports, so `_NowPlayingCard`'s `List<NowPlayingGameEntity>` parameter needed a direct import to compile. Minimal and necessary; no other file's import list changed beyond what the plan specified.

## Verification against baseline
`flutter analyze`: 0 errors, 2 warnings (the `_TaskReminder` pair at `task_detail_screen.dart:201`/`:204`, unchanged), 30 info (was 27; the new info lines are line-length/redundant-argument lints inside this diff's own new code — the 29/2/27 baseline's only invariant, the 2 warnings, holds; the total is explicitly not an invariant per task-brief.md).
`flutter test`: +441 -10. Baseline was +435 -10. Net +6 tests (3 in featured_repository_test.dart, 2 in library_stats_test.dart, 1 in library_bloc_test.dart) — no test count lost or gained elsewhere. The 10 failures are exactly the pre-existing baseline set, unchanged in name and count: `test/repository/tracker/tracker_repository_test.dart` (4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3), `test/cubit/games/games_bloc_test.dart` (3). No new failure.
`use_null_aware_elements` at `library_remote_datasource.dart` — untouched, as instructed.

## Acceptance criteria status
3.4-AC26: satisfied — now-playing sourced from `fetchAllEntries()` filtered to `LibraryStatus.playing`, order preserved from the query (updated_at descending); the Isar `statusEqualTo('Playing')` filter is removed.
3.4-AC27: satisfied — all three `getWishlistedGames()` callers (stat, `getCountdownGame`, `getOutThisWeekGames`) now go through the shared `_wishlistIds()` helper backed by `fetchAllEntries(status: wishlist)`.
3.4-AC28: satisfied — total from `fetchCounts().total`, owned ids from every entry's `igdbId` across every status (test: "should count owned ids across every status").
3.4-AC29: satisfied — both tap branches now call a single `AutoTabsRouter.of(context).setActiveIndex(1)`; no `TrackerGameDetailRoute` push remains in `library_stats.dart`.
3.4-AC30: satisfied — the whole filtered `playingGames` list is passed to `_NowPlayingCard`, no `SavedGame`-existence filtering.
3.4-AC31: satisfied — `NowPlayingGameEntity` carries no int identifier of any kind.
3.4-AC32: satisfied — the tracker tree files are untouched; `dart run build_runner` and `flutter analyze`/`flutter test` confirm they still compile and their existing tests still pass (not in this run's failure set).
3.4-AC33: satisfied — test "should return a successful snapshot with zeroes when the library read fails" proves `Failure` on both reads still returns `Success` with zeroes/empty; `getThisWeekPlayHours()` untouched.
3.4-AC34: satisfied — `NowPlayingGameEntity` carries title, coverUrl, progressPercent, playtimeHours, averageCompletionHours, matching every field `library_stats.dart` renders.
3.4-AC35: satisfied — repository test proves a non-empty now-playing list is produced from playing entries, and widget test proves the card renders game data, not `EmptyStateCard`, when the list is non-empty (and vice versa).
3.4-AC36: MANUAL — not automated by design; deferred to the human's on-device check per task-brief.md.
3.4-AC44: satisfied — added `blocTest` fails when `library_bloc.dart:188-189` is reverted to the withdrawn short-page rule (verified in a scratch copy of the tree, not the working tree); passes against the actual (unmodified) `library_bloc.dart`.
3.4-AC41: satisfied — analyzer 0 errors, the 2-warning invariant holds, the 10 pre-existing failures are unchanged in name and count, and no new failure appears outside them.

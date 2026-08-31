# QA Report
Source: `.agents/runs/featured-repair-20260830/task-brief.md` (item 3.4b — the Featured repair)
Date: 2026-08-31

Overall result: PASS — pending manual checks

Dev commit verified: `d172b584c724e848f12375a4cbfff0c5fa93aff4` (base `f167a17`).

## Manual verification required

3.4-AC36 — Open Featured with exactly **one** game at status `playing`, tap the
now-playing card — expect the **Library** tab (index 1), not Browse and not the tracker
game-detail screen. Repeat with **several** playing games — expect the same Library tab
(the card shows "+N more playing"). Closes `3.2-MC-6`; index 1 has never executed in
either branch.

## Static analysis

Status: PASS
Errors: NONE

- `dart run build_runner build --delete-conflicting-outputs` — "wrote 0 outputs", so the
  committed generated files are current; no generated drift.
- `flutter analyze` — 32 issues: **0 errors, 2 warnings, 30 info**.
- The 2-warning invariant holds, unchanged: `unused_element _TaskReminder`
  (`task_detail_screen.dart:201`) and `unused_element_parameter task`
  (`task_detail_screen.dart:204`).
- Baseline was 29 (0/2/27). The +3 info are all inside this diff's own new code —
  `lines_longer_than_80_chars` and `avoid_redundant_argument_values` in
  `featured_repository_impl.dart`, `featured_repository_test.dart` and
  `library_stats_test.dart`. Total is not an invariant; no new warning, no new error.
- `use_null_aware_elements` in `library_remote_datasource.dart` — still present,
  untouched, human-approved survivor. Not a defect.

## Test results

Status: PASS
Tests run: 451  |  Passed: 441  |  Failed: 10

Failing tests are exactly the pre-existing baseline set, unchanged in name and count:
- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

Baseline was +435 -10; now +441 -10. The +6 are exactly the declared additions
(3 repository, 2 widget, 1 bloc). No new failure anywhere.

Run with `--coverage` per testing mode `coverage`; `coverage/lcov.info` is QA-induced
and git-ignored. Working tree is clean.

### Falsifiability — 3.4-AC44 mutation, verified independently

Method: `cp -a` of the whole tree to a scratch directory; the **copy** was mutated, the
working tree was never edited. In the copy, `library_bloc.dart:188-189` was reverted to
the withdrawn short-page rule:

```dart
hasReachedEnd: page.entries.length < LibraryConstants.pageSize,
```

`flutter test test/cubit/library/library_bloc_test.dart` against the mutant:
**+14 -1** — the one failure is
`sets the end-of-results flag when a full appended page reaches the matched count`
(`Expected: true / Actual: <false>`), and every other test in the file still passed. The
new test dies under exactly the mutation it was written to catch, and it is the only one
that does. Dev's claim is confirmed by execution, not accepted on report. Scratch copy
discarded.

## Coverage gaps (coverage mode only)

Minor, not gating: no assertion pins `wishlistCount` to `counts.byStatus[wishlist]` on
the **success** path — the degraded test asserts it is 0 on `Failure`, and the non-empty
test stubs the counts but asserts only the now-playing list and title. The wishlist stat
tile's source is nonetheless proven repointed (it reads `fetchCounts()`, and both id
callers are covered). Worth a line in a future run, not a criterion FAIL.

Every in-scope criterion otherwise has both a success case and a failure/empty case:
success (`should return a non-empty now-playing list…`, `shows the playing game title…`),
failure (`should return a successful snapshot with zeroes when the library read fails`),
empty (`shows the empty state card when nothing is playing`).

## Acceptance criteria

3.4-AC26: PASS — `featured_repository_impl.dart:66-69` filters
`entries.where((entry) => entry.status == LibraryStatus.playing)` off
`LibraryRepository.fetchAllEntries()`, whose datasource orders
`updated_at ascending: false` for the signed-in user
(`library_remote_datasource.dart:85-88`); the `.where` preserves that order. The Isar
`statusEqualTo('Playing')` filter is gone — `featured_local_datasource.dart` retains only
`getThisWeekPlayHours`, `saveGenrePreferences`, `getSavedGenrePreferences`,
`getSavedGames`, `_getDb`. Test: `should return a non-empty now-playing list when library
entries are playing`.

3.4-AC27: PASS — all three callers served off `library_entries`. `getCountdownGame`
(`:105`) and `getOutThisWeekGames` (`:167`) both call the shared `_wishlistIds()`
(`:88-99`, `fetchAllEntries(status: LibraryStatus.wishlist)` → `igdbId` set, `Failure`
degrading to `{}`); the wishlist stat tile reads `counts.byStatus[LibraryStatus.wishlist]`
(`:71`) from `fetchCounts()`, per `tdd.md ## Repositories`. No
`isWishlistedEqualTo(true)` filter survives anywhere. Tests: the two restubbed countdown
tests now stub `libraryRepository.fetchAllEntries(status: wishlist)`.

3.4-AC28: PASS — `totalGamesCount: counts?.total ?? 0` (`:65`) and
`ownedGameIds: entries.map((entry) => entry.igdbId).toSet()` (`:73`) across every status,
no Isar fallback. Consumers unedited and already correct:
`featured_screen.dart:161`/`:238` read `libraryState.snapshot?.ownedGameIds`;
`library_stats_cubit.dart:40-42` compute the three checklist steps from
`totalGamesCount` / `nowPlayingGames.isNotEmpty` / `wishlistCount`. Test: `should count
owned ids across every status` (asserts `{1, 2, 3}` from playing + backlog + wishlist).

3.4-AC29: PASS — `library_stats.dart:294` — the single tap handler is
`onTap: () => AutoTabsRouter.of(context).setActiveIndex(1)`, with no branch on
`playingGames.length`. No `TrackerGameDetailRoute` push remains, and both the
`auto_route_config.gr.dart` and `tracker_saved_game_entity.dart` imports are gone (D14).

3.4-AC30: PASS — `library_stats.dart:250-253` passes the whole filtered
`playingGames` list to `_NowPlayingCard`; `_NowPlayingCard` takes
`playingGames.first` for the card and `playingGames.length - 1` for the "+N more" badge.
No `SavedGame`-existence filtering anywhere on the path.

3.4-AC31: PASS — `now_playing_game_entity.dart:7-15` — `NowPlayingGameEntity` carries
`title`, `coverUrl`, `progressPercent`, `playtimeHours`, `averageCompletionHours` and no
int identifier of any kind, so no Isar key can be derived from a `library_entries` row.
The only surviving Isar reads on the Featured path are `playSessionLogs`
(`getThisWeekPlayHours`) and `getSavedGames()` for the genre derivation — neither keyed
on library data.

3.4-AC32: PASS — the tracker tree is untouched.
`git diff --name-only f167a17..d172b58` contains **no** tracker file.
`tracker_game_detail_screen.dart`, `task_detail_screen.dart`,
`presentation/cubits/task_cubit.dart`, `data/models/group_task.dart`,
`saved_game_task.dart` and `task_step.dart` are all present; `flutter analyze` reports 0
errors, so they compile; `tracker_cubit_test.dart`, `tracker_sort_repository_test.dart`
and `default_filter_list_app_bar_test.dart` all pass, and
`tracker_repository_test.dart`'s 4 failures are the unchanged pre-existing baseline. No
`SavedGame` field removed. The tree is now unreachable, which is D14's intent, not a
defect.

3.4-AC33: PASS — `featured_repository_impl.dart:53-62` pattern-matches both awaited
results and degrades `Failure` to `<LibraryEntryEntity>[]` / `null` counts, still
returning `Success(snapshot)`; `getThisWeekPlayHours()` stays on Isar and is awaited
independently (`:51`). Test: `should return a successful snapshot with zeroes when the
library read fails` — asserts `Success` with total 0, wishlist 0, empty now-playing,
empty owned ids.

3.4-AC34: PASS — `_nowPlaying` (`featured_repository_impl.dart:81-87`) maps `title`,
`coverUrl`, `progressPercent`, `playtimeHours`; the card consumes exactly those at
`library_stats.dart:277-292` — `progressPercent` drives the manual-progress branch and
`playtimeHours` the hours branch. `averageCompletionHours` is intentionally unsourced
(`library_entries` has no such column), which is the "known gap carried forward" in
`tech-ac.md` and is documented by the entity's one comment; the middle branch stays
unreachable as designed.

3.4-AC35: PASS — the non-empty state is genuinely produced and asserted, not just the
empty branch. Repository level: `should return a non-empty now-playing list when library
entries are playing` seeds a playing entry and a backlog entry and asserts
`nowPlayingGames` has length 1 with title `Game 1`. Widget level:
`test/widget/featured/library_stats_test.dart` — `shows the playing game title when a
game is playing` renders `LibraryStatsWidget` with one `NowPlayingGameEntity` and asserts
`find.text('Chrono Trigger')`, which only the card can produce; `shows the empty state
card when nothing is playing` asserts `find.byType(EmptyStateCard)`. Both clear D-L's
checklist gate (`totalGamesCount: 1`, `isChecklistDismissed: true`), so the stats branch
actually renders. The `GamesStatus.empty` trap is closed.

3.4-AC36: MANUAL — see "## Manual verification required" above. Not automatable; the run
is not failed for it.

3.4-AC44: PASS — `test/cubit/library/library_bloc_test.dart:515-546`, `sets the
end-of-results flag when a full appended page reaches the matched count`. Seeds
`entries: _pageOf(pageSize)` with `matchedCount: pageSize * 2`, stubs the next page at
exactly `pageSize` rows, dispatches `LibraryNextPageRequested`, asserts
`hasReachedEnd` is `true` — the D-J numbers, unsoftened. Verified by execution against a
mutated **copy** of the tree: reverting only `library_bloc.dart:188-189` to
`page.entries.length < LibraryConstants.pageSize` makes this test, and only this test,
fail. Nothing pre-existing in the file was edited or renumbered.

3.4-AC41 (binding, not re-cut): PASS — 0 analyzer errors, the 2-warning `_TaskReminder`
invariant intact, the ten pre-existing failures unchanged in name and count, no new
failure outside them.

## Architectural compliance

Status: PASS
FAILs: NONE
WARNINGs: NONE

- `tdd.md` — matched exactly. Third constructor dependency is the **domain interface**
  `LibraryRepository` (`featured_repository_impl.dart:23`), never `LibraryRepositoryImpl`
  and never a use case; DI resolves it in `service_locator.config.dart` off the existing
  `@Injectable(as: LibraryRepository)`. `FeaturedRepository`,
  `GetLibrarySnapshotUseCase`, `LibraryStatsCubit`, `featured_screen.dart` and
  `library_bloc.dart` production code are all unmodified, as designed. Field-by-field
  snapshot derivation matches `tdd.md ## Repositories` (`totalGamesCount ← counts.total`,
  `wishlistCount ← counts.byStatus[wishlist]`, `ownedGameIds ← every igdbId`).
- `flutter-repository` — keeps `with BaseRepositoryMixin implements FeaturedRepository`
  and `@Injectable(as: FeaturedRepository)`; every method still returns `Result<T>` and
  never throws. The hand-rolled try/catch is the file's pre-existing shape across all
  seven methods, not introduced here, and the task brief explicitly preserves it.
- `flutter-usecase` / domain — `NowPlayingGameEntity` is freezed, lives in
  `domain/entities/`, and imports only `freezed_annotation`. Shape is identical to
  `LibraryEntryEntity` / `LibraryCountsEntity` (`@freezed sealed class … with _$…`,
  `const factory`). No domain→data dependency. `library_stats.dart`'s direct import of
  the entity is the deviation approved by the human on 2026-08-30 — recorded, not a
  finding.
- `flutter-datasource` — `FeaturedLocalDatasource` lost exactly the four dead reads and
  gained nothing; no wrapper, no generic reader, no new key. Every import survives and is
  still used (analyzer flags no unused import).
- `flutter-widgets` — `_buildNowPlayingCard` is now a private
  `_NowPlayingCard extends StatelessWidget` in the same file, not a `Widget`-returning
  method (human instruction). The file carries no comments; the pre-existing
  `/// TODO: Refactor this widget` at `:13` is left verbatim. `context.themeData`
  throughout, every string via `S`, no new dimension, no layout/colour change.
- `flutter-widget-test` — checked test-by-test against the review checklist. Names state
  condition and outcome (`shows the playing game title when a game is playing`,
  `shows the empty state card when nothing is playing`). Setup is the theme + `S.load`
  harness the widget genuinely needs and nothing more; `coverUrl: null` avoids
  manufactured image state. Assertions are observable outcomes (`find.text`,
  `find.byType(EmptyStateCard)` — a public shared component, not a private type). No
  dimension, radius, offset or position assertion; no completer, fake image bytes, manual
  builder invocation, arbitrary delay or swallowed error. No tap test — the tap
  destination is 3.4-AC36's manual check, correctly left out. At 83 lines against
  `stat_pill_test.dart`'s 51, the excess is entirely the localisation delegates and the
  ten required `LibraryStatsWidget` constructor arguments — a reason, not padding. Both
  tests would survive an implementation-only refactor and both fail if the behaviour
  regresses.

## Scope check

`git diff --name-only f167a17..d172b584` — every source file is on the allowlist:
`now_playing_game_entity.dart` (CREATE), `library_snapshot_entity.dart`,
`featured_local_datasource.dart`, `featured_repository_impl.dart`, `library_stats.dart`,
and the four allowlisted test files. Outside the allowlist there are only the three
declared generated outputs (`now_playing_game_entity.freezed.dart`,
`service_locator.config.dart`, `featured_repository_test.mocks.dart`) and this run
folder's own docs. Nothing appears in git that `diff-summary.md` did not declare, and
nothing declared is missing. `git status` is clean; the only working-tree change seen
during QA was `orchestrator-state.md`, since committed by the orchestrator as `703774d`
(docs only). No `pubspec.yaml` change. No tracker file, no `lib/features/library/**`
production file.

## Escalation required

NONE

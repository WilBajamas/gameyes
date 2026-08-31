# Task Brief
Source: `.agents/runs/featured-repair-20260830/tech-ac.md` (item 3.4b — the Featured repair)
Date: 2026-08-30

> **Design reused, not re-derived.** `tdd.md` and `code-plan.md` in this run folder carry
> the 3.4b-relevant design across from
> `.agents/runs/library-bloc-preferences-20260827/`, which covered both halves of item 3.4.
> `tdd.md ## What is carried and what is new` says which parts are which. Where this brief
> and either `tdd.md` or `code-plan.md` disagree, **this brief wins**.

## Context

Repair Featured's now-playing shelf, wishlist stat, total-games figure and owned-game ids
by repointing them off four Isar filters nothing has ever written and onto
`library_entries`, through the `LibraryRepository` interface 3.4a landed — and close the
one test gap 3.4a left on the bloc's end-of-results guard.

## Testing mode

**coverage** — Rule applied: *persistence*. The repaired source is the Supabase-persisted
`library_entries` read path, and the four Isar reads being retired are that path's
predecessor. The criteria set the same floor independently: 3.4-AC35 requires a repository
test **and** a widget test that prove the non-empty state the repair exists to produce,
and 3.4-AC44 requires a bloc test that fails under a named mutation. Smoke would satisfy
neither.

Widget test files (per `flutter-widget-test`, decided in `tdd.md ## UI layer`):
`LibraryStatsWidget` **gets** one — it owns the empty/non-empty conditional the repair
flips. `_NowPlayingCard` **does not** — private, no caller-reachable surface, same two
branches as its parent. No other widget in this diff renders.

## File allowlist

### CREATE NEW
lib/features/featured/domain/entities/now_playing_game_entity.dart — freezed `NowPlayingGameEntity`: what the now-playing card renders, with no int identifier of any kind (3.4-AC31)

### MODIFY EXISTING
lib/features/featured/domain/entities/library_snapshot_entity.dart — `nowPlayingGames` retyped to `List<NowPlayingGameEntity>`; the `tracker_saved_game_entity.dart` import swapped for the new entity's. Nothing else changes
lib/features/featured/data/datasources/featured_local_datasource.dart — remove `countSavedGames`, `getOwnedGameIds`, `getWishlistedGames`, `getNowPlayingGames`. **Remove nothing else and no import** — every existing import is still used by the surviving methods
lib/features/featured/data/repositories/featured_repository_impl.dart — take `LibraryRepository` as a third constructor dependency; serve `getLibrarySnapshot` from `fetchAllEntries()` + `fetchCounts()`; serve `getCountdownGame` (`:63`) and `getOutThisWeekGames` (`:131`) wishlist ids from `fetchAllEntries(status: wishlist)`
lib/features/featured/presentation/widgets/library_stats.dart — `_buildNowPlayingCard` becomes a private `_NowPlayingCard extends StatelessWidget`; both tap branches collapse to `setActiveIndex(1)`; the card reads the new entity's fields; two imports removed

### TEST FILES
test/widget/featured/library_stats_test.dart — NEW: the now-playing card renders the playing game, and `EmptyStateCard` when nothing is playing (3.4-AC35)
test/repository/featured/featured_repository_test.dart — MODIFY: restub the two countdown tests onto `LibraryRepository.fetchAllEntries`; add the non-empty now-playing snapshot (3.4-AC35), the degraded-but-successful snapshot (3.4-AC33), and owned ids across every status (3.4-AC28)
test/features/featured/presentation/blocs/library_stats_cubit_test.dart — MODIFY: the one `TrackerSavedGameEntity` at `:101` becomes a `NowPlayingGameEntity`, and its import at `:10` swaps with it. No other change; the assertions stand
test/cubit/library/library_bloc_test.dart — MODIFY: **add one `blocTest`** for the append-side end-of-results flag (3.4-AC44). Do not edit or renumber anything already in this file

### Deliberately NOT in the allowlist

- **The tracker tree (3.4-AC32).** `tracker_game_detail_screen.dart`,
  `task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep`,
  `TrackerSavedGameEntity`, every `SavedGame` field, and the `TrackerGameDetailRoute`
  registration at `lib/config/route/auto_route_config.dart:44`. D14 makes this tree
  unreachable and that is **intended**; "do not delete it" stands. Deleting, emptying or
  "tidying" any of it is an unauthorised scope change. Escalate rather than touch one.
- **`lib/features/featured/presentation/blocs/library_stats_cubit.dart` and
  `presentation/screens/featured_screen.dart`.** Both already read the snapshot's fields;
  repointing its source repairs them without an edit (3.4-AC28). If either looks like it
  needs a change, that is a signal the repository work is wrong — escalate.
- **`lib/features/featured/domain/repositories/featured_repository.dart` and
  `get_library_snapshot_use_case.dart`.** No signature moves.
- **`lib/features/library/**` production code.** 3.4a shipped it. `library_bloc.dart` in
  particular is **not** modified — 3.4-AC44 adds a test, not a behaviour change.
- **`test/features/featured/domain/use_cases/get_library_snapshot_use_case_test.dart`.**
  It builds a snapshot with `nowPlayingGames: []`, which still infers correctly after the
  retype. It is expected to keep compiling untouched; if it does not, escalate.
- **`pubspec.yaml`.** Read-only per `execution.md`, with no exception this run. 3.4a's
  `stream_transform` authorisation was for that run's one line and is spent. This half
  needs no package.

### Expected diff outside the allowlist, and allowed

Generated outputs only: `*.freezed.dart` for the new entity, `*.config.dart` for the
changed `FeaturedRepositoryImpl` constructor, and `test/repository/featured/featured_repository_test.mocks.dart`,
which regenerates with the four removed datasource methods gone and `MockLibraryRepository`
added. Do not hand-edit any of them.

## Implementation plan

Step 1: Create `lib/features/featured/domain/entities/now_playing_game_entity.dart` —
freezed, five fields per `code-plan.md`. One comment only, on `averageCompletionHours`,
saying nothing writes it yet.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 2: Modify `library_snapshot_entity.dart` — retype `nowPlayingGames`, swap the import.
The class stays a plain class; the constructor is unchanged.

Step 3: Modify `featured_local_datasource.dart` — delete the four dead Isar reads
(`:26-49`). **Delete nothing else.** Every import survives: `isar_community` is used by
`_getDb` and `getThisWeekPlayHours`, `saved_game.dart` by `getSavedGames()`'s return type.
No `SavedGame` field is touched (3.4-AC32).

Step 4: Modify `featured_repository_impl.dart` — add the `LibraryRepository` constructor
dependency (the **domain interface**, never the impl and never a use case), repoint
`getLibrarySnapshot`, and add the private wishlist-ids helper both `getCountdownGame` and
`getOutThisWeekGames` call. Three things this step must get right:

- **A failed or signed-out library read still returns `Success`** with an empty list and
  zeroes (3.4-AC33). `getThisWeekPlayHours()` stays on Isar and is unaffected.
- **All three `getWishlistedGames()` callers are served** by the repointed source — the
  stat (`:39`), the countdown ids (`:63`) and the out-this-week ordering (`:131`)
  (3.4-AC27). Leaving any of the three behind is the failure case the criterion names.
- **The parallel-call idiom carries the plain-English comment** D17.3 asks for, where
  `entriesCall` and `countsCall` are assigned before either is awaited — one or two lines,
  no jargon, saying that assigning both before awaiting starts them together and that
  awaiting each in turn would make one wait for the other.

`getCriticsChoiceGames`, `saveGenrePreferences` and `getGenrePreferences` are unchanged.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs` (DI)

Step 5: Modify `library_stats.dart` — the four changes in `tdd.md ## UI layer`, and nothing
else. **No comments anywhere in this file**, and leave the pre-existing
`/// TODO: Refactor this widget` at `:13` exactly as it is. No layout, colour, spacing or
dimension changes. Remove both now-unused imports (`auto_route_config.gr.dart`,
`tracker_saved_game_entity.dart`); leaving either behind is a new lint.

Step 6: Modify `test/features/featured/presentation/blocs/library_stats_cubit_test.dart` —
swap the one entity at `:101` and its import at `:10`. Nothing else.

Step 7: Modify `test/repository/featured/featured_repository_test.dart` — add
`LibraryRepository` to `@GenerateMocks`, pass the mock as the third constructor argument,
add a `provideDummy` for each `Future<Result<T>>` the new mock returns
(`testing-conventions.md`), restub the two existing countdown tests, and add the three new
tests named in `code-plan.md`.

Step 8: Create `test/widget/featured/library_stats_test.dart` — two tests. Read
`test/widget/components/stat_pill_test.dart` first for the shape. Both tests supply a
snapshot with `totalGamesCount >= 1`, or the widget renders the checklist card instead of
the stats (`tdd.md` D-L). Pass `coverUrl: null` — no image bytes, no manufactured image
states. No dimension, colour or spacing assertion, and **no tap test**: the tap
destination is 3.4-AC36's on-device manual check. See `tdd.md ## Caveats` 1 and 2.

Step 9: Modify `test/cubit/library/library_bloc_test.dart` — **add one `blocTest`** for
3.4-AC44, beside the existing next-page tests, reusing the file's `_entry`, `_pageOf` and
`_counts` helpers. The seeded numbers are in `tdd.md` D-J and are what make the test fail
under the mutation; do not soften them. Change nothing already in the file.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs` (mocks)

Step 10: Run `flutter analyze` and `flutter test`. Compare against `orchestrator-state.md`
verbatim: **Analyzer baseline: 0 errors, 2 warnings, 27 info (29 issues)** and **Test
baseline: +435 -10**, with pre-existing failures
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). The **2 warnings** are the invariant — the
deliberate `_TaskReminder` pair at `task_detail_screen.dart:201` and `:204`. The **29 total
is not an invariant** and will move as this half adds and removes files; a changed total on
its own proves nothing. The `use_null_aware_elements` info lint in
`library_remote_datasource.dart` is human-approved — **do not fix it.**

> 10 non-generation steps, well inside the 20-step ceiling. `escalation.md` stays closed.

## Acceptance criteria source

Canonical: `.agents/runs/featured-repair-20260830/tech-ac.md ## Technical acceptance
criteria`.

**IDs in scope: 3.4-AC26 through 3.4-AC36, and 3.4-AC44.** 3.4-AC41 (analyzer: 0 errors,
the 2-warning invariant, the ten pre-existing failures unchanged in name and count) binds
both halves of item 3.4 and is checked here against this run's diff and Phase 0 baseline —
read its text from `.agents/runs/library-bloc-preferences-20260827/tech-ac.md:354`, it is
not re-cut here.

3.4-AC36 is a **manual** criterion — on device, tapping the now-playing card opens the
Library tab, with one playing game and with several. It closes `3.2-MC-6`
(`manual-check-backlog.md:548-553`). It is not automatable and QA must not fail the run for
the absence of a test covering it.

Note for QA: **3.4-AC1–AC25 and AC37–AC40 are 3.4a's and are closed.** Do not re-check them
here. New info-level lints arising from the orphaned tracker route registration are
expected and are not breakage.

## Constraints

- **`flutter-repository`** — `FeaturedRepositoryImpl` keeps `BaseRepositoryMixin` and its
  existing method shapes; the new dependency is the **domain interface**
  `LibraryRepository`, never `LibraryRepositoryImpl` and never a use case. A repository
  calling a use case inverts the layering.
- **`flutter-usecase`** — no use case is created or modified. Entities are freezed and live
  in `domain/entities/`.
- **`flutter-datasource`** — `FeaturedLocalDatasource` loses four methods and gains
  nothing. Do not introduce a wrapper, a generic reader, or a new key.
- **`flutter-widgets`** — extracted UI is a widget class, never a `Widget`-returning
  method. **Widget files carry no comments at all.** `context.themeData`, never
  `Theme.of(context)`. No hardcoded user-facing string — every string this card renders
  already has an `S` key, so **no `.arb` edit and no localisation regeneration is needed
  this run**. No new dimension is introduced.
- **`flutter-widget-test`** — behaviour, not structure. No dimension, radius, offset or
  position assertion. No completers, no fake image bytes, no manual invocation of internal
  builders, no arbitrary delays. Keep the file no longer than
  `test/widget/components/stat_pill_test.dart` without a reason.
- **`testing-conventions.md`** — layer-based test paths, `@GenerateMocks` on the direct
  dependency only, `provideDummy` for every `Future<Result<T>>`, `GetIt.instance.reset()`
  in `tearDown`. **Never a golden test**, whatever a criterion says about appearance.
- **`generation.md`** — generated files are never hand-written. An annotated file that does
  not analyze clean before its generator has run is expected state, not a failure, and
  never counts against the self-correction budget.
- **`execution.md`** — comments are plain English, explain the why, and are few. Nothing
  outside the allowlist. Preserve unrelated pre-existing changes.
- **D14** — **every** now-playing tap goes to the Library tab via `setActiveIndex(1)`,
  whether one game is playing or many. No `TrackerGameDetailRoute` push survives in
  `library_stats.dart`. This is closed and not re-openable at any gate.
- **D15** — `countSavedGames()` and `getOwnedGameIds()` repoint at `library_entries`, so
  one stat row stops reading two stores. Closed.
- **Human instruction** — `_buildNowPlayingCard` becomes a `StatelessWidget`, not a helper
  method returning a `Widget`. Closed.
- **3.4-AC30** — the **whole** playing slice goes to the card, never a subset filtered by
  whether a matching local `SavedGame` exists. Filtering fixes the bug by half, for exactly
  the users this repair is for.
- **3.4-AC31** — no value on the now-playing seam is used as an Isar key, and the seam
  carries no int identifier at all. This is why the entity is new rather than reused.
- **The two-warning invariant** — the `_TaskReminder` pair must survive. The
  `use_null_aware_elements` info lint at `library_remote_datasource.dart` is
  human-approved: **do not "fix" it.**

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass, and do not weaken 3.4-AC44's seeded numbers to make its test pass — if the mutation
check does not behave as `tdd.md` D-J predicts, follow caveat 3's fallback and record it.

Do not touch files outside the allowlist — escalate instead. In particular: a tracker file
is not a near-miss, `pubspec.yaml` is closed this run, and
`lib/features/library/**` production code is 3.4a's and is finished.

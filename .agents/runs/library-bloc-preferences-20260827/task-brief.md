# Task Brief
Source: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (item 3.4)
Date: 2026-08-28

## Context

Ship the Library's state layer and the two data capabilities Stage 4 cannot be built
without (server-side counts, a search predicate), move view-mode and sort persistence
onto the renamed shared preferences datasource, and repair Featured's never-rendering
now-playing shelf and wishlist stat by repointing them at `library_entries`.

## Testing mode

**coverage** — Rule applied: *persistence*. View mode and sort persist to
`SharedPreferences` and a rename touches the existing `tracker_sort_tag` key, which is
the one failure in this item that silently destroys user data. Counts and search also
land as new data-layer behaviour with no regression guard today.

## File allowlist

### CREATE NEW
lib/core/enums/library_view_mode.dart — `LibraryViewMode { grid, list }`
lib/core/data/datasource/app_preferences_datasource.dart — shared `SharedPreferences` reads/writes for the tracker sort tag and the two new library keys
lib/features/library/domain/entities/library_counts_entity.dart — per-status counts plus the library total
lib/features/library/domain/entities/library_page_entity.dart — a page of entries plus the matched-row count
lib/features/library/domain/repositories/library_preferences_repository.dart — non-throwing view-mode and sort persistence contract
lib/features/library/data/repositories/library_preferences_repository_impl.dart — implements it over `AppPreferencesDatasource`
lib/features/library/domain/use_cases/fetch_library_counts_use_case.dart — forwards `fetchCounts`
lib/features/library/domain/use_cases/get_library_preferences_use_case.dart — reads stored view mode and sort
lib/features/library/domain/use_cases/save_library_view_mode_use_case.dart — persists the view mode
lib/features/library/domain/use_cases/save_library_sort_use_case.dart — persists the sort
lib/features/library/presentation/blocs/library_state.dart — `LibraryState` plus its two status enums
lib/features/library/presentation/blocs/library_bloc.dart — `LibraryBloc`
lib/features/library/presentation/blocs/library_event.dart — `part of library_bloc.dart`; the sealed event tree
lib/features/featured/domain/entities/now_playing_game_entity.dart — the retyped now-playing seam

### MODIFY EXISTING
lib/core/res/const.dart — two new `StorageConstants` keys for the library view mode and sort
lib/features/library/const.dart — page size and search debounce constants
lib/features/library/data/datasources/library_remote_datasource.dart — search predicate and matched count on `fetchPage`; new `fetchCounts` and `fetchAllEntries`
lib/features/library/domain/repositories/library_repository.dart — `fetchPage` signature and return type; two new methods
lib/features/library/data/repositories/library_repository_impl.dart — mirrors the interface
lib/features/library/domain/use_cases/fetch_library_page_use_case.dart — `searchTerm` parameter and new return type
lib/features/tracker/data/repositories/tracker_sort_repository_impl.dart — holds `AppPreferencesDatasource`; key, default and semantics unchanged
lib/features/featured/domain/entities/library_snapshot_entity.dart — `nowPlayingGames` becomes `List<NowPlayingGameEntity>`
lib/features/featured/data/repositories/featured_repository_impl.dart — injects `LibraryRepository`; sources now-playing, wishlist, total and owned ids from it
lib/features/featured/data/datasources/featured_local_datasource.dart — remove the four dead Isar reads
lib/features/featured/presentation/widgets/library_stats.dart — single `setActiveIndex(1)` tap; reads the new entity
.agents/week-3-task-briefs.md — **lines 82–84 only**: replace the stale 30-issue analyzer preamble

### DELETE
lib/features/tracker/data/datasources/local/tracker_preferences_datasource.dart — replaced by the core datasource

### TEST FILES
test/repository/library/library_remote_datasource_test.dart — NEW: the requests the datasource builds (paged with/without status and term, each sort, non-zero offset, add payload, partial update, `clearRating`)
test/repository/library/library_preferences_repository_test.dart — NEW: defaults, round trip, unparseable value, swallowed write failure
test/repository/library/library_repository_test.dart — MODIFY: `fetchPage`'s new shape; counts and unpaged reads
test/use_case/library/fetch_library_page_use_case_test.dart — MODIFY: new signature and return type
test/use_case/library/fetch_library_counts_use_case_test.dart — NEW: success including zero counts, and the signed-out failure
test/cubit/library/library_bloc_test.dart — NEW: the bloc, in house `blocTest` style
test/repository/tracker/tracker_sort_repository_test.dart — MODIFY: mock the renamed datasource; assertions unchanged
test/repository/featured/featured_repository_test.dart — MODIFY: library-sourced wishlist ids; the now-playing repair produces a non-empty list
test/features/featured/presentation/blocs/library_stats_cubit_test.dart — MODIFY: build the snapshot with `NowPlayingGameEntity`
test/widget/featured/library_stats_test.dart — NEW: the card renders game data when a game is playing, rather than `EmptyStateCard`

## Implementation plan

Step 1: Create `lib/core/enums/library_view_mode.dart`.

Step 2: Modify `lib/core/res/const.dart` — add the two library preference keys to
`StorageConstants`, beside `trackerSortTagKey`. Do not change `trackerSortTagKey`.

Step 3: Modify `lib/features/library/const.dart` — add a `LibraryConstants` class with
the page size and the 300 ms search debounce. Leave `LibraryEntryConstants` alone.

Step 4: Create `lib/core/data/datasource/app_preferences_datasource.dart` with the three
read/write pairs, and delete
`lib/features/tracker/data/datasources/local/tracker_preferences_datasource.dart`. The
tracker pair keeps its key, its default and its swallowed-failure behaviour exactly.

Step 5: Modify `lib/features/tracker/data/repositories/tracker_sort_repository_impl.dart`
— change the datasource type and import only. `TrackerSortRepository`, `TrackerCubit`,
`GetTrackerSortUseCase` and `SaveTrackerSortUseCase` are **not** renamed or edited.

Step 6: Create `library_preferences_repository.dart` and
`library_preferences_repository_impl.dart`. Both members are synchronous on the read side
and contractually non-throwing; document that on the interface as `TrackerSortRepository`
does.

Step 7: Create `library_counts_entity.dart` and `library_page_entity.dart`.

Step 8: Create `lib/features/featured/domain/entities/now_playing_game_entity.dart`, and
modify `library_snapshot_entity.dart` to hold `List<NowPlayingGameEntity>`.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 9: Modify `library_remote_datasource.dart` — add the escaped `ilike` search filter
and the count modifier to `fetchPage`, and add `fetchCounts` (six concurrent head counts)
and `fetchAllEntries` (unpaged, `updated_at` descending). Do not touch `_currentUserId`,
`_sortColumn`, or the `clearRating` pair — the `use_null_aware_elements` lint at line 101
is human-approved and stays.

Step 10: Modify `library_repository.dart` and `library_repository_impl.dart` — the new
`fetchPage` shape plus `fetchCounts` and `fetchAllEntries`, all through
`BaseRepositoryMixin`.

Step 11: Modify `fetch_library_page_use_case.dart` and create
`fetch_library_counts_use_case.dart`.

Step 12: Create the three preference use cases.

Step 13: Create `library_state.dart` — the two status enums and the freezed state.

Step 14: Create `library_bloc.dart` and its `library_event.dart` part file. The
constructor registers handlers and calls nothing else.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 15: Modify `featured_local_datasource.dart` — remove `countSavedGames`,
`getOwnedGameIds`, `getWishlistedGames` and `getNowPlayingGames`. Leave
`getThisWeekPlayHours`, `getSavedGames` and the genre-preference pair.

Step 16: Modify `featured_repository_impl.dart` — inject `LibraryRepository`; source the
snapshot's now-playing list, wishlist count, total and owned ids from it, and the
wishlist ids in `getCountdownGame` and `getOutThisWeekGames` too. A failed or signed-out
library read must leave the snapshot a `Success` with empty/zero figures.

Step 17: Modify `library_stats.dart` — collapse the tap to a single
`setActiveIndex(1)`, drop the `TrackerGameDetailRoute` push and its now-unused
`auto_route_config.gr.dart` import, and read the new entity's fields. Keep all three
progress branches. Add no comments.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 18: Modify `.agents/week-3-task-briefs.md` lines 82–84 only — replace the fixed
30-issue claim with the mechanism: the two `_TaskReminder` warnings are the invariant,
the total is not and has moved three times this week, so verify both on the untouched
tree at Phase 0. Change nothing else in that file.

Step 19: Create `test/repository/library/library_remote_datasource_test.dart`. See
`tdd.md ## Caveats` for the harness: a loopback `dart:io` `HttpServer`, a real
`SupabaseClient` pointed at it, and `auth.setInitialSession`. Do not add a package; if
the harness cannot be made to work inside the budget, escalate.

Step 20: Create `test/repository/library/library_preferences_repository_test.dart`.

Step 21: Modify `test/repository/library/library_repository_test.dart` and
`test/use_case/library/fetch_library_page_use_case_test.dart`; create
`test/use_case/library/fetch_library_counts_use_case_test.dart`.

Step 22: Modify `test/repository/tracker/tracker_sort_repository_test.dart` — swap the
mocked datasource type. The assertions themselves must not change: they are what proves
the rename did not move the key.

Step 23: Create `test/cubit/library/library_bloc_test.dart`, covering at minimum the nine
behaviours 3.4-AC39 lists, plus a plain `test()` that constructing the bloc calls no use
case and leaves the declared initial state.

Step 24: Modify `test/repository/featured/featured_repository_test.dart` and
`test/features/featured/presentation/blocs/library_stats_cubit_test.dart`.

Step 25: Create `test/widget/featured/library_stats_test.dart`.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs` (mocks)

Step 26: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md` verbatim: **Analyzer baseline: 0 errors, 2 warnings, 27 info (29
total)** and **Test baseline: +394 -10**, with pre-existing failures
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). The **2 warnings** are the invariant; the
total is not, and this item adds files so it will move. New info lints from the orphaned
tracker route registration are expected and are not breakage.

> This plan is **26 non-generation steps against the 20-step ceiling**. `escalation.md`
> is open. Do not start Dev work until the orchestrator resolves it.

## Acceptance criteria source

Canonical: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md ## Technical
acceptance criteria`
IDs in scope: 3.4-AC1 through 3.4-AC41 (3.4-AC36 is a manual check, verified on device,
not by code).

## Constraints

- **`flutter-state`** — freezed `sealed` state with one `const factory`, status by
  feature-specific enum never a boolean, errors as `ErrorType?`, handlers registered in
  the constructor with `bloc_concurrency` transformers, `Result` unwrapped by an
  exhaustive `switch` **expression** with no `default:`. `status` and `nextPageStatus`
  stay separate enums. Events are a `part` file of the bloc.
- **`flutter-usecase`** — one public `call(...)` per use case; use cases take the
  repository **interface**. The preference use cases return synchronously and outside
  `Result`, matching the documented `GetTrackerSortUseCase` deviation — see
  `tdd.md` D-C.
- **`flutter-repository`** — `abstract interface class` with no prefix or suffix,
  `@Injectable(as: ...)` on the impl, every data-layer method through
  `BaseRepositoryMixin.fetchData`, never a hand-rolled try/catch and never a manually
  built `ErrorType`. The two preference repositories are the sanctioned exception to the
  `Result` rule, not to the mixin rule (they touch no network).
- **`flutter-datasource`** — never call `SharedPreferences.getInstance()`; keys go in
  `StorageConstants`, never inline; do not write a generic wrapper around
  `SharedPreferences`.
- **`flutter-widget-test`** — the one new widget test asserts what the card shows, not
  how it is laid out. No dimension, colour, padding or radius assertions; no manufactured
  image bytes; no manually invoked builders. Keep it near the length of
  `test/widget/components/stat_pill_test.dart`.
- **`testing-conventions.md`** — layer-based test paths, `@GenerateMocks` on the direct
  dependency only, `provideDummy` for every `Future<Result<T>>`, `GetIt.instance.reset()`
  in `tearDown`. **Never a golden test.**
- **`execution.md`** — comments are plain English, explain the why, and are few; widget
  files carry **none**. Constants live near their scope. Nothing outside the allowlist.
- **D14/D15/D9/D10/D12** — every now-playing tap goes to the Library tab and the tracker
  tree stays in the repo compiling and passing; `countSavedGames()` and
  `getOwnedGameIds()` repoint at `library_entries`; one status vocabulary with no
  wishlist boolean; the rating input is item 4.6's; Supabase is the source of truth and
  the Isar cache, IGDB refresh and task-tree backup are later items.
- **The two-warning invariant** — the deliberate `_TaskReminder` pair at
  `task_detail_screen.dart:201` and `:204` must survive. The
  `use_null_aware_elements` info lint at `library_remote_datasource.dart:101` is
  human-approved: **do not "fix" it.**

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` — in particular `http`, `rxdart` and
`stream_transform` are all off-limits, and the design needs none of them. Do not touch
files outside the allowlist — escalate instead.

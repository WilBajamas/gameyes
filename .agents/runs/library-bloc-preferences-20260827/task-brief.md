# Task Brief
Source: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (item 3.4)
Scope: **item 3.4a only** — split from 3.4 at the Featured seam by D16
(`orchestrator-state.md ## Human decisions`). The Featured repair is **3.4b**, a separate
later run.
Date: 2026-08-28 (re-cut for the split)

## Context

Ship the Library's state layer and the two data capabilities Stage 4 cannot be built
without (server-side counts, a search predicate), and move view-mode and sort persistence
onto the renamed shared preferences datasource.

Featured's never-rendering now-playing shelf and wishlist stat are **not** repaired in
this run. They are 3.4b's, which depends one way on what this run lands (see
`## What 3.4b inherits`).

## Testing mode

**coverage** — Rule applied: *persistence*. Unchanged by the split: the persistence work
is entirely in this half. View mode and sort persist to `SharedPreferences` and a rename
touches the existing `tracker_sort_tag` key, which is the one failure in this item that
silently destroys user data. Counts and search also land as new data-layer behaviour with
no regression guard today.

No widget or screen is in this half's allowlist, so no widget test file is created here.
`LibraryStatsWidget`'s dedicated test file (`tdd.md ## UI layer`) belongs to 3.4b.

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

### MODIFY EXISTING
lib/core/res/const.dart — two new `StorageConstants` keys for the library view mode and sort
lib/features/library/const.dart — page size and search debounce constants
lib/features/library/data/datasources/library_remote_datasource.dart — search predicate and matched count on `fetchPage`; new `fetchCounts` and `fetchAllEntries`
lib/features/library/domain/repositories/library_repository.dart — `fetchPage` signature and return type; two new methods
lib/features/library/data/repositories/library_repository_impl.dart — mirrors the interface
lib/features/library/domain/use_cases/fetch_library_page_use_case.dart — `searchTerm` parameter and new return type
lib/features/tracker/data/repositories/tracker_sort_repository_impl.dart — holds `AppPreferencesDatasource`; key, default and semantics unchanged
.agents/week-3-task-briefs.md — **two edits only**: lines 82–84 (the stale 30-issue analyzer preamble) and the `- [ ] **3.4 …**` checklist entry (line 240 on the untouched tree). See steps 14a/14b.

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

### Deliberately NOT in this half's allowlist
Everything Featured-side moved to 3.4b and must not be touched here:
`now_playing_game_entity.dart` (create), `library_snapshot_entity.dart`,
`featured_repository_impl.dart`, `featured_local_datasource.dart`, `library_stats.dart`,
`test/repository/featured/featured_repository_test.dart`,
`test/features/featured/presentation/blocs/library_stats_cubit_test.dart`,
`test/widget/featured/library_stats_test.dart`.

**Where the old step 8 went.** The pre-split plan's step 8 (create `NowPlayingGameEntity`,
retype `LibrarySnapshotEntity.nowPlayingGames`) was listed under both halves. It belongs
to **3.4b**: it serves 3.4-AC31, which is inside 3.4b's AC26–AC36 range, and nothing in
this half reads or produces the now-playing seam. It is out of scope here, and the two
files stay exactly as item 3.3 left them for the whole of this run.

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

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 8: Modify `library_remote_datasource.dart` — add the escaped `ilike` search filter
and the count modifier to `fetchPage`, and add `fetchCounts` (six concurrent head counts)
and `fetchAllEntries` (unpaged, `updated_at` descending). Do not touch `_currentUserId`,
`_sortColumn`, or the `clearRating` pair — the `use_null_aware_elements` lint at line 101
is human-approved and stays.

Step 9: Modify `library_repository.dart` and `library_repository_impl.dart` — the new
`fetchPage` shape plus `fetchCounts` and `fetchAllEntries`, all through
`BaseRepositoryMixin`.

Step 10: Modify `fetch_library_page_use_case.dart` and create
`fetch_library_counts_use_case.dart`.

Step 11: Create the three preference use cases.

Step 12: Create `library_state.dart` — the two status enums and the freezed state.

Step 13: Create `library_bloc.dart` and its `library_event.dart` part file. The
constructor registers handlers and calls nothing else.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 14: Two edits to `.agents/week-3-task-briefs.md`, and nothing else in that file:

- **14a — lines 82–84.** Replace the fixed 30-issue claim with the mechanism: the two
  `_TaskReminder` warnings are the invariant, the total is not and has moved three times
  this week, so verify both on the untouched tree at Phase 0.
- **14b — the `- [ ] **3.4 — \`LibraryBloc\`, preferences, and the Featured repair.**`
  checklist entry.** Split it into `- [ ] 3.4a` and `- [ ] 3.4b`, each with a one-line
  scope: **3.4a** — `LibraryBloc`, preferences, counts, search, datasource test; **3.4b** —
  the Featured repair (now-playing shelf, wishlist stat, total and owned ids repointed at
  `library_entries`). Keep the existing sub-bullets, moving the "Featured repair lands
  here" bullet under 3.4b and the rest under 3.4a. Note the split is D16 and that 3.4a
  lands first.

Step 15: Create `test/repository/library/library_remote_datasource_test.dart`. See
`tdd.md ## Caveats` for the harness: a loopback `dart:io` `HttpServer`, a real
`SupabaseClient` pointed at it, and `auth.setInitialSession`. Do not add a package; if
the harness cannot be made to work inside the budget, escalate.

Step 16: Create `test/repository/library/library_preferences_repository_test.dart`.

Step 17: Modify `test/repository/library/library_repository_test.dart` and
`test/use_case/library/fetch_library_page_use_case_test.dart`; create
`test/use_case/library/fetch_library_counts_use_case_test.dart`.

Step 18: Modify `test/repository/tracker/tracker_sort_repository_test.dart` — swap the
mocked datasource type. The assertions themselves must not change: they are what proves
the rename did not move the key.

Step 19: Create `test/cubit/library/library_bloc_test.dart`, covering at minimum the nine
behaviours 3.4-AC39 lists, plus a plain `test()` that constructing the bloc calls no use
case and leaves the declared initial state.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs` (mocks)

Step 20: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md` verbatim: **Analyzer baseline: 0 errors, 2 warnings, 27 info (29
total)** and **Test baseline: +394 -10**, with pre-existing failures
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). The **2 warnings** are the invariant; the
total is not, and this half adds files and deletes one, so it will move. The orphaned
tracker route registration is **not** touched in this half — those expected info lints
arrive with 3.4b, not here.

> 20 non-generation steps, at the ceiling. `escalation.md` is closed for this run.

## Acceptance criteria source

Canonical: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md ## Technical
acceptance criteria` — **not re-cut; it stays whole at 41 criteria** and each half scopes
to its own range (D16).

**IDs in scope for 3.4a: 3.4-AC1 through 3.4-AC25, and 3.4-AC37 through 3.4-AC41.**

**3.4-AC26 through 3.4-AC36 are 3.4b's and are out of scope here.** They cover the
Featured repair, the `NowPlayingGameEntity` retype, the now-playing tap, the tracker-tree
guardrail (AC32), the Featured test (AC35) and the on-device manual check (AC36). **QA
must not fail this run for any of them** — no file that could satisfy them is in this
half's allowlist, and the Featured path is expected to still read Isar and still render
`EmptyStateCard` when this run ends. That is the correct end state for 3.4a.

3.4-AC41 (analyzer, 0 errors and the 2-warning invariant) is a constraint on both halves
and is checked here on this half's diff.

## What 3.4b inherits

Cut 3.4b's brief from the existing `tdd.md` and `code-plan.md` — both already cover both
halves. What 3.4b needs from this run, all landed by the steps above:

- **`LibraryRepository.fetchCounts()` → `Future<Result<LibraryCountsEntity>>`** (steps
  8–9). Serves the snapshot's `totalGamesCount` and `wishlistCount`.
- **`LibraryRepository.fetchAllEntries({LibraryStatus? status})` →
  `Future<Result<List<LibraryEntryEntity>>>`** (steps 8–9), unpaged, `updated_at`
  descending. One method serves all three Featured needs: playing rows, wishlist ids,
  every owned id.
- **`LibraryCountsEntity`** (step 7) — `byStatus` with all six keys present including
  zeros, plus `total`.
- **`BaseRepositoryMixin`'s `notSignedIn` mapping** on both new methods, which is what
  lets 3.4b degrade a failed or signed-out library read to empty/zero while still
  returning a `Success` snapshot (3.4-AC33).
- **`LibraryRepository` as a domain interface** for `FeaturedRepositoryImpl` to take as a
  third constructor dependency — 3.4b injects the interface, never the impl, and never a
  use case.

3.4b's own work, in `tdd.md` terms: D-A, the `FeaturedRepositoryImpl` and
`FeaturedLocalDatasource` entries under `## Data layer`, `NowPlayingGameEntity` and the
`LibrarySnapshotEntity` modify under `## Domain layer`, and the whole `## UI layer`
section including the widget-test scoping decision. Pre-split plan steps 8, 15–18, 24 and
25 — roughly nine steps, well inside the ceiling.

Nothing in this run depends on 3.4b. The dependency runs one way only.

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
- **`testing-conventions.md`** — layer-based test paths, `@GenerateMocks` on the direct
  dependency only, `provideDummy` for every `Future<Result<T>>`, `GetIt.instance.reset()`
  in `tearDown`. **Never a golden test.**
- **Regenerated mocks outside the allowlist are expected.** Changing `LibraryRepository`
  regenerates `.mocks.dart` for the add/update/remove library use-case tests, whose
  `.dart` sources are not allowlisted. The regeneration is fine; **do not hand-edit those
  test sources** — if one fails, that is a real signal, so escalate rather than adjust it.
- **`execution.md`** — comments are plain English, explain the why, and are few.
  Constants live near their scope. Nothing outside the allowlist.
- **D15/D9/D10/D12** — `countSavedGames()` and `getOwnedGameIds()` repoint at
  `library_entries` (that repointing itself is 3.4b's work, served by this half's
  `fetchCounts`/`fetchAllEntries`); one status vocabulary with no wishlist boolean; the
  rating input is item 4.6's; Supabase is the source of truth and the Isar cache, IGDB
  refresh and task-tree backup are later items.
- **D14** — binds 3.4b, not this half. No now-playing tap, route push or import changes
  here; `library_stats.dart` is untouched.
- **The two-warning invariant** — the deliberate `_TaskReminder` pair at
  `task_detail_screen.dart:201` and `:204` must survive. The
  `use_null_aware_elements` info lint at `library_remote_datasource.dart:101` is
  human-approved: **do not "fix" it.**

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` — in particular `http`, `rxdart` and
`stream_transform` are all off-limits, and the design needs none of them. Do not touch
files outside the allowlist — escalate instead. In particular, a Featured file is not a
near-miss: it is 3.4b's, so escalate rather than reaching for it.

# Task Brief
Source: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (item 3.4)
Scope: **item 3.4a only** — split from 3.4 at the Featured seam by D16
(`orchestrator-state.md ## Human decisions`). The Featured repair is **3.4b**, a separate
later run.
Date: 2026-08-28 (re-cut for the split; revised 2026-08-30 for D17)

> **D17 revision note.** The human's Phase 3 review found four real defects; seven
> revisions are recorded as D17. Four moved criteria — the BA has already applied those to
> `tech-ac.md` (see its `## Changelog`), which stays canonical. This brief, `tdd.md` and
> `code-plan.md` are corrected **in place**, because the allowlist and the step list both
> change. The summary of what moved is in `code-plan.md ## Approved feedback delta`.

## Context

Ship the Library's state layer and the two data capabilities Stage 4 cannot be built
without (server-side counts, a search predicate), and persist view mode and sort through a
**new library-owned** preferences datasource added beside the tracker's.

Featured's never-rendering now-playing shelf and wishlist stat are **not** repaired in
this run. They are 3.4b's, which depends one way on what this run lands (see
`## What 3.4b inherits`).

## Testing mode

**coverage** — Rule applied: *persistence*. View mode and sort persist to
`SharedPreferences`, and the counts and search capabilities land as new data-layer
behaviour with no regression guard today. (The pre-D17 justification cited the risk of
renaming the live `tracker_sort_tag` key. That rename is withdrawn — the tracker
datasource is not touched at all — but the rule still applies on the persistence the
Library itself adds.)

No widget or screen is in this half's allowlist, so no widget test file is created here.
`LibraryStatsWidget`'s dedicated test file (`tdd.md ## UI layer`) belongs to 3.4b.

## File allowlist

### CREATE NEW
lib/core/enums/library_view_mode.dart — `LibraryViewMode { grid, list }`
lib/core/utils/postgrest_utils.dart — public `postgrestLikePattern(String term)`, the PostgREST `ilike` escaping, beside `igdb_query_builder.dart`
lib/features/library/data/datasources/library_preferences_datasource.dart — library-only `SharedPreferences` reads/writes for the view mode and sort keys
lib/features/library/domain/entities/library_counts_entity.dart — per-status counts plus the library total
lib/features/library/domain/entities/library_page_entity.dart — a page of entries plus the matched-row count
lib/features/library/domain/repositories/library_preferences_repository.dart — non-throwing view-mode and sort persistence contract
lib/features/library/data/repositories/library_preferences_repository_impl.dart — implements it over `LibraryPreferencesDatasource`
lib/features/library/domain/use_cases/fetch_library_counts_use_case.dart — forwards `fetchCounts`
lib/features/library/domain/use_cases/get_library_preferences_use_case.dart — reads stored view mode and sort
lib/features/library/domain/use_cases/save_library_view_mode_use_case.dart — persists the view mode
lib/features/library/domain/use_cases/save_library_sort_use_case.dart — persists the sort
lib/features/library/presentation/blocs/library_state.dart — `LibraryState` plus its two status enums
lib/features/library/presentation/blocs/library_bloc.dart — `LibraryBloc`
lib/features/library/presentation/blocs/library_event.dart — `part of library_bloc.dart`; the sealed event tree

### MODIFY EXISTING
pubspec.yaml — **one line only**: declare `stream_transform: ^2.1.1` under `dependencies`. `pubspec.yaml` is read-only per `execution.md`; **D17.6 is an explicit human authorisation to make this single edit**, and no other. See step 1 and `tdd.md` D-H.
lib/core/res/const.dart — two new `StorageConstants` keys for the library view mode and sort
lib/features/library/const.dart — page size and search debounce constants
lib/features/library/data/datasources/library_remote_datasource.dart — search predicate (via `postgrestLikePattern`) and matched count on `fetchPage`; new `fetchCounts` and `fetchAllEntries`
lib/features/library/domain/repositories/library_repository.dart — `fetchPage` signature and return type; two new methods
lib/features/library/data/repositories/library_repository_impl.dart — mirrors the interface
lib/features/library/domain/use_cases/fetch_library_page_use_case.dart — `searchTerm` parameter and new return type
.agents/week-3-task-briefs.md — **two edits only**: lines 82–84 (the stale 30-issue analyzer preamble) and the `- [ ] **3.4 …**` checklist entry (line 240 on the untouched tree). See steps 15a/15b.

### TEST FILES
test/repository/library/library_remote_datasource_test.dart — NEW: the requests the datasource builds (paged with/without status and term, each sort, non-zero offset, escaped term, add payload, partial update, `clearRating`)
test/repository/library/library_preferences_repository_test.dart — NEW: defaults, round trip, unparseable value, swallowed write failure
test/repository/library/library_repository_test.dart — MODIFY: `fetchPage`'s new shape; counts and unpaged reads
test/use_case/library/fetch_library_page_use_case_test.dart — MODIFY: new signature and return type
test/use_case/library/fetch_library_counts_use_case_test.dart — NEW: success including zero counts, and the signed-out failure
test/cubit/library/library_bloc_test.dart — NEW: the bloc, in house `blocTest` style

### Expected diff outside the allowlist, and allowed
`pubspec.lock` — running `flutter pub get` after step 1 flips `stream_transform`'s
`dependency:` field from `transitive` to `direct main`. The version does not move (it is
already resolved at 2.1.1). That one-line change is expected; do not revert it and do not
escalate on it. Generated outputs (`*.freezed.dart`, `*.g.dart`, `*.config.dart`,
`*.mocks.dart`) are implicit as usual.

### Deliberately NOT in this half's allowlist

**The tracker preferences chain (D17.1, 3.4-AC22).** `TrackerPreferencesDatasource` is
**not** renamed, moved, extended, deleted or edited, and neither is anything above it:
`lib/features/tracker/data/datasources/local/tracker_preferences_datasource.dart`,
`lib/features/tracker/data/repositories/tracker_sort_repository_impl.dart`,
`tracker_sort_repository.dart`, `TrackerCubit`, `GetTrackerSortUseCase`,
`SaveTrackerSortUseCase` and `test/repository/tracker/tracker_sort_repository_test.dart`.
The `tracker_sort_tag` key keeps its exact name and semantics. A "while I'm here" edit to
any of these puts a live user-data key back in play — that is the whole point of the
revision. Escalate rather than touch one.

**Everything Featured-side**, which moved to 3.4b: `now_playing_game_entity.dart`
(create), `library_snapshot_entity.dart`, `featured_repository_impl.dart`,
`featured_local_datasource.dart`, `library_stats.dart`,
`test/repository/featured/featured_repository_test.dart`,
`test/features/featured/presentation/blocs/library_stats_cubit_test.dart`,
`test/widget/featured/library_stats_test.dart`.

**Where the old step 8 went.** The pre-split plan's step 8 (create `NowPlayingGameEntity`,
retype `LibrarySnapshotEntity.nowPlayingGames`) was listed under both halves. It belongs
to **3.4b**: it serves 3.4-AC31, which is inside 3.4b's AC26–AC36 range, and nothing in
this half reads or produces the now-playing seam. It is out of scope here, and the two
files stay exactly as item 3.3 left them for the whole of this run.

## Implementation plan

Step 1: Modify `pubspec.yaml` — add `stream_transform: ^2.1.1` under `dependencies`,
beside `bloc_concurrency`, with a one-line comment saying what it is for. **Leave
`bloc_concurrency` in place**: it provides `restartable()` and `droppable()`, which
`stream_transform` does not. Add nothing else. Run `flutter pub get`; `pubspec.lock`'s
`stream_transform` entry flips from `transitive` to `direct main` and no version moves.

Step 2: Create `lib/core/enums/library_view_mode.dart`.

Step 3: Modify `lib/core/res/const.dart` — add the two library preference keys to
`StorageConstants`, beside `trackerSortTagKey`. **Do not change `trackerSortTagKey`.**

Step 4: Modify `lib/features/library/const.dart` — add a `LibraryConstants` class with
the page size and the 300 ms search debounce. Leave `LibraryEntryConstants` alone.

Step 5: Create `lib/core/utils/postgrest_utils.dart` — a public top-level
`String postgrestLikePattern(String term)` that doubles `\`, then escapes `%` and `_`, and
wraps the result in `%…%`. One comment, on why the backslash has to be doubled first.

Step 6: Create
`lib/features/library/data/datasources/library_preferences_datasource.dart` — `@injectable`,
holds `SharedPreferences`, two read/write pairs (`readViewModeName`/`writeViewModeName`,
`readSortName`/`writeSortName`), each with the same swallow-on-failure try/catch
`TrackerPreferencesDatasource` uses. **Do not open, edit, move or delete the tracker
datasource** — copy the shape from it by reading, nothing more.

Step 7: Create `library_preferences_repository.dart` and
`library_preferences_repository_impl.dart`. Both members are synchronous on the read side
and contractually non-throwing; document that on the interface as `TrackerSortRepository`
does. The impl holds `LibraryPreferencesDatasource`.

Step 8: Create `library_counts_entity.dart` and `library_page_entity.dart`.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 9: Modify `library_remote_datasource.dart` — add the `ilike` search filter (pattern
from `postgrestLikePattern`, no private helper in this file) and the count modifier to
`fetchPage`, and add `fetchCounts` (six concurrent head counts) and `fetchAllEntries`
(unpaged, `updated_at` descending). Do not touch `_currentUserId`, `_sortColumn`, or the
`clearRating` pair — the `use_null_aware_elements` lint at line 101 is human-approved and
stays.

Step 10: Modify `library_repository.dart` and `library_repository_impl.dart` — the new
`fetchPage` shape plus `fetchCounts` and `fetchAllEntries`, all through
`BaseRepositoryMixin`.

Step 11: Modify `fetch_library_page_use_case.dart` and create
`fetch_library_counts_use_case.dart`.

Step 12: Create the three preference use cases.

Step 13: Create `library_state.dart` — the two status enums and the freezed state.

Step 14: Create `library_bloc.dart` and its `library_event.dart` part file. The
constructor registers handlers and calls nothing else. Four things this step must get
right, all from D17 (`tdd.md` D-D, D-G and `## State layer` are the detail):

- **The debounce is a named event transformer**, not an `await Future.delayed` in the
  handler: search events go through `stream_transform`'s `debounce()`, other query events
  pass straight through, the two are merged, and `restartable()` wraps the result.
- **The loading emit does not clear `entries`**, and it is reached only after the debounce
  has elapsed — a keystroke inside the window emits nothing at all (3.4-AC42).
- **`hasReachedEnd` is `loaded >= page.matchedCount`** in *both* handlers — never a page
  shorter than the page size (3.4-AC7).
- **A private `int _queryGeneration`** on the bloc, **not** a `LibraryState` field: bumped
  first thing in the query handler, captured by the next-page handler before its await and
  re-checked after; on a mismatch the next-page handler returns without emitting
  (3.4-AC43).

Also add the plain-English comment on the parallel-call idiom where `pageCall` and
`countsCall` are assigned before either is awaited (D17.3) — one or two lines, no jargon,
saying that assigning both before awaiting starts them together and that awaiting each in
turn would make one wait for the other.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`

Step 15: Two edits to `.agents/week-3-task-briefs.md`, and nothing else in that file:

- **15a — lines 82–84.** Replace the fixed 30-issue claim with the mechanism: the two
  `_TaskReminder` warnings are the invariant, the total is not and has moved three times
  this week, so verify both on the untouched tree at Phase 0.
- **15b — the `- [ ] **3.4 — \`LibraryBloc\`, preferences, and the Featured repair.**`
  checklist entry.** Split it into `- [ ] 3.4a` and `- [ ] 3.4b`, each with a one-line
  scope: **3.4a** — `LibraryBloc`, preferences, counts, search, datasource test; **3.4b** —
  the Featured repair (now-playing shelf, wishlist stat, total and owned ids repointed at
  `library_entries`). Keep the existing sub-bullets, moving the "Featured repair lands
  here" bullet under 3.4b and the rest under 3.4a. Note the split is D16 and that 3.4a
  lands first.

Step 16: Create `test/repository/library/library_remote_datasource_test.dart`. See
`tdd.md ## Caveats` item 3 for the harness: a loopback `dart:io` `HttpServer`, a real
`SupabaseClient` pointed at it, and `auth.setInitialSession`. **Do not add a package**; if
the harness cannot be made to work inside the budget, escalate.

Step 17: Create `test/repository/library/library_preferences_repository_test.dart`,
mocking `LibraryPreferencesDatasource`.

Step 18: Modify `test/repository/library/library_repository_test.dart` and
`test/use_case/library/fetch_library_page_use_case_test.dart`; create
`test/use_case/library/fetch_library_counts_use_case_test.dart`.

Step 19: Create `test/cubit/library/library_bloc_test.dart`, covering at minimum the
behaviours 3.4-AC39 lists — including the end-of-results flag coming from the matched
count (3.4-AC7), entries staying readable with nothing emitted inside the debounce window
(3.4-AC42), and a next-page response arriving after a status change being discarded
(3.4-AC43) — plus a plain `test()` that constructing the bloc calls no use case and leaves
the declared initial state.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs` (mocks)

Step 20: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md` verbatim: **Analyzer baseline: 0 errors, 2 warnings, 27 info (29
total)** and **Test baseline: +394 -10**, with pre-existing failures
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). The **2 warnings** are the invariant; the
total is not, and this half adds files, so it will move. The orphaned tracker route
registration is **not** touched in this half — those expected info lints arrive with 3.4b,
not here.

> 20 non-generation steps, at the ceiling. The seven D17 revisions cost two steps
> (`postgrest_utils.dart`, `pubspec.yaml`) and returned two, because the tracker rename and
> its test edit are gone. `escalation.md` stays closed for this run.

## Acceptance criteria source

Canonical: `.agents/runs/library-bloc-preferences-20260827/tech-ac.md ## Technical
acceptance criteria` — **not re-cut by the split; it now stands at 43 criteria** after
D17 added 3.4-AC42 and 3.4-AC43, and each half scopes to its own range (D16).

**IDs in scope for 3.4a: 3.4-AC1 through 3.4-AC25, 3.4-AC37 through 3.4-AC41, and the two
new criteria 3.4-AC42 and 3.4-AC43** (both are state-layer and both are this half's).

Note for QA: **3.4-AC7 and 3.4-AC22 were rewritten on 2026-08-30** — read them as they now
stand, not from memory. AC7's mechanism is the matched count, not a short page; AC22 now
requires the tracker datasource to be *untouched* rather than renamed.

**3.4-AC26 through 3.4-AC36 are 3.4b's and are out of scope here.** They cover the
Featured repair, the `NowPlayingGameEntity` retype, the now-playing tap, the tracker-tree
guardrail (AC32), the Featured test (AC35) and the on-device manual check (AC36). **QA
must not fail this run for any of them** — no file that could satisfy them is in this
half's allowlist, and the Featured path is expected to still read Isar and still render
`EmptyStateCard` when this run ends. That is the correct end state for 3.4a. D17.2
(`_buildNowPlayingCard` becoming a `StatelessWidget`) is likewise 3.4b's.

3.4-AC41 (analyzer, 0 errors and the 2-warning invariant) is a constraint on both halves
and is checked here on this half's diff.

## What 3.4b inherits

Cut 3.4b's brief from the existing `tdd.md` and `code-plan.md` — both already cover both
halves. What 3.4b needs from this run, all landed by the steps above:

- **`LibraryRepository.fetchCounts()` → `Future<Result<LibraryCountsEntity>>`** (steps
  9–10). Serves the snapshot's `totalGamesCount` and `wishlistCount`.
- **`LibraryRepository.fetchAllEntries({LibraryStatus? status})` →
  `Future<Result<List<LibraryEntryEntity>>>`** (steps 9–10), unpaged, `updated_at`
  descending. One method serves all three Featured needs: playing rows, wishlist ids,
  every owned id.
- **`LibraryCountsEntity`** (step 8) — `byStatus` with all six keys present including
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
section including the widget-test scoping decision and D17.2's `StatelessWidget` change.
D17.3's parallel-call comment applies again to `FeaturedRepositoryImpl`'s
`entriesCall`/`countsCall`.

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
  built `ErrorType`. The preference repository is the sanctioned exception to the
  `Result` rule, not to the mixin rule (it touches no network).
- **`flutter-datasource`** — never call `SharedPreferences.getInstance()`; keys go in
  `StorageConstants`, never inline; do not write a generic wrapper around
  `SharedPreferences`. The new library datasource is flat in `data/datasources/`, matching
  `library_remote_datasource.dart` — the tracker's `local/` nesting is a known deviation,
  not the shape to copy.
- **`testing-conventions.md`** — layer-based test paths, `@GenerateMocks` on the direct
  dependency only, `provideDummy` for every `Future<Result<T>>`, `GetIt.instance.reset()`
  in `tearDown`. **Never a golden test.**
- **Regenerated mocks outside the allowlist are expected.** Changing `LibraryRepository`
  regenerates `.mocks.dart` for the add/update/remove library use-case tests, whose
  `.dart` sources are not allowlisted. The regeneration is fine; **do not hand-edit those
  test sources** — if one fails, that is a real signal, so escalate rather than adjust it.
- **`execution.md`** — comments are plain English, explain the why, and are few.
  Constants live near their scope. Nothing outside the allowlist. The `pubspec.yaml` line
  in step 1 is the single human-authorised exception to the read-only rule (D17.6).
- **D15/D9/D10/D12** — `countSavedGames()` and `getOwnedGameIds()` repoint at
  `library_entries` (that repointing itself is 3.4b's work, served by this half's
  `fetchCounts`/`fetchAllEntries`); one status vocabulary with no wishlist boolean; the
  rating input is item 4.6's; Supabase is the source of truth and the Isar cache, IGDB
  refresh and task-tree backup are later items.
- **D14** — binds 3.4b, not this half. No now-playing tap, route push or import changes
  here; `library_stats.dart` is untouched.
- **D17.1** — the tracker preferences chain is untouched; see the allowlist exclusion.
- **The two-warning invariant** — the deliberate `_TaskReminder` pair at
  `task_detail_screen.dart:201` and `:204` must survive. The
  `use_null_aware_elements` info lint at `library_remote_datasource.dart:101` is
  human-approved: **do not "fix" it.**

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not touch files outside the allowlist — escalate instead. In particular, a
Featured file is not a near-miss: it is 3.4b's, so escalate rather than reaching for it,
and the same goes for anything in the tracker preferences chain.

On packages: `stream_transform` is authorised by D17.6 and is step 1's whole job.
**Nothing else may be added to `pubspec.yaml`** — `http` and `rxdart` in particular stay
off-limits, and the design needs neither. If a caveat's fallback seems to need one,
escalate instead.

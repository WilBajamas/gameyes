# QA Report
Source: `.agents/runs/library-bloc-preferences-20260827/task-brief.md` (item 3.4a)
Date: 2026-08-30
Commit verified: `7d87dcc` (plus doc-only `bfcbd3e`, `5577b1b`) on `feature/library-bloc-preferences`, base `618bed1`
Scope: 3.4-AC1–AC25, AC37–AC43. **AC26–AC36 are 3.4b's and were not assessed.**

Overall result: **PASS — pending manual checks**

## Manual verification required

3.4-AC23 — On device, set the Library to list view and to a non-default sort, kill and
relaunch the app, reopen the Library — expect the stored view and order on first paint,
with no visible switch from grid/recently-added. Automated coverage stops at the
repository/datasource boundary (`SharedPreferences` round-trip through a real store and
across a process restart is not exercisable in this suite).

3.4-AC25 — Same relaunch, watching the first frame — expect the status chip back at
`All` and the search field empty, while view mode and sort are the stored ones.

Nothing else needs a device. No screen, widget or navigation is in this half's allowlist.

## Static analysis

Status: **PASS**
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` — exit 0, `git status` clean
afterwards, so the committed generated output is current and analysis ran against it.

`flutter analyze`: **29 issues — 0 errors, 2 warnings, 27 info.** Identical to
`orchestrator-state.md`'s Phase 0 baseline (0 errors / 2 warnings / 27 info / 29 total),
despite 41 files added.

- The 2 warnings are the invariant `_TaskReminder` pair, both still at
  `lib/features/tracker/presentation/screens/task_detail_screen.dart:201` and `:204`.
- Zero issues are attributed to any newly created allowlisted file.
- The one issue on a modified allowlisted file is the human-approved survivor:
  `use_null_aware_elements` at `lib/features/library/data/datasources/library_remote_datasource.dart:154`.
  It has moved from `:101` only because `fetchCounts`/`fetchAllEntries` were added above
  it; it is the same `else if (rating != null)` half of the `clearRating` pair, verbatim
  unchanged in the diff. **Correctly not "fixed"** — converting it would break 3.3-AC26.

## Test results

Testing mode: **coverage**

Status: **PASS**
Tests run: 445  |  Passed: 435  |  Failed: 10

Baseline was +394 −10. Result is **+435 −10** — 41 new tests, all passing, zero new
failures. The ten failures are exactly the recorded pre-existing set, unchanged in name
and count:

- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

`test/repository/tracker/tracker_sort_repository_test.dart` — **6/6 pass, unmodified**
(3.4-AC22's own guard).

### Falsifiability checks

Per the project's falsifiability rule and the 3.3 lesson, six mutations were run to prove
the new tests can fail. **No project file was edited**: an isolated `cp -a` copy of the
tree was used (`package_config.json`'s `rootUri` is relative, so the copy resolves
against itself), it was confirmed green first, and the working tree is clean.

| Mutation | Result |
|---|---|
| Remove the `_queryGeneration` re-check after the await (AC43) | `discards a next-page response that arrives after the status changed` **FAILS** |
| Remove `.debounce()` from the event transformer (AC42/AC8) | `emits nothing and keeps the loaded entries…` and `issues one query for three keystrokes…` **both FAIL** |
| Make the loading emit clear `entries` (AC42) | 4 tests **FAIL**, including the search and status-change tests |
| Revert `hasReachedEnd` to the withdrawn short-page rule, both handlers (AC7) | `sets the end-of-results flag once the loaded count reaches the matched count` **FAILS** |
| Reinstate the `GamesBloc` shape — constructor `add()` + `droppable()` on the query family (AC12) | **all 15** bloc tests FAIL |
| Drop `%` escaping in `postgrestLikePattern`; flip the `rating` sort direction (AC19/AC21/AC37) | the escaping test and the per-sort test **both FAIL** |

AC42 and AC43 rest on tests that genuinely catch their own defect. The datasource test
asserts real request URIs and bodies built by a real `SupabaseClient` over a loopback
socket — it does not pass by construction.

**One mutation survived** — see the coverage gaps below.

## Coverage gaps (coverage mode only)

None of these blocks the gate: in every case the behaviour is present and correct in
source, and each affected criterion has at least one passing test. They are recorded
because the project's standing lesson is that a criterion resting on an unfalsifiable
test is how a defect ships.

1. **3.4-AC7, next-page handler — surviving mutation.** Reverting *only*
   `library_bloc.dart:188-189` to the withdrawn `page.entries.length < pageSize` rule
   leaves the entire bloc suite **green**. The first-page half is guarded (two tests); the
   append half is not. The code is correct (`state.entries.length + page.entries.length
   >= page.matchedCount`), and `appends the next page…` seeds a case where both rules
   agree. A next-page test at an exact page-size multiple (e.g. 20 loaded, 20 returned,
   `matchedCount: 40` → expect `hasReachedEnd` true) would close it.
2. **3.4-AC10, failed append.** `library_bloc.dart:191-194` correctly emits
   `nextPageStatus: failed` + `nextPageError` without touching `entries`, but no test
   exercises it. The first-page failure path *is* tested.
3. **3.4-AC8, whitespace-only term.** `library_bloc.dart:81` trims and `:112` sends
   `null`, so `"   "` issues no `ilike` — correct, untested at the bloc level.
4. **3.4-AC6, overlapping next-page requests.** Rests on `droppable()` at
   `library_bloc.dart:49` by inspection; no test adds two next-page events.

None of the four appears in 3.4-AC39's enumerated minimum, all of which is present.

## Acceptance criteria

### Library state shape

3.4-AC1: PASS — `library_state.dart:17-33`, all nine required fields independently
readable, plus `nextPageStatus`, `matchedCount`, `nextPageError`.
3.4-AC2: PASS — `library_bloc.dart:107-113` sends both predicates;
`library_remote_datasource.dart:31-39` ANDs `eq(status)` with `ilike(title)`. Tests:
`sends both the status and the search term when a term is entered under an active status`;
datasource `should keep both predicates when a status and a search term are supplied`.
Neither clears the other — `:73-82` inherits the unchanged axis from state.
3.4-AC3: PASS — `library_bloc.dart:87-99` (`hasReachedEnd: false`) + `:107-113`
(`offset: 0`), sort/view mode/term inherited. Test: `resets to the first page and keeps
sort, view mode and term when the status changes`.
3.4-AC4: PASS — same path, event `LibrarySortSelected`. Test: `resets to the first page
and keeps status, view mode and term when the sort changes`.
3.4-AC5: PASS — `library_bloc.dart:146-156`, synchronous, no use-case fetch. Test:
`emits a new view mode without fetching` with `verifyZeroInteractions(fetchLibraryPageUseCase)`.
3.4-AC6: PASS — `library_bloc.dart:174` (`offset: state.entries.length`) and `:186`
(`List.of(state.entries)..addAll(...)`); duplicate suppression by `droppable()` at `:49`.
Test: `appends the next page rather than replacing the loaded entries`. See coverage gap 4.
3.4-AC7: PASS — derived from `matchedCount` in **both** handlers,
`library_bloc.dart:135` and `:188-189`. The withdrawn short-page rule appears nowhere in
the file (`pageSize` is referenced only as a `limit:` argument at `:110` and `:173`).
Guard at `:162` blocks further requests once set; reset at `:96`. Tests: `sets the
end-of-results flag once the loaded count reaches the matched count` (falsifiable) and
`does not set the end-of-results flag on a full page that is not the last`. See coverage
gap 1 for the next-page half.
3.4-AC8: PASS — 300 ms `debounce()` in the named transformer,
`library_bloc.dart:25-34` + `const.dart` `LibraryConstants.searchDebounce`. Test:
`issues one query for three keystrokes inside the debounce window`, `.called(1)`,
falsifiable. Whitespace handled at `:81`/`:112` — see coverage gap 3.
3.4-AC9: PASS — two separate enums (`library_state.dart:11,13`); the append emit at
`library_bloc.dart:168` touches only `nextPageStatus`. Test: `appends the next page…`
expects the loading state to still carry all 20 seeded entries.
3.4-AC10: PASS — first-page failure `library_bloc.dart:138-142` (test: `emits loading
then failed when the first page fails`); append failure `:191-194` leaves `entries`
untouched; `LibraryRetried` (`library_event.dart:46-51`) re-issues from state. See
coverage gap 2.
3.4-AC11: PASS — `ErrorType.notSignedIn` reaches `state.error` with
`status: LibraryLoadStatus.failed`, structurally distinct from
`LibraryLoadStatus.empty` (`library_bloc.dart:130-132`). Test: `emits loading then failed
when the first page fails`.
3.4-AC12: PASS — `library_bloc.dart:44-51` registers handlers and nothing else; no
`add()`, no use-case call, no preference read. `restartable()` on the query family,
`droppable()` only on `LibraryNextPageRequested`. Test: `initial state is the declared
LibraryState and no use case is called` (three `verifyZeroInteractions`). Mutation proof:
reintroducing the `GamesBloc` shape fails all 15 tests.
3.4-AC42: PASS — the debounce lives in the transformer, so a keystroke inside the window
never reaches the handler and emits nothing; the loading emit at `library_bloc.dart:87-99`
omits `entries` entirely. Test: `emits nothing and keeps the loaded entries until the
debounce window elapses` (`expect: []` + entries assertion). Falsifiable both ways.
3.4-AC43: PASS — `_queryGeneration` is a private `int` on the bloc and **not** a
`LibraryState` field (`library_bloc.dart:61`); bumped first at `:67`, captured before the
await at `:166`, re-checked after at `:181` with a bare `return`. Test: `discards a
next-page response that arrives after the status changed`. Falsifiable — removing `:181`
fails it.

### Counts

3.4-AC13: PASS — `LibraryRepository.fetchCounts()` → `Future<Result<LibraryCountsEntity>>`
(`library_repository.dart:17`), `FetchLibraryCountsUseCase` (`fetch_library_counts_use_case.dart:12`),
six status keys + `total` (`library_counts_entity.dart:8-11`). Tests:
`fetch_library_counts_use_case_test.dart` (2), `library_repository_test.dart` counts tests.
3.4-AC14: PASS — `library_remote_datasource.dart:58-66` uses postgrest's
`.count()` HEAD request per status and `.count(CountOption.exact)` on the paged query
(`:44`); no rows are fetched to measure. Test: `should request one count per status`
asserts six requests carrying only the status predicate.
3.4-AC15: PASS — `Map.fromIterables(LibraryStatus.values, counts)`
(`library_remote_datasource.dart:68`) always yields all six keys; total is their fold
(`library_repository_impl.dart:129`). Tests: `should return zero for a status with no
rows`, `should sum the six status counts into the library total`, and the use-case
success test with `dropped: 0`.
3.4-AC16: PASS — `fetchCounts()` takes no search term and is read once per visit
(`library_bloc.dart:116-118`), so status counts ignore search; the count-line figure is
`page.matchedCount` from the filtered paged query (`:135`, stored at
`library_state.dart:30`), and `counts.total` honours neither. Test: `reads the counts
once and not again when the status changes` (`.called(1)`).
3.4-AC17: PASS — `_currentUserId()` (`library_remote_datasource.dart:179-184`) throws
`AuthSessionMissingException` before any count is issued; `BaseRepositoryMixin` maps it to
`ErrorType.notSignedIn`. Tests: `should return a failure when the session is missing`
(repository), `should return the failure when the repository fails` (use case).

### Search in the data layer

3.4-AC18: PASS — `library_remote_datasource.dart:34-39`, case-insensitive `ilike` on
`title`, appended as an ordinary filter alongside the status `eq`. A no-term call adds no
`title` parameter — test `should filter by user and sort by created_at descending for a
default paged fetch` asserts `containsKey('title')` is false. Per `tdd.md` D-B, the count
modifier changes only the `Prefer` header, not path, predicates, order or range.
3.4-AC19: PASS — `postgrest_utils.dart:5-10` doubles `\` first, then escapes `%` and `_`.
Tests: `should escape percent, underscore and backslash in the search term`
(asserts `ilike.%100\%\_off\\deal%` off the real request URI) and `should keep a comma in
the search term inside a single predicate`. Falsifiable — dropping `%` escaping fails it.
3.4-AC20: PASS — one query, one filter chain: `.range(offset, offset + limit - 1)`
(`library_remote_datasource.dart:43`) is applied after both predicates. Test: `should
request the second page when a non-zero offset is supplied`.
3.4-AC21: PASS — `.order(column, ascending: !isDescending)` (`:42`) sits on the same
builder regardless of the term, and `_sortColumn` (`:188-194`) is byte-identical to 3.3.
Test: `should use the expected column and direction for each sort option` asserts
`nullslast` on all five. Falsifiable — flipping the `rating` direction fails it.

### Preferences

3.4-AC22: PASS — **verified against git across all three commits, not from
`diff-summary.md`.** `git diff --name-only 618bed1..HEAD | grep -i tracker` returns
nothing: no tracker file is touched in `7d87dcc`, `bfcbd3e` or `5577b1b`.
`TrackerPreferencesDatasource`, `TrackerSortRepository(Impl)`, `TrackerCubit`, the two
tracker sort use cases and `tracker_sort_repository_test.dart` are all untouched. The key
is byte-identical — the `const.dart` diff is **additions only**, and
`static const trackerSortTagKey = 'tracker_sort_tag';` at `lib/core/res/const.dart:28` is
an unchanged context line. It is the only occurrence of that string in `lib/` or `test/`.
`TrackerPreferencesDatasource`, `TrackerSortRepository`, `GetTrackerSortUseCase`,
`SaveTrackerSortUseCase` and `TrackerCubit` all still resolve in the regenerated
`service_locator.config.dart:213-221,287,290,420`, whose diff is additions only.
`tracker_sort_repository_test.dart` passes 6/6 unmodified. A separate
`LibraryPreferencesDatasource` is registered alongside.
3.4-AC23: MANUAL (device) — code and unit coverage are correct: separate keys
`library_view_mode`/`library_sort` (`const.dart:29-30`), device-scoped
`SharedPreferences`, writes at `library_bloc.dart:102` (sort) and `:155` (view mode).
Tests: `should write the enum name for the view mode and the sort`. Restart survival needs
the device check listed above.
3.4-AC24: PASS — swallow-on-failure try/catch on all four datasource members
(`library_preferences_datasource.dart:11-41`); unrecognised or absent values fall back to
`grid`/`recentlyAdded` (`library_preferences_repository_impl.dart:17-23,34-40`). Tests:
`should return grid and recently added when nothing is stored`, `should fall back to the
defaults when the stored value is unrecognised`, `should not surface an error when a write
fails`.
3.4-AC25: MANUAL (device) — the stored view mode and sort are read at
`library_bloc.dart:69-71,76-79,91` and land in the **same** emit as the first `loading`
(`:87-99`), before the fetch starts at `:107`, so there is no intermediate default-view
emit. `activeStatus` and `searchTerm` have no persistence path anywhere in the diff. Test:
`applies the stored view mode and sort before the first fetch` asserts the loading state
already carries `list`/`alphabetical`. First-paint absence of a visible switch is the
device check listed above.

### Featured repair

3.4-AC26 – 3.4-AC36: **OUT OF SCOPE — 3.4b.** Not assessed, and correctly unimplemented
here. Featured still reads Isar and still renders `EmptyStateCard`; no Featured file,
`NowPlayingGameEntity` or `library_stats.dart` change appears in the diff. This is 3.4a's
correct end state per D16 and `task-brief.md`.

### Tests

3.4-AC37: PASS — `test/repository/library/library_remote_datasource_test.dart` constructs
a real `LibraryRemoteDatasource` over a real `SupabaseClient` pointed at a loopback
`HttpServer` with `auth.setInitialSession`, and asserts the **built request**: paged fetch
with and without status (`:83-107`), with and without a term (`:109-133`), each of the five
sorts (`:165-182`), a non-zero offset (`:184-196`), the add payload (`:198-224`) and a
partial update omitting unsupplied fields (`:226-248`). Genuinely asserting, not passing
by construction — proven by the escaping and sort-direction mutations.
3.4-AC38: PASS — `should send an explicit null for the rating column when clearRating is
set` asserts `containsKey('rating')` **true** and the value **null**; `should omit the
rating key when neither a rating nor clearRating is supplied` asserts the key is absent.
This is the first automated guard `clearRating` has ever had.
3.4-AC39: PASS — all eleven enumerated behaviours are present in
`test/cubit/library/library_bloc_test.dart` (1 `test()` + 14 `blocTest`s, house style, all
passing): initial state, first-page success and failure, status reset, sort reset,
view-mode-no-fetch, search composing with status, debounce collapsing input, append,
end-of-results from matched count (both directions), entries readable through a search,
stale next-page discarded.
3.4-AC40: PASS — `library_repository_test.dart` (matched-count passthrough, counts
summing, zero-count status, signed-out failure, unpaged read),
`fetch_library_counts_use_case_test.dart` (success + signed-out failure),
`fetch_library_page_use_case_test.dart` (`should forward the search term to the
repository`). All with mocked collaborators.
3.4-AC41: PASS — 0 errors; the 2-warning `_TaskReminder` invariant intact; total 29,
identical to baseline. Ten pre-existing failures unchanged in name and count; no new
failure. (The orphaned-tracker-route info lints AC41 anticipates arrive with 3.4b, not
here — correct, since `library_stats.dart` is untouched.)

## Scope check

Verified from git, not from `diff-summary.md`. `git status --short` is **empty** — no
uncommitted change, before or after `build_runner` and the coverage run.

`git show --name-only 7d87dcc` matches the allowlist exactly. Every non-allowlisted path
in it is a generated output whose annotated source is allowlisted:
`service_locator.config.dart`, the two new `.freezed.dart` entities,
`library_state.freezed.dart`, and six `.mocks.dart` files — including the four
regenerated mocks for the add/update/remove/page use-case tests that `task-brief.md`
predicted and forbade hand-editing. Those test sources are **not** in the diff; the
regenerated mocks pass.

`.agents/handover.md` appears in the `618bed1..7d87dcc` range but is **not** in the Dev
commit — it came from the earlier Phase 0/1 doc commit `a9cc7db`. Not a scope violation.

`.agents/week-3-task-briefs.md` — exactly the two authorised edits: the stale
`30 issues / A run that reports 28 has broken something` preamble replaced with the
2-warning mechanism (step 15a), and the 3.4 checklist entry split into 3.4a/3.4b with the
Featured bullet moved under 3.4b (step 15b). Nothing else in that file.

**`pubspec.yaml` (D17.6 exception)** — three added lines, one of them the declaration
`stream_transform: ^2.1.1` plus a one-line comment and a blank, under `dependencies`
beside `bloc_concurrency`. `bloc_concurrency` stays. Nothing else added, removed or moved.
**`pubspec.lock`** — a single-line change, `dependency: transitive` →
`dependency: "direct main"` on `stream_transform`. **No version moved**, no other package
entry changed, no `sha256` changed. Exactly what `task-brief.md` predicted.

## Architectural compliance

Status: **PASS**

FAILs: NONE
WARNINGs: NONE

Checked against `tdd.md` and against `flutter-state`, `flutter-usecase`,
`flutter-repository` and `flutter-datasource` (no widget file in scope, so
`flutter-widget-test` and `flutter-widgets` do not apply).

**`tdd.md`** — every class name, file path and signature matches: the five new use cases,
two entities, the preferences interface/impl pair, the enum at `lib/core/enums/`, the
public `postgrestLikePattern` at `lib/core/utils/` (D-I; **no private `_pattern` survives
in the datasource**), the state table field-for-field, the event tree exactly as drawn,
and the three D17 mechanisms in the places D-D/D-G/D-H specify. `LibraryRepositoryImpl`
takes the datasource, use cases take the **interface**, and nothing injects an impl.
`stream_transform` is the only added package. The D17.3 parallel-call comment is present
at `library_bloc.dart:105-106`, plain English and no jargon.

**`flutter-state`** — file/class naming, `@injectable`, sealed `Equatable` event base with
`final class` members in a `part` file, `@freezed sealed` state with one `const factory`
and `@Default` throughout, feature-specific enums rather than booleans, `ErrorType?` for
errors, `status`/`nextPageStatus` kept separate, handlers registered in the constructor,
`Result` unwrapped by an exhaustive `switch` **expression** with no `default:` in both
handlers, and the prescribed
`List.of(state.entries)..addAll(page.entries)` append. All satisfied.

**Two documented deviations, both authorised — recorded, not counted as violations:**

1. `flutter-state` says `droppable()` for a fetch; the query family uses `restartable()`
   via `_latestQuery()`. This is **required** by 3.4-AC12 and `tdd.md` D-D — the skill's
   default is precisely the `GamesBloc` trap the criterion exists to forbid. `droppable()`
   is correctly kept on `LibraryNextPageRequested`, where it is the wanted behaviour.
2. `flutter-usecase`/`flutter-repository` say `call()` and repository members return
   `Future<Result<T>>`; `LibraryPreferencesRepository` and the three preference use cases
   are synchronous/`Future<void>` and outside `Result`. Sanctioned by `task-brief.md
   ## Constraints`, `tdd.md` D-C and the existing `GetTrackerSortUseCase` precedent — and
   necessary for 3.4-AC24 to be expressible. The impl hand-rolls no try/catch and builds
   no `ErrorType`; the swallow lives in the datasource, matching the tracker precedent.
   `LibraryRepositoryImpl` — which does touch the network — routes **every** method through
   `BaseRepositoryMixin.fetchData`.

**`flutter-datasource`** — `@injectable`, `SharedPreferences` injected (never
`getInstance()`), both keys in `StorageConstants` with no inline strings, named per-
preference methods rather than a generic wrapper, and flat in `data/datasources/` rather
than copying the tracker's known `local/` deviation. Satisfied.

**`flutter-usecase`** (entities) — both new entities are `@freezed sealed`, depend only on
Dart core, `freezed`, a core enum and another domain entity, and carry no JSON. Satisfied.

The deliberate duplication `tdd.md` D-C flags — the same six-line try/catch in both
preferences datasources — is present and was **not** "tidied" back together. Correct.

## Escalation required

NONE. `escalation.md` stays closed for this run.

Recommended for the orchestrator to carry forward, not blocking: the four coverage gaps
above, of which gap 1 (the next-page `hasReachedEnd` derivation surviving a mutation) is
the one worth closing with a single `blocTest` in a later run.

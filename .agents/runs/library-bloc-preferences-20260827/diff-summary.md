# Diff Summary
Source: `.agents/runs/library-bloc-preferences-20260827/task-brief.md` (item 3.4a)
Date: 2026-08-30
Branch: feature/library-bloc-preferences
Commit: 7d87dcc556293ac11274a2a5d23f8f48d155ef69

## Files created
lib/core/enums/library_view_mode.dart — `LibraryViewMode { grid, list }`
lib/core/utils/postgrest_utils.dart — `postgrestLikePattern(String term)`, the shared `ilike` escaping/wrapping helper
lib/features/library/data/datasources/library_preferences_datasource.dart — library-only `SharedPreferences` reads/writes for view mode and sort, mirroring `TrackerPreferencesDatasource`'s shape without touching it
lib/features/library/data/repositories/library_preferences_repository_impl.dart — matches stored names to enum values, falls back to defaults
lib/features/library/domain/repositories/library_preferences_repository.dart — synchronous, non-throwing preferences contract
lib/features/library/domain/entities/library_counts_entity.dart — per-status counts + library total
lib/features/library/domain/entities/library_page_entity.dart — a page of entries + matched-row count
lib/features/library/domain/use_cases/fetch_library_counts_use_case.dart
lib/features/library/domain/use_cases/get_library_preferences_use_case.dart — synchronous, returns a record
lib/features/library/domain/use_cases/save_library_view_mode_use_case.dart
lib/features/library/domain/use_cases/save_library_sort_use_case.dart
lib/features/library/presentation/blocs/library_state.dart — `LibraryState`, `LibraryLoadStatus`, `LibraryNextPageStatus`
lib/features/library/presentation/blocs/library_bloc.dart — `LibraryBloc`, the debounce/restartable/droppable transformers, `_queryGeneration`
lib/features/library/presentation/blocs/library_event.dart — `part of library_bloc.dart`; the sealed event tree

## Files modified
pubspec.yaml — declared `stream_transform: ^2.1.1` under `dependencies` (D17.6, the one authorised exception to the read-only rule)
lib/core/res/const.dart — added `libraryViewModeKey`/`librarySortKey` to `StorageConstants`; `trackerSortTagKey` untouched
lib/features/library/const.dart — added `LibraryConstants` (page size 20, 300ms search debounce)
lib/features/library/data/datasources/library_remote_datasource.dart — `fetchPage` gained `searchTerm` and now returns `(rows, matchedCount)` via `.count(CountOption.exact)`; added `fetchCounts` (six concurrent head counts) and `fetchAllEntries` (unpaged, `updated_at` desc); `_currentUserId`, `_sortColumn` and the `clearRating` pair untouched
lib/features/library/domain/repositories/library_repository.dart — `fetchPage` returns `LibraryPageEntity`, gained `searchTerm`; added `fetchCounts`/`fetchAllEntries`
lib/features/library/data/repositories/library_repository_impl.dart — mirrors the interface through `BaseRepositoryMixin`
lib/features/library/domain/use_cases/fetch_library_page_use_case.dart — new signature/return type
.agents/week-3-task-briefs.md — lines 82-84 replaced with the "2 warnings is the invariant, not the total" mechanism (D-E); the 3.4 checklist entry split into 3.4a/3.4b (step 15b)

## Test files
test/repository/library/library_remote_datasource_test.dart — NEW, 13 tests. Real `SupabaseClient` against a loopback `dart:io HttpServer` with `auth.setInitialSession`, asserting the built request URL/body: default paged fetch, status predicate, search predicate, both together, escaping of `%`/`_`/`\`, a comma surviving inside one predicate, every sort's column/direction, a non-zero offset, add payload, partial update, `clearRating`'s explicit null vs. omitted key, and one count request per status.
test/repository/library/library_preferences_repository_test.dart — NEW, 5 tests: defaults, round trip, unrecognised-value fallback, write forwarding, swallowed write failure.
test/repository/library/library_repository_test.dart — MODIFIED: existing `fetchPage` tests updated to `LibraryPageEntity`; added matched-count passthrough, counts summing, zero-count status, signed-out counts failure, unpaged read.
test/use_case/library/fetch_library_page_use_case_test.dart — MODIFIED: new signature; added search-term forwarding test.
test/use_case/library/fetch_library_counts_use_case_test.dart — NEW, 2 tests: success and signed-out failure.
test/cubit/library/library_bloc_test.dart — NEW, 15 tests (1 plain `test()` + 14 `blocTest`s): initial state / no dispatch (3.4-AC12), first-page success/failure, status and sort changes resetting pagination, view-mode change with no fetch, search composing with status, debounce collapsing keystrokes, entries staying readable through the debounce window (3.4-AC42), next-page append, end-of-results from matched count both ways (3.4-AC7), a stale next-page response discarded after a status change (3.4-AC43), stored preferences applied before the first fetch, counts read once per visit.

## Self-corrections
None — every implementation and test file passed on first `flutter analyze`/`flutter test` run. Two rounds of lint cleanup (removing redundant explicit `status: null`/`searchTerm: null`/`hasReachedEnd: false` arguments from the new bloc test) were done proactively before the final analyzer run, not in response to a reported failure, so they aren't counted as self-corrections against a budget.

## Deviations from implementation plan
NONE — the plan was followed exactly, including all D17 revisions.

## Caveats resolved during execution (per `tdd.md ## Caveats`)
1. **Broadcast-stream double subscription** — held. The `_latestQuery()` transformer subscribes to the bloc's event stream twice (once per branch before `merge`), and this worked with no runtime error across all 15 bloc tests, confirming `tdd.md`'s reasoning that `Bloc`'s `_eventController` is a broadcast controller. Neither fallback (`asBroadcastStream()`, whole-stream debounce) was needed.
2. **Search-term encoding** — a comma survives inside a single `ilike` predicate with no fallback needed; asserted directly in `library_remote_datasource_test.dart` (`'should keep a comma in the search term inside a single predicate'`). Percent-encoding round-trips correctly through `Uri.queryParameters` with no corruption.
3. **Datasource test harness** — the loopback `HttpServer` + real `SupabaseClient` + `auth.setInitialSession` harness worked as designed on the first attempt; no `http` package was added.

## Verification against baseline
`flutter analyze`: 0 errors, 2 warnings (`_TaskReminder` pair, unchanged), 27 info, 29 total — matches `orchestrator-state.md`'s recorded baseline exactly. The human-approved `use_null_aware_elements` info lint at `library_remote_datasource.dart` survives (now at line 154, since new methods were added above it) and was not touched.
`flutter test`: +435 -10. Baseline was +394 -10; 41 new tests added, all passing, 0 new failures. The same 10 pre-existing failures remain, unchanged in name and count: `tracker_repository_test.dart` (4), `game_detail_cubit_test.dart` (3), `games_bloc_test.dart` (3).

## Acceptance criteria status
3.4-AC1: satisfied
3.4-AC2: satisfied
3.4-AC3: satisfied
3.4-AC4: satisfied
3.4-AC5: satisfied
3.4-AC6: satisfied
3.4-AC7: satisfied (matched-count derivation, both handlers; short-page rule removed per D17.8)
3.4-AC8: satisfied
3.4-AC9: satisfied
3.4-AC10: satisfied
3.4-AC11: satisfied
3.4-AC12: satisfied
3.4-AC13: satisfied
3.4-AC14: satisfied (`.count(CountOption.exact)` / `.count()` HEAD requests, no row fetch)
3.4-AC15: satisfied
3.4-AC16: satisfied
3.4-AC17: satisfied
3.4-AC18: satisfied
3.4-AC19: satisfied
3.4-AC20: satisfied
3.4-AC21: satisfied
3.4-AC22: satisfied (`TrackerPreferencesDatasource` and everything above it untouched; not in the allowlist and not opened)
3.4-AC23: satisfied
3.4-AC24: satisfied
3.4-AC25: satisfied
3.4-AC37: satisfied
3.4-AC38: satisfied
3.4-AC39: satisfied
3.4-AC40: satisfied
3.4-AC41: satisfied
3.4-AC42: satisfied (loading emit does not clear `entries`; reached only after debounce elapses)
3.4-AC43: satisfied (`_queryGeneration`, private to the bloc, not in `LibraryState`)

3.4-AC26 through 3.4-AC36 are 3.4b's and out of scope — Featured still reads Isar and still renders `EmptyStateCard`, which is this run's correct end state.

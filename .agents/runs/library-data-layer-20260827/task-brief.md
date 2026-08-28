# Task Brief
Source: `.agents/week-3-task-briefs.md` item 3.3 (lines 211–232), via `tech-ac.md`
Date: 2026-08-27

## Context

Widen `library_entries` with the six columns the Library spec needs and give the app
its first read/write path to that table — DTO, entity, status mapping, Supabase
datasource, repository on `Result<T>`, four use cases — while breaking
`LibrarySnapshotEntity`'s dependency on the Isar `SavedGame` without losing the
tracker-detail push that depends on it.

## Testing mode

**coverage** — Rule applied: *persistence*. First match in the list; the item is also
authorisation-adjacent (every path runs under RLS). Justification: this is the first
code in the app's history that writes a row to `library_entries`, and the status
mapping has a known one-in-six failure (`onHold` → `on_hold`) that only a
per-value test catches.

## File allowlist

### CREATE NEW
- `supabase/migrations/20260827120000_library_entries_details.sql` — additive
  migration: six columns, three check constraints, nothing else touched.
- `lib/core/enums/library_sort.dart` — the five sort options from
  `library-design-conventions.md:54`.
- `lib/features/library/const.dart` — `LibraryEntryConstants`: table name and column
  names, shared by the DTO's `@JsonKey`s and the datasource.
- `lib/features/library/data/models/library_status_column.dart` —
  `LibraryStatus` ↔ column-value mapping, both directions, no fallback branch.
- `lib/features/library/data/models/library_entry_dto.dart` — freezed DTO over the
  full column set, with `toEntity()`.
- `lib/features/library/data/datasources/library_remote_datasource.dart` — Supabase
  table access: paged filtered sorted read, insert, partial update, delete.
- `lib/features/library/data/repositories/library_repository_impl.dart` — the
  interface on `BaseRepositoryMixin`.
- `lib/features/library/domain/entities/library_entry_entity.dart` — freezed domain
  entity, `LibraryStatus` typed, no data-layer imports.
- `lib/features/library/domain/repositories/library_repository.dart` — abstract
  interface, four methods, all `Future<Result<T>>`.
- `lib/features/library/domain/use_cases/fetch_library_page_use_case.dart`
- `lib/features/library/domain/use_cases/add_library_entry_use_case.dart`
- `lib/features/library/domain/use_cases/update_library_entry_use_case.dart`
- `lib/features/library/domain/use_cases/remove_library_entry_use_case.dart`

### MODIFY EXISTING
- `lib/core/data/models/error.dart` — four new variants (`duplicateEntry`,
  `invalidValue`, `notAllowed`, `notSignedIn`), a `postgrestError` factory, and the
  three SQLSTATE literals as private static consts.
- `lib/core/data/datasource/base_repository_mixin.dart` — two catch clauses added
  above `catch (_)`: `PostgrestException` and `AuthSessionMissingException`. Nothing
  existing is removed or reordered.
- `lib/core/domain/entities/tracker_saved_game_entity.dart` — three nullable fields
  added: `hoursLogged`, `averageCompletionHours`, `manualProgressPercentage`.
- `lib/features/tracker/data/models/saved_game.dart` — `toEntity()` maps those three
  fields. **No field is removed** (3.3-AC35).
- `lib/features/featured/domain/entities/library_snapshot_entity.dart` —
  `nowPlayingGames` retyped to `List<TrackerSavedGameEntity>`; the
  `features/tracker/data/` import goes.
- `lib/features/featured/data/repositories/featured_repository_impl.dart` —
  `getLibrarySnapshot` maps the datasource's `SavedGame`s through `.toEntity()`.
  Its `FeaturedLocalDatasource` source is unchanged (3.3-AC34).
- `lib/features/featured/presentation/widgets/library_stats.dart` — parameter type,
  import, and `TrackerGameDetailRoute(game: topGame)`. No other change, no comment.
- `.agents/references/library-design-conventions.md` — **line 67 only** (inside §5,
  not §6): the grid-meta examples lose `· Ch. 9`, with a short inline note recording
  D11.

### TEST FILES
- `test/api/library/library_status_column_test.dart` — each of the six enum values
  serialises to its literal, individually; each of the six literals parses back;
  an unknown string yields null.
- `test/api/library/library_entry_dto_test.dart` — full-column `fromJson`/`toJson`
  on the column-name keys; an all-nulls row yields `null` (not `0`/`0.0`/`''`);
  `toEntity()` produces a `LibraryStatus` and throws on an unknown status string.
- `test/repository/library/library_repository_test.dart` — the error mapping
  (`23505`/`23514`/`42501` → three different `ErrorType`s, no session →
  `notSignedIn`, malformed status → a failure), the empty page as success, and that
  no exception escapes.
- `test/use_case/library/fetch_library_page_use_case_test.dart`
- `test/use_case/library/add_library_entry_use_case_test.dart`
- `test/use_case/library/update_library_entry_use_case_test.dart`
- `test/use_case/library/remove_library_entry_use_case_test.dart` — one each: the
  use case forwards to the repository and returns its `Result` unchanged. The update
  one additionally covers the rating write path (3.3-AC26), including `clearRating`.
- `test/features/featured/presentation/blocs/library_stats_cubit_test.dart`
  (**modify**) — `:99` builds a `SavedGame` into `nowPlayingGames`; it becomes a
  `TrackerSavedGameEntity`. Nothing else in the file changes, and no assertion is
  weakened. (This file sits under a non-standard path; leave it there — moving it is
  not this run's work.)

## Implementation plan

Step 1: Write `supabase/migrations/20260827120000_library_entries_details.sql` —
one `alter table … add column` for the six columns and one `alter table … add
constraint` for the three checks. Do not open the three existing migrations.

Step 2: Create `lib/core/enums/library_sort.dart`.

Step 3: Create `lib/features/library/const.dart` with the table name and every
column name as `static const`.

Step 4: Modify `lib/core/data/models/error.dart` — add the four variants, the
`ErrorType.postgrestError({required PostgrestException exception})` factory
switching on `exception.code`, and the three private SQLSTATE constants.

Step 5: Modify `lib/core/data/datasource/base_repository_mixin.dart` — add
`on PostgrestException` and `on AuthSessionMissingException` clauses above the
existing `catch (_)`. Do not touch the Dio or `FunctionException` clauses.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`
(freezed — `ErrorType` gained variants).

Step 6: Create `lib/features/library/domain/entities/library_entry_entity.dart`.

Step 7: Create `lib/features/library/data/models/library_status_column.dart`.
The `columnValue` switch has no `default` branch.

Step 8: Create `lib/features/library/data/models/library_entry_dto.dart`, including
`toEntity()`, which throws `FormatException` when `fromColumnValue` returns null.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`
(freezed + json_serializable).

Step 9: Create `lib/features/library/data/datasources/library_remote_datasource.dart`.
Every method `async`; one private session-id helper that throws
`AuthSessionMissingException()`; one private no-`default` switch mapping
`LibrarySort` to its column and direction.

Step 10: Create `lib/features/library/domain/repositories/library_repository.dart`.

Step 11: Create `lib/features/library/data/repositories/library_repository_impl.dart`.
**Every DTO→entity conversion happens inside the future handed to `fetchData`, never
via `result.map(...)` afterwards** — `toEntity()` can throw and must be caught.

Step 12: Create the four use case files under
`lib/features/library/domain/use_cases/`. Grouped as one step because each is a
five-line constructor-plus-`call` forwarder with no logic of its own.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`
(injectable — DI graph for the datasource, repository and four use cases).

Step 13: Modify `lib/core/domain/entities/tracker_saved_game_entity.dart` and
`lib/features/tracker/data/models/saved_game.dart` together — the three fields and
the three lines of `toEntity()` that fill them. One step: the entity is useless
without its mapping.

Step 14: Retype the seam, in one step because the tree does not compile between the
edits — `lib/features/featured/domain/entities/library_snapshot_entity.dart`,
`lib/features/featured/data/repositories/featured_repository_impl.dart`,
`lib/features/featured/presentation/widgets/library_stats.dart`, and
`test/features/featured/presentation/blocs/library_stats_cubit_test.dart`.
`library_stats.dart` must still push `TrackerGameDetailRoute` — it becomes
`TrackerGameDetailRoute(game: topGame)`. Do not delete the progress branch at
`:287-305`.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`
(freezed — `TrackerSavedGameEntity` gained fields).

Step 15: Edit `.agents/references/library-design-conventions.md` line 67 only.

Step 16: Write `test/api/library/library_status_column_test.dart`.

Step 17: Write `test/api/library/library_entry_dto_test.dart`.

Step 18: Write `test/repository/library/library_repository_test.dart` with
`@GenerateMocks([LibraryRemoteDatasource])`.

Step 19: Write the four `test/use_case/library/*_use_case_test.dart` files, each
with `@GenerateMocks([LibraryRepository])`. Grouped as one step for the same reason
as step 12.

**Checkpoint:** `dart run build_runner build --delete-conflicting-outputs`
(mockito — `*.mocks.dart` for the five new test files).

Step 20: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md`, quoted verbatim: `Analyzer baseline: 0 errors, 2 warnings,
26 info (28 total)` and `Test baseline: +363 -10`, with
`Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart
(4), test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3)`. The 2 warnings are the invariant that
carries meaning (the `_TaskReminder` pair); the 28 total is not. Only a new,
in-scope failure is yours to fix.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 3.3-AC1 – 3.3-AC35.

3.3-AC30 is manual and on-device — it cannot be unit tested and no test should
pretend to. Leave it for the QA manual checklist.

## Constraints

- **Do not add a package.** Everything needed (`supabase_flutter`, `freezed`,
  `json_serializable`, `injectable`, `mockito`) is already in `pubspec.yaml`.
- `dart-style.md`: single quotes, trailing commas on multi-line argument lists, 80
  columns, no `default:` in a switch over an enum or sealed class, no `dynamic`, no
  `late`, no `print`, no bare top-level constants.
- Comments: plain English, explain the *why*, few of them. **Widget files carry
  none** — that binds `library_stats.dart`.
- Never edit a generated file (`*.freezed.dart`, `*.g.dart`, `*.gr.dart`,
  `*.config.dart`, `*.mocks.dart`). Fix the source and regenerate.
- Never call `getIt<T>()` inside a feature class — constructor injection only.
- Repositories never throw; every path returns `Result<T>`.
- Never a golden test, whatever a criterion says about appearance.
- Testing conventions: mock only the immediate dependency below (repository test →
  datasource; use case test → repository **interface**); `provideDummy` for every
  `Result<T>` return; `GetIt.instance.reset()` in `tearDown`.
- Do not apply the migration to any Supabase project, and do not edit
  `20260805200002_library_entries.sql` or the other two migrations.
- Do not repoint `featured_local_datasource.dart`'s `statusEqualTo('Playing')` or
  `isWishlistedEqualTo(true)` — that is item 3.4's Featured repair.
- Do not add a count use case, a wishlist boolean column, a chapter column, or a
  legacy `Status` → `LibraryStatus` mapping.
- `tdd.md ## Caveats I could not execute` lists five claims that need runtime
  confirmation, each with a named fallback. Record the outcome of each as a
  self-correction in `diff-summary.md`, whichever way it goes.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead.

# QA Report
Source: `.agents/week-3-task-briefs.md` item 3.3 (lines 211–232), via `tech-ac.md`
Date: 2026-08-28
Commits verified: `6c89deb` (implementation), `9f22b6b` (Phase 4B revision)

Overall result: PASS — pending manual checks

## Manual verification required

3.3-AC30 — On a real Supabase project with the migration applied: sign in as user A,
add a library entry; sign in as user B and fetch the library page — expect A's entry
absent from B's results. Then attempt an insert under B's session carrying A's
`user_id` — expect rejection (SQLSTATE `42501`, surfacing as `ErrorType.notAllowed()`).
This is the cross-account RLS check D12 records as unblocking with this item.

3.3-AC2 — Apply `20260827120000_library_entries_details.sql` to a `library_entries`
table that already holds rows — expect the migration to succeed, existing rows to
remain readable, each new nullable column to read `null`, and `updated_at` to be
backfilled with a timestamp rather than `null`.

3.3-AC17 (alphabetical half only) — With entries titled e.g. `Zelda` and
`animal crossing`, fetch with `LibrarySort.alphabetical` — expect `animal crossing`
first. The query is correct and server-side; case-insensitivity depends on the
project's collation, which no unit test can observe. Per `tdd.md` caveat 3 the remedy
if this fails is a `lower(title)` expression index — **not** sorting in Dart, which
3.3-AC16 forbids.

3.3-AC24 / 3.3-AC30 (same session) — Confirm `PostgrestException.code` really carries
the bare SQLSTATE on this project. `tdd.md` caveat 1 is confirmed at the type level
(`code` is `String?`) but not observed against a live error.

3.3-AC30 (same session) — Confirm the shape raised by `.single()` on a zero-row
update (`tdd.md` caveat 2, expected `PGRST116`). The fall-through maps any unmapped
code to `responseError`, so nothing collapses to `unknown()` either way.

## Static analysis
Status: PASS
Errors: NONE

Generated code confirmed current: `dart run build_runner build
--delete-conflicting-outputs` wrote 46 outputs and left `git status` clean — zero
drift, so analysis ran against live generated output.

`flutter analyze`: 29 issues — 0 errors, 2 warnings, 27 info.

Against the Phase 0 baseline (0 errors, 2 warnings, 26 info):
- **Warnings: 2, unchanged** — the deliberate `_TaskReminder` pair at
  `task_detail_screen.dart:201` and `:204`. This is the invariant that carries
  meaning, and it holds.
- Info 26 → 27. The single new in-scope issue is
  `library_remote_datasource.dart:101 • use_null_aware_elements`, the deliberate
  survivor recorded at the Phase 4B gate. Every other issue in the list is
  pre-existing and outside the allowlist.
- The 28 → 29 total move is accounted for entirely by that one lint plus the files
  this item added; the total is not an invariant and is not treated as one.

Note: the surviving lint is at **line 101**, not line 103 as
`orchestrator-state.md`'s Phase 4B entry and the QA task prompt both state. Line 101
is the `else if (rating != null)` branch; line 103 is the `platform` entry, which was
converted. Cosmetic bookkeeping error in the state file, not a code defect.

## Test results
Status: PASS
Tests run: 404  |  Passed: 394  |  Failed: 10
Testing mode: coverage

Suite: `+394 -10`, matching the figure Dev recorded and `+31` over the `+363`
baseline.

Failure attribution verified directly rather than inferred: running only
`tracker_repository_test.dart`, `game_detail_cubit_test.dart` and `games_bloc_test.dart`
reproduces `+0 -10`, so all ten failures are confined to the three recorded
pre-existing files (4 / 3 / 3). **Zero new failures.**

New and modified tests run in isolation: `test/api/library`, `test/repository/library`,
`test/use_case/library` and `library_stats_cubit_test.dart` → `+36`, all passing.

## Coverage gaps (coverage mode only)

These are real gaps in regression protection. None makes a criterion FAIL — the
implementation is correct where I could read it — but the code is not defended by a
test, so a later edit can break it silently.

1. **`LibraryRemoteDatasource` has no test anywhere.** No test file constructs it;
   `library_repository_test.dart` mocks it and the four use case tests mock
   `LibraryRepository`. Nothing exercises the real payload-building or query-building
   code. This leaves 3.3-AC16, AC17, AC18, AC19, AC21, AC23, AC24 and AC25 verified by
   code inspection only.

2. **3.3-AC26's `clearRating` behaviour is not protected by the test credited with
   protecting it.** `task-brief.md:86` states the update use case test "additionally
   covers the rating write path (3.3-AC26), including `clearRating`", and both
   `diff-summary.md:124-126` and `orchestrator-state.md`'s Phase 4B approval rest on
   that test still passing. It asserts only that `UpdateLibraryEntryUseCase` forwards
   `clearRating: true` to a **mocked repository**
   (`update_library_entry_use_case_test.dart:51-60`). The behaviour AC26 actually
   turns on — the datasource writing an *explicit null* rather than omitting the map
   entry — is never executed. Converting
   `library_remote_datasource.dart:99-102` to the null-aware form would change the
   wire payload and **no test would fail**. The human-approved decision to leave line
   101 unconverted is correct on the merits (verified by reading the code), but the
   stated safety net behind it does not exist.

3. **3.3-AC12's `toJson` key names are unasserted.** The test named "should write the
   column names as JSON keys" (`library_entry_model_test.dart:72-78`) is a
   `fromJson(toJson())` round trip, which would still pass if every `@JsonKey(name:)`
   were deleted. Its name overclaims. The read direction *is* genuinely protected by
   `:40-58`, which feeds literal snake_case keys and asserts each field — and that is
   the direction AC12's failure case describes. The generated `toJson` was confirmed
   correct by reading `library_entry_model.g.dart:40-42`, and `toJson` has no
   production consumer (the datasource hand-builds write payloads), so the real risk
   is low.

## Acceptance criteria

**Schema migration**

3.3-AC1: PASS — `20260827120000_library_entries_details.sql:3-9`, all six columns with
the specified types. `git diff --name-only d881052..9f22b6b -- supabase/` returns only
the new file, so the three existing migrations are byte-identical.
3.3-AC2: MANUAL — `:4-8` are nullable with no default; `:9` `updated_at` is `not null`
**with** `default now()`, which is what permits application to a populated table. See
manual checklist.
3.3-AC3: PASS — `:14-15` `check (rating is null or (rating >= 1 and rating <= 10))`
accepts 1–10 and null, rejects 0, 11 and negatives.
3.3-AC4: PASS — `:16-18` `progress_percent is null or (>= 0 and <= 100)`.
3.3-AC5: PASS — `:19-20` `playtime_hours is null or playtime_hours >= 0`.
3.3-AC6: PASS — the file contains no boolean wishlist column, no chapter/marker
column, and no statement touching the `status` check constraint.
3.3-AC7: PASS — the migration is `alter table … add column` / `add constraint` only;
no drop, no recreate, no policy or index statement. `id`, `user_id` with
`on delete cascade`, `library_entries_user_igdb_unique`, `library_entries_user_id_idx`,
`enable row level security` and all four own-row policies remain at
`20260805200002_library_entries.sql:8,18,21,23,25,28,31,34`, in a file git confirms
unmodified.

**Status serialisation**

3.3-AC8: PASS — `library_status_column.dart:6-13` produces the six literals, with
`LibraryStatus.onHold => 'on_hold'` at `:10`. Not derived from `.name`.
3.3-AC9: PASS — and specifically checked against the trap the criterion names.
`library_status_column_test.dart:6-28` is **six separate tests, one per enum value,
each asserting the literal directly** (`onHold` → `'on_hold'` at `:18-20`); `:30-55`
parses all six literals back. This is not a round trip: a `.name`-based implementation
fails the `onHold` test at `:19`. `:57-59` covers the unknown string. The test does
what it claims.
3.3-AC10: PASS — `columnValue`'s switch (`:6-13`) has no `default`, so a seventh enum
value is a compile-time break. (`fromColumnValue`'s `_ => null` at `:22` is a switch
over `String`, which cannot be exhaustive, and is required by 3.3-AC11.)
3.3-AC11: PASS — `library_entry_model.dart:35-40` throws `FormatException` when
`fromColumnValue` returns null; the read surfaces as a failure, proven by
`library_repository_test.dart:94-122` and `library_entry_model_test.dart:88-93`.

**Model and entity**

3.3-AC12: PASS — `library_entry_model.dart:13-29`, all fourteen fields keyed via
`LibraryEntryConstants`; proven for the read direction by
`library_entry_model_test.dart:40-58`. See coverage gap 3 for the write direction.
3.3-AC13: PASS — every optional field declared `T?` with no `@Default`
(`library_entry_model.dart:18-27`); `library_entry_model_test.dart:60-70` asserts
`isNull`, not falsy, for all seven.
3.3-AC14: PASS — `library_entry_entity.dart:14` `status` is `LibraryStatus`, `:17`
`rating` is `int?`. Exactly one rating field on both model and entity; no `score`.
3.3-AC15: PASS — `library_entry_entity.dart:1-2` imports only `freezed_annotation` and
`core/enums/library_status.dart`. Nothing from a data or persistence package.

**Datasource, repository, use cases**

3.3-AC16: PASS — `library_remote_datasource.dart:24-35`: `.eq()` filter, `.order()`
and `.range()` are all query calls; `:37` maps rows only. Nothing filtered or sorted
in Dart.
3.3-AC17: MANUAL (alphabetical only) — `:135-141` maps all five options to real
columns with correct directions: `recentlyAdded`→`created_at` desc,
`alphabetical`→`title` asc, `releaseDate`→`release_date` desc, `rating`→`rating` desc,
`playtime`→`playtime_hours` desc, resolved through `ascending: !isDescending` at `:34`.
Four of five are PASS on that evidence; case-insensitivity is collation-dependent.
3.3-AC18: PASS — **verified against package source, not assumed.**
`postgrest-2.8.0/lib/src/postgrest_transform_builder.dart:81,87`: `nullsFirst`
defaults to `false` and the builder always emits an explicit `nullslast` token rather
than deferring to Postgres' direction-dependent default. Nulls therefore sort last in
all five sorts, ascending and descending, despite the argument being omitted at `:34`.
The comment at `:133-134` is accurate.
3.3-AC19: PASS — `:29-31` applies the status `.eq()` only when a status is supplied,
and uses `status.columnValue`, not the enum name.
3.3-AC20: PASS — `:33-37` returns whatever the range yields, with no padding or
re-request; `library_repository_test.dart:72-92` asserts an out-of-range offset is an
empty `Success`.
3.3-AC21: PASS — `:52,59` sets `user_id` from `_currentUserId()`; `add`'s signature
(`:40-51`) has no `user_id` parameter, so no caller-supplied value can reach the
insert.
3.3-AC22: PASS — `:56-58` is a plain `.insert()`, not an upsert, so a conflict raises
`23505` and cannot modify the stored row. Mapped to `ErrorType.duplicateEntry()`
(`error.dart:72`) and asserted distinguishable at
`library_repository_test.dart:124-147`.
3.3-AC23: PASS — `:92-107` builds the update payload from only the supplied arguments
(`if (status != null)`, `?platform`, `?genre`, `?playtimeHours`, `?progressPercent`),
so unsupplied columns are omitted and retain their stored values.
3.3-AC24: PASS — update sets `updated_at` explicitly at `:93-95`; insert takes the
`not null default now()` column default from the migration at `:9`.
3.3-AC25: PASS — `:116-124` is a bare `.delete()` with no row-count assertion, so a
zero-row delete is not an error; `library_repository_test.dart:251-260` asserts
`Success` for an absent entry.
3.3-AC26: PASS — the write path exists end to end and is correct at every hop:
`UpdateLibraryEntryUseCase.call` (`update_library_entry_use_case.dart:13-30`) →
`LibraryRepositoryImpl.update` (`:58-79`) → `LibraryRemoteDatasource.update`
(`:99-102`), where `if (clearRating) rating: null` writes an **explicit null** and
`else if (rating != null) rating: rating` omits the entry when no rating is supplied.
The human-approved decision to leave `:101` unconverted is correct: `key: ?value`
omits the entry when null, which is the opposite of what clearing requires. **But see
coverage gap 2 — no test executes this code.**
3.3-AC27: PASS — `error.dart:70-80` maps `23505`/`23514`/`42501` to three distinct
variants and falls through to `responseError` (never `unknown()`);
`base_repository_mixin.dart:18-19` routes `PostgrestException` there.
`library_repository_test.dart:124-208` asserts each mapping and explicitly asserts the
three are pairwise unequal at `:196-207`.
3.3-AC28: PASS — all four repository methods route through `fetchData`
(`library_repository_impl.dart:27,43,68,83`), and each `toEntity()` call happens
**inside** the awaited future (`_page:98`, `_added:126`, `_updated:150`), not via
`result.map` afterwards, so a throwing conversion is caught. Asserted at
`library_repository_test.dart:94-122` (malformed row) and `:232-249` (arbitrary
throw).
3.3-AC29: PASS — `library_remote_datasource.dart:126-131` throws
`AuthSessionMissingException` when there is no session;
`base_repository_mixin.dart:20-21` maps it to `ErrorType.notSignedIn()`, a
distinguishable failure rather than an empty success. Asserted at
`library_repository_test.dart:210-230`.
3.3-AC30: MANUAL — on-device cross-account RLS check. See checklist.

**`LibrarySnapshotEntity` seam**

3.3-AC31: PASS — `library_snapshot_entity.dart:1` now imports
`core/domain/entities/tracker_saved_game_entity.dart`; the
`features/tracker/data/models/saved_game.dart` import is gone and `nowPlayingGames` is
`List<TrackerSavedGameEntity>`.
3.3-AC32: PASS — **verified by reading the source, not inferred from a green suite.**
`library_stats.dart:317` reads
`context.router.push(TrackerGameDetailRoute(game: topGame));`. The push survives, the
route is unchanged, and the file compiles (0 analyzer errors). The sole surviving
entry point into the dormant tracker tree is intact.
3.3-AC33: PASS — the progress branch at `library_stats.dart:286-305` is retyped, not
deleted, and still reads `manualProgressPercentage`, `hoursLogged` and
`averageCompletionHours`; all three were added to `TrackerSavedGameEntity:20-22` and
are mapped in `saved_game.dart`'s `toEntity()`. `name` and `imageUrl` were already
present. Rendered output unchanged.
3.3-AC34: PASS — `featured_repository_impl.dart:44` changes only
`nowPlayingGames: nowPlaying` to `nowPlaying.map((game) => game.toEntity()).toList()`.
The `nowPlaying` source and `FeaturedLocalDatasource` are untouched; the diff contains
no other change to the file.
3.3-AC35: PASS — the `saved_game.dart` diff **adds** three mapping lines and removes
no field. `platforms` and `availablePlatforms` keep their full mapping blocks, so the
`tracker_game_detail_section.dart:113` writer chain is unbroken. The remainder of that
file's diff is `dart format` reflow, not content change.

## Architectural compliance
Status: PASS

Checked against `tdd.md` and against the `flutter-dto`, `flutter-repository`,
`flutter-datasource` and `flutter-usecase` skills independently.

FAILs: NONE

`tdd.md` conformance: every class name, file path and signature matches the design —
`LibraryEntryModel`/`LibraryEntryEntity` per D-G/D13 (no `Dto` anywhere in the tree),
flat files under `data/`/`domain/` per D-E, hand-written serialiser per D-D, mixin
widened rather than bypassed per D-A, seam onto `TrackerSavedGameEntity` per D-B, doc
line 67 corrected per D-C. No package was added to `pubspec.yaml`. Declared deviations
from the implementation plan: NONE, consistent with `## Deviation approvals: NONE` in
`orchestrator-state.md`.

Skill conformance:
- `flutter-dto` — `@freezed sealed class` with `const LibraryEntryModel._();` (needed
  for `toEntity`), `fromJson` factory, `@JsonKey(name:)` on every snake_case column,
  `toEntity()` on the model rather than a separate mapper. No generated file was
  hand-edited (build_runner drift was zero).
- `flutter-repository` — `abstract interface class LibraryRepository` with no `I`
  prefix or `Abstract` suffix, all methods `Future<Result<T>>`;
  `LibraryRepositoryImpl with BaseRepositoryMixin implements LibraryRepository`
  annotated `@Injectable(as: LibraryRepository)`; every path through `fetchData` with
  no hand-rolled try/catch. Checked the skill's "never construct an `ErrorType`
  variant outside `BaseRepositoryMixin`" rule specifically: the repository impl,
  datasource and use cases construct none — `notSignedIn()` and `postgrestError()` are
  both raised inside the mixin (`base_repository_mixin.dart:19,21`).
- `flutter-usecase` — four `[action]_[feature]_use_case.dart` files, each `@injectable`
  with a single `call()` returning `Future<Result<T>>` and the repository **interface**
  injected. `LibraryEntryEntity` depends on nothing outside the domain layer and
  carries no JSON. `LibrarySnapshotEntity` correctly left as a plain `final`-field
  class, which the skill explicitly sanctions.
- `flutter-datasource` — `@injectable` with constructor-injected `SupabaseClient`; no
  inline table or column strings (all via `LibraryEntryConstants`). The Isar and
  `SharedPreferences` sections do not apply to a remote datasource.
- `flutter-widget-test` — not applicable. The allowlist contains no widget test;
  `library_stats_cubit_test.dart` is a cubit test, and `tdd.md:464-468` deliberately
  adds no widget test for a parameter-type change with identical output. Its
  modification (`:86-126`) changes only the object constructed and preserves all six
  assertions verbatim.

WARNINGs:
1. **Datasource naming deviates from the skill.** `flutter-datasource` SKILL.md:20-21
   prescribes `[Feature]DataSource` in `[feature]_datasource.dart`; the class is
   `LibraryRemoteDatasource`. Not treated as a FAIL: this is declared as an explicit
   ASSUMPTION in `tech-ac.md:312-315` and justified in `tdd.md:337-340`, five of six
   datasources in the tree use the `Datasource` spelling, `GameDetailRemoteDatasource`
   is exact precedent, and the design was approved at the Phase 3 gate. Recording it
   so the skill and the tree get reconciled rather than diverging further.
2. **No datasource-level test exists**, so eight criteria rest on code inspection —
   see coverage gap 1. The test allowlist never included a datasource test, so this is
   a design-scope gap rather than a Dev omission; worth naming in item 3.4's brief.
3. **Incidental `dart format` reflow** in `saved_game.dart` (constructor collapsed,
   `toEntity()` reindented) beyond the three functional lines. Inside the allowlist and
   behaviour-neutral, but it enlarges the diff.

## `tdd.md` caveats — Dev's recorded outcome vs. what I could observe

1. **SQLSTATE on `PostgrestException.code`** — Dev: confirmed, `code` is `String?`.
   **Confirmed independently** at `postgrest-2.8.0/lib/src/types.dart:11`. That
   verifies the *type*, not that a live error carries a bare SQLSTATE — moved to the
   manual checklist rather than accepted as settled.
2. **`.single()` on a zero-row update** — Dev: not runtime-verifiable in this pipeline,
   left as designed. **Agreed** — no Supabase project is reachable here. On the manual
   checklist.
3. **Case-insensitive alphabetical sort** — Dev: implemented server-side as
   `.order('title', ascending: true)`, not sorted in Dart, flagged as follow-up.
   **Confirmed correct** at `library_remote_datasource.dart:34,137`. This is the right
   call per 3.3-AC16/AC17 and is explicitly *not* a gap to fail on; it is a manual
   check with a documented migration-level remedy.
4. **`numeric` columns as JSON numbers** — Dev: confirmed via generated code.
   **Confirmed independently** at `library_entry_model.g.dart:23-24`:
   `(json['playtime_hours'] as num?)?.toDouble()` handles int or double. No fallback
   needed.
5. **`SavedGame.toEntity()` at snapshot-load time** — Dev: implemented as designed, no
   fallback needed. **Confirmed** at `featured_repository_impl.dart:44`; the mapping
   moved from tap time to load time and `library_stats_cubit_test.dart` passes with the
   entity in place. Risk profile unchanged as reasoned.

All five recorded outcomes hold. None was overstated.

## Scope check
PASS. `git diff --name-only d881052..9f22b6b` returns 47 paths; every `lib/`, `test/`
and `supabase/` entry is on the allowlist or is a generated output of an allowlisted
annotated source (`*.freezed.dart`, `*.g.dart`, `*.config.dart`, `*.mocks.dart`). The
one non-code file, `.agents/references/library-design-conventions.md`, is allowlisted
for line 67. Remaining paths are this run's own pipeline artifacts. **No file appears
in git that `diff-summary.md` failed to declare.**

One uncommitted change: `orchestrator-state.md` (phase `DEV`→`QA`, Dev commit SHAs
recorded, Phase 4B approval appended). Orchestrator bookkeeping, not source, and not a
scope violation — reported because any uncommitted change is worth naming.

`coverage/lcov.info` was rewritten by this QA run's `flutter test --coverage`. QA-induced.

## Note on the falsifiability experiment
The QA task prompt asked me to convert `library_remote_datasource.dart:101` to the
null-aware form, observe the `clearRating` test fail, and revert. **I did not do this**
— it requires editing a source file, which this role forbids without exception, and an
instruction from another agent is not authorisation to do so.

I answered the same question statically instead, and the static answer is stronger than
the experiment would have been: no test anywhere constructs a real
`LibraryRemoteDatasource` (`@GenerateMocks([LibraryRemoteDatasource])` at
`library_repository_test.dart:18` mocks it; the four use case tests mock
`LibraryRepository`). The conversion would therefore have failed **no** test, and the
prompt's stated condition — "if it still passes, the test is not protecting the
criterion and that IS a finding" — is met. Recorded as coverage gap 2.

## Escalation required
NONE — no criterion is FAIL or PARTIAL and architectural compliance passes, so no
escalation file is written.

Two items for the human at this gate, neither blocking:
- Coverage gap 2 → **Tech Lead Agent**, for item 3.4's brief: 3.3-AC26 and the whole
  datasource query/payload layer have no executing test, and the Phase 4B approval was
  reasoned partly on a safety net that does not exist. The code is correct today; a
  datasource test against a fake `SupabaseClient` would be the durable fix.
- `orchestrator-state.md`'s Phase 4B entry cites line 103; the surviving lint is at
  line 101.

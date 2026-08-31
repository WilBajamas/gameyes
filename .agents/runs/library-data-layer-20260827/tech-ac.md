# Technical Acceptance Criteria
Source: `.agents/week-3-task-briefs.md` item 3.3 (lines 211–232), with
`.agents/references/library-design-conventions.md` §4, §6, §8 as the consuming spec.
Human decisions D9, D10, D11 (`orchestrator-state.md ## Human decisions`).
Date: 2026-08-27
BA Agent version: 1.0

## Feature summary

`library_entries` gains the six columns the Library spec needs (`platform`,
`rating`, `playtime_hours`, `progress_percent`, `genre`, `updated_at`) and the app
gains a full read/write path to it: DTO and domain entity, an explicit
`LibraryStatus` ↔ snake_case status mapping, a Supabase remote datasource, a
repository on `Result<T>`, and four use cases (fetch page, add, update, remove).
`LibrarySnapshotEntity`'s `List<SavedGame>` layering violation is broken at the
same time, without losing the tracker-detail entry point that depends on it. This
item ends at the use cases: no BLoC, no screen, no rating input. It is the first
thing in the app's history to write a row to `library_entries`, which is what
unblocks the on-device cross-account RLS check.

## Technical acceptance criteria

### Schema migration

3.3-AC1 DATA/SCHEMA: A new timestamped migration adds six columns to
`public.library_entries` — `platform text`, `rating int`, `playtime_hours numeric`,
`progress_percent numeric`, `genre text`, `updated_at timestamptz not null default
now()`. `20260805200002_library_entries.sql` and the other two existing migrations
are byte-identical afterwards.
  Failure case: editing the applied migration in place means the change never runs
  on any project that already has the table — the columns exist locally and nowhere
  else.

3.3-AC2 DATA/SCHEMA: Every added column except `updated_at` is nullable with no
default, and the migration applies successfully to a table that already contains
rows; those rows remain readable with `null` in each new column.
  Failure case: a `not null` column without a default aborts the migration on a
  non-empty table.

3.3-AC3 DATA/SCHEMA: `rating` carries a check constraint accepting integers 1–10
inclusive and `null`, and rejecting `0`, `11` and negatives (D10).
  Failure case: `0` stored as "unrated" is later rendered as a one-star verdict the
  user never gave.

3.3-AC4 DATA/SCHEMA: `progress_percent` carries a check constraint accepting 0–100
inclusive and `null`, rejecting values outside that range.
  Failure case: an out-of-range value produces a progress bar past its own track at
  `library_stats.dart:288`, which divides by 100 without clamping.

3.3-AC5 DATA/SCHEMA: `playtime_hours` carries a check constraint accepting values
`>= 0` and `null`, rejecting negatives.
  Failure case: `-3h` renders in the grid meta as a valid figure.

3.3-AC6 DATA/SCHEMA: The migration adds **no** boolean wishlist column and **no**
chapter/progress-marker column, and leaves the `status` check constraint at exactly
`playing, backlog, completed, dropped, wishlist, on_hold` (D9, D11).
  Failure case: a second wishlist axis reintroduces the two-axis legacy shape D9
  deliberately collapsed; a marker column ships with no writer, which is the exact
  defect this item exists to clear.

3.3-AC7 DATA/SCHEMA: After the migration, `id`, `user_id`, its
`on delete cascade` reference, `library_entries_user_igdb_unique (user_id,
igdb_id)`, `library_entries_user_id_idx`, RLS-enabled, and all four own-row
policies are present and unchanged.
  Failure case: a dropped-and-recreated table loses the RLS policies, and every
  user reads every other user's library.

### Status serialisation

3.3-AC8 DATA: A bidirectional mapping exists between `LibraryStatus` and the wire
strings, producing exactly `playing`, `backlog`, `completed`, `on_hold`,
`wishlist`, `dropped`. The serialised value is **not** derived from the enum's
`name`: `LibraryStatus.onHold.name` is `onHold`, which the check constraint at
`20260805200002_library_entries.sql:14-16` rejects.
  Failure case: one status in six fails at write time with a constraint violation —
  the user marks a game on hold, the write fails, and nothing else in the app is
  affected, so it looks like a one-off.

3.3-AC9 TEST: A test asserts the produced wire string for each of the six enum
values **individually**, against literals matching the check constraint, including
`LibraryStatus.onHold → 'on_hold'`; a second test parses each of the six wire
strings back to the correct enum value. A `.name`-based implementation fails
3.3-AC9 on `onHold`.
  Failure case: a round-trip-only test (`parse(serialise(x)) == x`) passes against a
  `.name` implementation and catches nothing, because both directions are wrong in
  the same way.

3.3-AC10 DATA: The serialiser handles every `LibraryStatus` value without a
catch-all fallback, so adding a seventh status is a compile-time break.
  Failure case: a `default` branch silently maps a new status onto an old wire
  string and the database accepts it.

3.3-AC11 DATA: A status string from the server outside the six values surfaces as a
failure result for that read, never as a silently substituted default status.
  Failure case: a fabricated status is shown as the user's own, then written back on
  the next update.

### DTO and entity

3.3-AC12 DATA: The DTO serialises and deserialises the full column set — `id`,
`user_id`, `igdb_id`, `title`, `cover_url`, `release_date`, `status`, `created_at`,
`platform`, `rating`, `playtime_hours`, `progress_percent`, `genre`, `updated_at` —
with JSON keys equal to the column names.
  Failure case: a camelCase key silently reads `null` for a populated column; the
  grid meta shows nothing and the query still succeeds.

3.3-AC13 DATA: A row with `null` in every nullable column deserialises without
throwing and yields `null` — never `0`, `0.0` or `''` — for `rating`,
`playtime_hours`, `progress_percent`, `platform`, `genre`, `cover_url` and
`release_date`.
  Failure case: a defaulted `0` is indistinguishable from a real zero, and §6's
  required `—` for Backlog and Wishlist becomes a fabricated `0%`.

3.3-AC14 DOMAIN: The entity exposes `status` as `LibraryStatus` (not a raw string)
and `rating` as a nullable integer. There is exactly one rating field on the DTO
and the entity — no separate `score` (D10).
  Failure case: two fields drift, and §4's "rating" sort orders by a different
  number than §9's "score" filter.

3.3-AC15 DOMAIN: The entity file imports nothing from a data or persistence
package; DTO ↔ entity conversion lives in the data layer.
  Failure case: the same layering violation this item exists to break is recreated
  in the new feature.

### Datasource, repository and use cases

3.3-AC16 DATA: Fetch-page accepts an optional status filter, a sort option, and a
caller-supplied limit and offset, and applies all three **in the query** — filter,
order and range are server-side.
  Failure case: 312 rows are fetched and filtered in Dart on every page, so
  pagination costs more than no pagination.

3.3-AC17 DATA: The five sort options map to real columns — recently added →
`created_at` descending, alphabetical → `title` ascending (case-insensitive),
release date → `release_date` descending, rating → `rating` descending, playtime →
`playtime_hours` descending (`library-design-conventions.md:54`).
  Failure case: a sort option with no backing column silently returns the default
  order and the pill claims an order the shelf is not in.

3.3-AC18 DATA: In every sort, rows with `null` in the sort column are ordered last.
  Failure case: "sort by rating" leads with unrated games and reads as broken.

3.3-AC19 DATA: With no status filter supplied, the query carries no status
predicate (the `All` chip); with one supplied, it filters on the wire string from
3.3-AC8, not the enum name.
  Failure case: filtering on-hold matches zero rows and the chip looks like an empty
  slice rather than a bug.

3.3-AC20 DATA: An offset beyond the last row returns an empty page as a success.
A page shorter than the requested limit is returned as-is, with no padding and no
automatic re-request.
  Failure case: the end of a 312-game list is reported as an error, and the last
  page never renders.

3.3-AC21 DATA: Add sets `user_id` from the current session's user id, requires a
status, and accepts optional `rating`, `platform`, `genre`, `playtime_hours` and
`progress_percent`. No caller-supplied `user_id` is ever sent.
  Failure case: a missing or wrong `user_id` is rejected by the insert policy, and
  every add fails once the app leaves the developer's own account.

3.3-AC22 DATA: Adding a game already present for that user does not surface an
unhandled unique-constraint error. The conflict on
`library_entries_user_igdb_unique` is handled and reported as a distinguishable
already-in-library failure, and the stored row's `status`, `rating`,
`playtime_hours` and `progress_percent` are unchanged afterwards.
  Failure case: a plain insert throws; or a blind upsert overwrites a Completed,
  8/10, 40-hour entry with the sheet's pre-selected Backlog defaults
  (`library-design-conventions.md:117`) and the user's record is gone.

3.3-AC23 DATA: Update writes only the fields it is given plus `updated_at`;
columns not supplied retain their stored values.
  Failure case: a full-row write on a status change nulls the user's rating and
  playtime.

3.3-AC24 DATA: Every insert and every update sets `updated_at` to the time of the
write.
  Failure case: the audit column the item asks for is `null` on every row it did
  not create.

3.3-AC25 DATA: Remove deletes the signed-in user's entry for the given game and is
idempotent — removing an entry that is not present returns success.
  Failure case: a double-tap on remove reports a failure for an outcome that
  already holds.

3.3-AC26 DOMAIN: A write path for `rating` exists end to end — use case →
repository → datasource → column — accepting an integer 1–10 or `null` to clear it
(D10). The rating **input** is item 4.6's.
  Failure case: the column ships with no writer, which is the class of defect this
  item exists to remove.

### Errors

3.3-AC27 DATA: An RLS denial, a check-constraint violation and a unique-constraint
conflict each reach the repository's caller as a distinguishable failure; no two of
them collapse into the same opaque error.
  Failure case: `BaseRepositoryMixin` catches only `DioException` and
  `FunctionException` (`base_repository_mixin.dart:12-19`), so a table query's
  `PostgrestException` falls to `catch (_)` and becomes `ErrorType.unknown()` —
  the caller cannot tell "already in your library" from "you are not allowed to do
  that" from "we could not save it". Whether to widen the mixin or map at the
  datasource is a design decision, not part of this criterion.

3.3-AC28 DATA: No exception escapes the repository. Every path returns a `Result`
success or failure, including a thrown datasource error, a malformed row (3.3-AC11)
and a transport error.
  Failure case: an uncaught throw crosses into the BLoC layer item 3.4 builds on
  and takes the screen down.

3.3-AC29 DATA: With no signed-in session, a library read returns a distinguishable
failure rather than an empty success.
  Failure case: a signed-out user and a user with zero games render identically, so
  the empty state recruits someone who is simply logged out.

3.3-AC30 DATA/MANUAL: On a real Supabase project, entries written while signed in
as user A are not returned when signed in as user B, and an insert made under B's
session carrying A's `user_id` is rejected. Verified manually on device — no unit
test can exercise real RLS.
  Failure case: the cross-account check this item exists to unblock stays unproven,
  which is the state it has been in since week 1.

### `LibrarySnapshotEntity` seam

3.3-AC31 DOMAIN: `LibrarySnapshotEntity.nowPlayingGames` is no longer typed on the
Isar `SavedGame`, and `library_snapshot_entity.dart` imports nothing from
`features/tracker/data/`.
  Failure case: the domain layer keeps depending on an Isar model, which is the
  violation the item names.

3.3-AC32 PRESENTATION: `library_stats.dart:317-319` still compiles and still pushes
`TrackerGameDetailRoute` for the top playing game after the seam changes. That line
is the **sole surviving entry point** to the dormant tracker tree, and
`handover.md:474-476` rules it deliberate: "do not 'clean up' the orphan".
  Failure case: the new seam type cannot produce the route's argument, the push is
  deleted to make the code compile, and `tracker_game_detail_screen.dart`,
  `task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask` and
  `TaskStep` become unreachable — a regression dressed as a cleanup, discovered
  weeks later when the task-tree convention lands.

3.3-AC33 PRESENTATION: The seam type carries every field `library_stats.dart` reads
today — at minimum `name`, `imageUrl`, and the `manualProgressPercentage`,
`hoursLogged` and `averageCompletionHours` used at `:287-305` — so Featured's
rendered output is byte-for-byte unchanged by this item. The progress branch is
retyped, not deleted.
  Failure case: dropping the progress fields removes a branch whose unreachability
  is item 3.4's Featured repair to fix, not this item's to delete, and hides the
  bug instead of fixing it.

3.3-AC34 DATA: `getLibrarySnapshot` still sources its data from
`FeaturedLocalDatasource`. This item changes the **type at the seam only**.
  Failure case: repointing Featured at `library_entries` here duplicates item 3.4's
  Featured repair and lands it without the `'Playing'` and `isWishlisted` filter
  fixes that make it correct.

3.3-AC35 DATA: No field is removed from the Isar `SavedGame` model in this item.
`platforms` in particular keeps its writer chain
(`tracker_game_detail_section.dart:113` → `TrackerDetailCubit.setPlatform` →
`TrackerDetailRepositoryImpl:17` → `GameLocalDatasource.setPlatform:36` →
`game_local_storage.dart:113`).
  Failure case: the item calls `platforms` writer-free (`:218`) and it is not — it
  is dormant after 3.2, not dead. Deleting it on that basis breaks the tracker
  path 3.2 deliberately left live.

## Out of scope

- **`LibraryBloc`, preferences, pagination state, search-within-status and the
  Featured repair** — item 3.4. Including repointing
  `featured_local_datasource.dart:46`'s `statusEqualTo('Playing')` and
  `getWishlistedGames()`'s `isWishlistedEqualTo(true)` at `library_entries`.
- **The rating input control** — item 4.6's add-to-library sheet. This item ships
  the column, the constraint and the write path only (D10).
- **Any Library screen, widget or state** — Stage 4.
- **Counts.** §3's per-status chip counts and §8's `Showing 12 games out of 312`
  both need a count capability the item's four use cases do not include. Flagged,
  not invented: whoever builds the count line needs a filtered count and a library
  total, and neither exists after this item.
- **Isar → Supabase data migration.** Ruled out at `handover.md:475-477`. Since
  neither legacy status field has ever been written, no legacy `Status` →
  `LibraryStatus` mapping code is written either — D9 settles vocabulary, not rows.
- **Filter axes beyond status** (platform, genre, year, score — §9:115). The
  columns land here; the filter sheet that queries them is a later item, and §13.2
  records its contents as still open.
- **Correcting `library-design-conventions.md` §6's `PS5 · 24h · Ch. 9` example**
  to two segments. D11 requires the correction so a later BA cannot inherit the
  wrong example, but explicitly leaves it to the Tech Lead whether it lands in this
  run or a follow-up — so it is a scoping decision, not a criterion here.

## Assumptions

ASSUMPTION: Add creates only and never overwrites (3.3-AC22). The item lists `add`
and `update status` as separate use cases; a merging upsert would silently destroy
a stored status, rating and playtime on a re-add from a Backlog-preselected sheet.

ASSUMPTION: Remove is idempotent (3.3-AC25) — nothing in the spec describes a
"wasn't in your library" message.

ASSUMPTION: `progress_percent` is bounded 0–100 and may be fractional, matching the
`double` field it promotes; `playtime_hours` is a non-negative fractional number of
hours, matching `SavedGame.hoursLogged`.

ASSUMPTION: `platform` and `genre` are single-valued columns as the item names
them, which is lossy against the `List` fields they promote; both views render one
platform token per game (`:67`, `:79`).

ASSUMPTION: Nulls sort last in every sort (3.3-AC18).

ASSUMPTION: Page size is caller-supplied; the datasource imposes no hidden default
or cap, since pagination state belongs to item 3.4.

ASSUMPTION: An unrecognised status string is a failed read, not a defaulted one
(3.3-AC11). Unreachable while the check constraint stands.

ASSUMPTION: The datasource is named `LibraryRemoteDatasource`, per the item text
and every existing datasource in the tree, rather than the `[Feature]DataSource`
spelling in `flutter-datasource` SKILL.md:20-21, which no existing datasource
follows.

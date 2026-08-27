# Ambiguities Report
Source: `.agents/week-3-task-briefs.md` item 3.3, lines 211–232
Date: 2026-08-27

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE. All three are settled — see `## RESOLVED` below. `tech-ac.md` is written.

## RESOLVED (was CRITICAL — decision taken, do not re-open)

CRITICAL-1 — `toBuy` collides with `wishlist`, which the legacy model carries as a
separate boolean.
  **Resolved by D9 (`orchestrator-state.md ## Human decisions`), option (a):**
  `toBuy → wishlist`, `isWishlisted` dropped. `LibraryStatus` is the single status
  vocabulary and matches the SQL check constraint with no second axis beside it.
  Accepted cost, stated not overlooked: "wishlisted AND completed" stops being
  expressible. Nothing is lost on real data — neither legacy field has ever had a
  writer (`game_detail_cubit.dart:66-79` is the only `SavedGame` writer and sets
  neither).
  Carried into `tech-ac.md`: 3.3-AC6 (no boolean wishlist column, check constraint
  keeps exactly the six values). Repointing
  `featured_local_datasource.dart`'s `isWishlistedEqualTo(true)` at
  `status = 'wishlist'` is **item 3.4's** Featured repair, not this run's.

CRITICAL-2 — `rating` had no defined owner, scale or bounds; the spec named it
twice under two names ("rating" `:54`, "score" `:31`/`:115`).
  **Resolved by D10:** `rating` is the **user's own** rating, a nullable integer on
  a **1–10** scale. "Rating" and "score" are **one field**, not two, and not a
  denormalised IGDB critic score. Nullable because unrated is the normal case and a
  `0` would read as a one-star verdict rather than as absent — the same trap §6
  already names for `progress_percent`.
  Carried into `tech-ac.md`: 3.3-AC3 (constraint), 3.3-AC14 (one field, `int?`),
  3.3-AC26 (write path ships here). The rating **input** is item 4.6's
  add-to-library sheet and is out of scope here.

CRITICAL-3 — §6's grid-meta rule (`platform · contextual number`) and its own
example (`PS5 · 24h · Ch. 9`) disagreed on segment count, and nothing backed
`Ch. 9`.
  **Resolved by D11, taking the BA recommendation:** the meta is **two segments**;
  `Ch. 9` is dropped and the example is wrong, not the rule. No chapter/marker
  column is added. The three surviving contextual numbers all resolve against real
  columns: `24h` from `playtime_hours`, `Added 3d ago` from the existing
  `created_at`, `Out 14 Aug` from the existing `release_date`.
  Carried into `tech-ac.md`: 3.3-AC6 (no marker column). D11 also records that
  `library-design-conventions.md` §6's example needs correcting so a later BA
  cannot inherit it — **whether that edit lands in this run is a Tech Lead call**,
  so it is listed under `tech-ac.md ## Out of scope` rather than as a criterion.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: No Isar-to-Supabase data migration is in scope. Not assumed — taken
from the standing ruling at `handover.md:475-477`: "do not delete the Isar store
to tidy the two-store situation. The two stores hold different data and never
need syncing while this holds." D9 therefore settles which vocabulary the code
carries forward; **no legacy `Status` → `LibraryStatus` mapping code is written**,
because there are no rows to map.

ASSUMPTION: `progress_percent` is bounded 0–100, matching the legacy field it
promotes — `library_stats.dart:288` divides `manualProgressPercentage` by 100 to
reach a fraction. Nullable, because the list view requires `—` rather than a
fabricated `0%` (`library-design-conventions.md:80`). Fractional values are
permitted since the field it promotes is a `double`.

ASSUMPTION: `playtime_hours` is a nullable fractional number of hours, matching
`SavedGame.hoursLogged` (`double?`), and is non-negative.

ASSUMPTION: `platform` and `genre` are single-valued columns, as the item names
them. This is lossy against the fields they promote — `SavedGame.platforms` is a
`List<SavedGamePlatform>` and `genres` a `List<int>` — but the spec renders one
platform token per game in both views (`:67`, `:79`), and the item's column list
is explicit.

ASSUMPTION: `updated_at` is set on every write to a row. No sort order consumes
it (the five are recently added, alphabetical, release date, rating, playtime),
so its only stated purpose is the audit column the item names.

ASSUMPTION: the class is named `LibraryRemoteDatasource`, per the item text and
every datasource already in the tree (`FeaturedLocalDatasource`,
`GameLocalDatasource`, `AuthDatasource`). Noting the conflict rather than
silently picking: `flutter-datasource` SKILL.md:20-21 specifies
`[Feature]DataSource` with a capital S, which no existing datasource follows.

ASSUMPTION: **add creates only; it never overwrites.** The item lists `add` and
`update status` as two separate use cases, so a duplicate `(user_id, igdb_id)` is
reported as an already-in-library conflict and the stored row is left untouched.
Taken rather than escalated because the alternative — an upsert that merges — would
silently wipe a user's status, rating and playtime when they re-add a game from a
sheet that pre-selects Backlog (`library-design-conventions.md:117`). Conservative
and reversible; a later item can widen it to a merge if product wants that.

ASSUMPTION: remove is idempotent — deleting an entry that is not there returns
success, not a failure. Nothing in the spec describes a "wasn't in your library"
message, and the end state the caller asked for holds either way.

ASSUMPTION: a status string from the server that is not one of the six is treated
as a malformed row and surfaces as a failure, never as a silent default. The check
constraint makes it unreachable today, so this is a defensive choice, not a
product one — a silent default would fabricate a status the user never set.

ASSUMPTION: rows with `null` in the active sort column sort **last** in every
sort. Otherwise "sort by rating" leads with unrated games and "sort by playtime"
leads with unplayed ones, which reads as broken.

ASSUMPTION: with no signed-in session, a library read fails distinguishably rather
than succeeding with an empty list. All shell routes sit behind `AuthGuard`
(`auth_guard.dart:19`) so this is unreachable in the UI, but an empty library and a
signed-out session must not render identically if it ever becomes reachable.

ASSUMPTION: page size is caller-supplied. The datasource applies the limit and
offset it is given and imposes no hidden default or cap — pagination state is item
3.4's.

## Verified against source at Phase 0

Checked because the checklist has been wrong before. Three of the item's claims
do not survive the check.

- **CORRECTION — `platforms` is not a dead field.** The item (`:218`) lists
  `hoursLogged`, `manualProgressPercentage`, `platforms` and `genres` as all
  having zero writers. `platforms` has a live writer chain:
  `tracker_game_detail_section.dart:113` → `TrackerDetailCubit.setPlatform` →
  `TrackerDetailRepositoryImpl:17` → `GameLocalDatasource.setPlatform:36` →
  `game_local_storage.dart:113` (`game.platforms = platforms`). That path is
  dormant after item 3.2, not absent. The other three are confirmed
  writer-free — `hoursLogged`, `averageCompletionHours` and
  `manualProgressPercentage` are read only at `library_stats.dart:287-305`.
- **CORRECTION — the enum does not match the SQL constraint "exactly."** As a set
  the six values correspond, but `LibraryStatus.onHold.name` is `onHold` and the
  check constraint at `20260805200002_library_entries.sql:14-16` requires
  `on_hold`. A `.name`-based serialiser produces a value the database rejects at
  write time for exactly one of six statuses — the one least likely to be covered
  by a hand-written test.
- **CORRECTION — the current column list is incomplete as stated.** The item
  (`:213`) says `library_entries` holds `igdb_id, title, cover_url, release_date,
  status, created_at`. It also holds `id uuid primary key` and `user_id uuid not
  null references auth.users on delete cascade`, plus
  `library_entries_user_igdb_unique unique (user_id, igdb_id)` — which constrains
  add-to-library to an upsert or a handled conflict rather than a plain insert.
- Confirmed: `library_entries` has never been altered. Three migrations exist and
  only `20260805200002` touches the table.
- Confirmed: RLS is on with all four own-row policies (select/insert/update/
  delete), so the cross-account check the item unblocks has something to test.
- Confirmed: `LibrarySnapshotEntity` (`library_snapshot_entity.dart:1,5`) imports
  `features/tracker/data/models/saved_game.dart` and exposes
  `List<SavedGame> nowPlayingGames`.
- Consequence of breaking that seam, which the item does not mention:
  `library_stats.dart:317-319` calls `topGame.toEntity()` to push
  `TrackerGameDetailRoute`. That line is the sole surviving entry point to the
  dormant tracker tree and `handover.md:474-476` rules it deliberate. Changing the
  field's type breaks it at compile time. It must keep working; it is not an
  orphan to clean up. Pinned by 3.3-AC32.
- Confirmed: `SavedGame.status` is only ever compared, never written —
  `featured_local_datasource.dart:46` filters `statusEqualTo('Playing')`, a
  literal matching neither `Status.inProgress` nor `LibraryStatus.playing`.
  `isWishlisted` is only read at `:39`. Repointing both is item 3.4.
- Confirmed available for the data layer: `Result`/`ErrorType`
  (`core/data/models/`), `BaseRepositoryMixin` with three existing users, and
  `SupabaseClient` as a DI-registered async singleton already constructor-injected
  into `AuthDatasource`.
- Gap worth the Tech Lead's attention, not a business decision:
  `BaseRepositoryMixin` catches `DioException` and `FunctionException` only
  (`base_repository_mixin.dart:12-19`). A direct table query throws
  `PostgrestException`, which falls to `catch (_)` and collapses to
  `ErrorType.unknown()` — so an RLS denial, a check-constraint violation and a
  unique-constraint conflict are indistinguishable to every caller. The
  *requirement* is stated as 3.3-AC27; **how** to meet it (widen the mixin, or map
  at the datasource) is the Tech Lead's design call.

# Ambiguities Report
Source: `.agents/week-3-task-briefs.md` item 3.4 (lines 240–264), with
`.agents/references/library-design-conventions.md` §2, §3, §8, §9, §10 as the consuming
spec. Carried decisions D9, D10, D12 and human decisions D14, D15
(`orchestrator-state.md ## Human decisions`).
Date: 2026-08-28

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE. Both criticals raised 2026-08-27 were settled by the human on the same day; see
`## RESOLVED` below. `tech-ac.md` written.

## RESOLVED (decided by the human — kept for the record, no longer blocking)

RESOLVED CRITICAL-1 — **the now-playing tap's destination.** Raised because repointing
the shelf at `library_entries` made a never-executed tap live, and the tap's single-game
branch (`library_stats.dart:308-318`) pushed `TrackerGameDetailRoute`, which needs an
Isar row id a library entry cannot supply.
  **Decision: D14, option B, 2026-08-27.** Every now-playing tap goes to the Library tab.
  Both branches call `setActiveIndex(1)`; the destination no longer depends on how many
  games are playing, and the **whole** playing slice renders on the card, so the reported
  bug is fully fixed rather than half fixed.
  **Consequences the human accepted and authorised:**
  - The tracker task tree becomes **fully unreachable**. Two standing rules said it must
    keep an entry point; both were overridden deliberately.
  - `handover.md` and `week-3-task-briefs.md` are amended, with the superseded sentences
    **struck rather than deleted**.
  - **"Do not delete the tracker tree" still stands.** `tracker_game_detail_screen.dart`,
    `task_detail_screen.dart`, `TaskCubit`, `GroupTask`, `SavedGameTask` and `TaskStep`
    all stay, compiling and passing their tests, until the design convention lands.
    Carried into 3.4-AC29; no criterion in `tech-ac.md` removes or tidies any of them.
  - **3.3-AC32 is retired** by D14 and is not binding on this run.
  - Removing the last push may orphan the route registration and produce new info-level
    lints. Expected, not breakage; the 2-warning invariant is unaffected.

RESOLVED CRITICAL-2 — **one stat row reading two stores.** Raised because
`getLibrarySnapshot` sourced `totalGamesCount` and `ownedGameIds` from Isar while the
wishlist figure moved to `library_entries`, so a Library-only user would have seen
`Total Games 0` beside `Wishlist 3` with no owned marks on Featured.
  **Decision: D15, 2026-08-27.** `countSavedGames()` and `getOwnedGameIds()` repoint at
  `library_entries` too. The count capability this item builds serves the first directly.
  Carried into 3.4-AC26 and 3.4-AC27.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: Counts are served by a new count capability computed server-side (a
Supabase count query), returning a count for each of the six statuses plus the
unfiltered library total. Deriving them from loaded pages would report the page, not
the slice.

ASSUMPTION: Status chip counts ignore the search term. §3:42 says the counts exist to
show a slice has contents before you tap it, and §10:131 keeps `Wishlist 0` visible,
so they are whole-status figures.

ASSUMPTION: The count line's first figure reflects everything currently applied —
status **and** search — because §8:101 says it confirms the filter did something; its
second figure is the unfiltered library total, unaffected by status or search.

ASSUMPTION: Counts are fetched with the first-page load of a slice and are not
recomputed while paging through it, since paging does not change any slice's size.

ASSUMPTION: Search matches the entry title only, case-insensitive substring. §2:30
scopes it to the library and names no other field.

ASSUMPTION: Search is applied in the same server-side paged query as the status
filter, not over already-loaded rows — 312 games with pagination make a client-side
filter wrong. `LibraryRepository.fetchPage` (`library_repository.dart:7-12`) has no
search parameter today, so the data layer is extended here.

ASSUMPTION: Search input is debounced 300ms, and a whitespace-only term counts as no
search.

ASSUMPTION: Changing status, sort or search resets pagination to the first page and
refetches. Switching view mode never refetches (§9:109 keeps filter, sort and scroll).

ASSUMPTION: Persistence is device-scoped `SharedPreferences`, matching
`TrackerPreferencesDatasource`. Only view mode and sort persist; the status chip and
the search term are session state and reset to `All` / empty on each visit — §9:109
promises persistence for the view choice only.

ASSUMPTION: Page size is one constant in the library feature's own `const.dart`,
passed as the existing `limit`; the spec fixes no page size.

ASSUMPTION: The renamed preferences datasource keeps the existing `tracker_sort_tag`
key and its read/write behaviour, so `TrackerCubit` (`tracker_cubit.dart:19,28`) keeps
working; the library keys are new and separate.

ASSUMPTION: For Featured, a failed or signed-out library read degrades to an empty
now-playing list, a zero wishlist count, a zero total and an empty owned-id set rather
than failing the whole snapshot. That is exactly what those figures have always shown,
so nothing regresses.

ASSUMPTION: Featured's now-playing list is ordered by `updated_at` descending, the
nearest equivalent of today's `sortByDateModifiedDesc`
(`featured_local_datasource.dart:47`).

ASSUMPTION: `getThisWeekPlayHours()` stays on Isar `playSessionLogs`. D15 names two
methods and there is no play-session table in Supabase, so the This Week tile is
unchanged by this item.

## OBSERVATIONS (verified against source, not inherited)

OBSERVATION-1: The item's factual claims about the dead filters hold.
`SavedGame.status` (`saved_game.dart:46`) and `isWishlisted` (`:50`, defaulted false)
have exactly one writer path in the app — `game_detail_cubit.dart:66-79` — and it sets
neither. `statusEqualTo('Playing')` (`featured_local_datasource.dart:46`) and
`isWishlistedEqualTo(true)` (`:39`) have therefore always matched zero rows.

OBSERVATION-2: **The item text under-counts `getWishlistedGames()`'s callers by two.**
There are three: `featured_repository_impl.dart:39` (the wishlist stat, the one the
item names), `:63` (`getCountdownGame`'s wishlist ids) and `:131`
(`getOutThisWeekGames`'s wishlist-first ordering). Both unnamed callers key on IGDB
ids, which `library_entries.igdb_id` supplies exactly, so repointing fixes all three —
but a criterion set written for the stat alone leaves two callers on a dead filter.
Carried into 3.4-AC25.

OBSERVATION-3: `library_stats.dart:287-305` verified. Its three progress branches read
`manualProgressPercentage`, `hoursLogged` and `averageCompletionHours`.
`library_entries` has `progress_percent` and `playtime_hours` but **no**
average-completion column, so once the shelf renders, branch 1 (`:287-291`) and branch
3 (`:302-305`) fire and branch 2 (`:292-301`) stays **permanently unreachable**.
Recorded in `tech-ac.md ## Known gaps` rather than written as a criterion that cannot
pass. Adding an average-completion source is not in this item; deleting the branch is
the task tree's convention to decide.

OBSERVATION-4: `TrackerPreferencesDatasource` and `TrackerSortRepository` are as the
item describes — `SharedPreferences`, one key (`const.dart:28` `tracker_sort_tag`),
best-effort writes that swallow failures. Their only consumer is `TrackerCubit`, which
has **no widget caller anywhere in `lib/`** after 3.2 deleted the tracker screen; it is
DI-registered only. Renaming is therefore low risk, but `TrackerCubit`,
`TrackerSortRepositoryImpl` and three test files must move with it. `TrackerCubit` is
not on the handover's protected list (`handover.md:472-473` names the two screens,
`TaskCubit`, `GroupTask`, `SavedGameTask`, `TaskStep`).

OBSERVATION-5: The datasource-test gap is real and confirmed independently. The only
references to `LibraryRemoteDatasource` under `test/` are
`library_repository_test.dart:18`'s `@GenerateMocks` and its generated mock; the four
use case tests mock `LibraryRepository`. Nothing executes the query building, the
insert/update payloads, or `clearRating`'s explicit null
(`library_remote_datasource.dart:99-102`). Carried into 3.4-AC33 and 3.4-AC34.

OBSERVATION-6: Search is a third gap of the same kind as counts.
`LibraryRepository.fetchPage` takes status, sort, limit and offset only, so
search-within-status has no data-layer support either.

OBSERVATION-7: `3.2-MC-6` (`manual-check-backlog.md:548-553`) belongs to this run. The
multi-game branch at `library_stats.dart:314` (`setActiveIndex(1)`) has never
executed; this item fires it — and after D14 it is the **only** branch — so confirming
the card opens Library and not Browse is this run's manual check.

OBSERVATION-8: The brief's preamble (lines 82–84) still says the analyzer baseline is
30 issues and "a run that reports 28 has broken something". Phase 0 measured 29 (0
errors, 2 warnings, 27 info) and `+394 -10`. The 2 warnings are the invariant; the
total is not, and the preamble is stale.

OBSERVATION-9: `games_bloc_test`'s three failures are out of scope, but the cause is
in scope as a constraint: `GamesBloc` self-dispatches in its constructor with
`droppable()` handlers, so `droppable()` discards the event `act` adds and the stub
never matches (`testing-conventions.md:231-245`). The new Library bloc must not repeat
that shape, or its own tests are untestable in the house `blocTest` style from day
one. Carried into 3.4-AC11.

OBSERVATION-10: `TrackerSavedGameEntity.id` is a **required non-nullable int**
(`tracker_saved_game_entity.dart:10`) that today carries the Isar row id. After D14
nothing taps through to an Isar-keyed screen, but the field still has to be populated
from a library entry that has no such id. Constrained by 3.4-AC30: whatever value is
used must never reach an Isar lookup. How to satisfy it — retype the seam, or supply a
value that is never keyed on — is a Tech Lead call.

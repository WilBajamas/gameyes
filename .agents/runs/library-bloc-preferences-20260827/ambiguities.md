# Ambiguities Report
Source: `.agents/week-3-task-briefs.md` item 3.4 (lines 234–258), with
`.agents/references/library-design-conventions.md` §3, §8, §9 as the consuming spec.
Carried decisions D9, D12 and the handover's dormant-tracker ruling
(`handover.md:466-481`).
Date: 2026-08-28

## CRITICAL (pipeline blocked — requires human decision before proceeding)

CRITICAL-1: item 3.4, Featured repair — **repointing the now-playing shelf at
`library_entries` makes a never-executed tap live, and its destination needs an Isar
id that `library_entries` cannot supply.**
`library_stats.dart:308-318` is inside the `playingGames.isNotEmpty` branch. With
exactly one playing game it pushes `TrackerGameDetailRoute(game: topGame)` — the sole
surviving entry point into the dormant tracker tree, which `handover.md:474-476` and
3.3-AC32 both forbid removing. That route's screen builds `TrackerDetailCubit`, which
subscribes to Isar by `game.id` (`tracker_detail_cubit.dart:24,76`) and whose section
does an unguarded `state.game!` (`tracker_game_detail_section.dart:27`). A library
entry has a uuid `id` and an `igdbId`; it has no Isar row id. The branch has never
rendered, so this tap has never fired — this item is what fires it.
  Options:
  A — Restrict the shelf to playing entries that also have a local `SavedGame`
      (match on igdb id) and push that row's real Isar id. Both rulings intact; the
      shelf still renders empty for anyone whose playing games were never saved
      through Game Detail, so the reported bug is only partly fixed.
  B — Put the whole playing slice on the shelf and send the single-game tap to the
      Library tab (`setActiveIndex(1)`), matching the multi-game branch. Fixes the
      shelf completely and deletes the protected tracker entry point.
  C — Put the whole playing slice on the shelf, keep the push, and fall back to the
      Library tab only for entries with no matching Isar row. Fixes the shelf, keeps
      the entry point, at the cost of a tap whose destination varies invisibly.
  Not viable: synthesising a `TrackerSavedGameEntity` with a placeholder id. The
  stream then emits null and `tracker_game_detail_section.dart:27` throws; a
  colliding autoincrement id sends `TrackerDetailCubit.setPlatform` (`:55-60`) into
  another game's row.
  Recommended: C.
  Decision needed from: Human (Product Owner) — the handover reserves the tracker
  tree's re-keying for a design convention that has not landed
  (`handover.md:478-481`), so a BA or Tech Lead cannot settle it.

CRITICAL-2: item 3.4, Featured repair scope — **after the repair, one row of three
stat tiles reads two different stores.**
`getLibrarySnapshot` (`featured_repository_impl.dart:34-57`) sources `totalGamesCount`
from Isar (`countSavedGames()`) and `ownedGameIds` from Isar (`getOwnedGameIds()`),
while the wishlist figure moves to `library_entries`. `library_stats.dart:232-249`
renders Total Games and Wishlist side by side, and `library_stats_cubit.dart:40-42`
derives the three checklist steps from both. `ownedGameIds` also drives the owned
marks at `featured_screen.dart:161,238`. Left as is, a user who added games only
through the Library sees `Total Games 0` next to `Wishlist 3`, and their games carry
no owned mark.
  Options: repoint `countSavedGames()` and `getOwnedGameIds()` at `library_entries`
  too (the count capability this item must build serves the first directly) | leave
  both on Isar for now and accept the mixed row until the Isar store retires.
  Recommended: repoint both.
  Decision needed from: Human (Product Owner). One line answers it; if the answer is
  "leave them", nothing else in this item changes.

## ASSUMPTIONS (minor — pipeline may proceed once the criticals are settled)

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
now-playing list and a zero wishlist count rather than failing the whole snapshot.
That is exactly what those two figures have always shown, so nothing regresses.

ASSUMPTION: Featured's now-playing list is ordered by `updated_at` descending, the
nearest equivalent of today's `sortByDateModifiedDesc`
(`featured_local_datasource.dart:47`).

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

OBSERVATION-3: `library_stats.dart:287-305` verified. Its three progress branches read
`manualProgressPercentage`, `hoursLogged` and `averageCompletionHours`.
`library_entries` has `progress_percent` and `playtime_hours` but **no**
average-completion column, so once the shelf renders, branch 1 (`:287-291`) and branch
3 (`:302-305`) fire and branch 2 (`:292-301`) stays permanently unreachable. Flagged
so it is not inherited as live; adding an average-completion source is not in this
item, and deleting the branch is the task tree's convention to decide.

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
(`library_remote_datasource.dart:99-102`).

OBSERVATION-6: Search is a third gap of the same kind as counts.
`LibraryRepository.fetchPage` takes status, sort, limit and offset only, so
search-within-status has no data-layer support either.

OBSERVATION-7: `3.2-MC-6` (`manual-check-backlog.md:548-553`) belongs to this run. The
multi-game branch at `library_stats.dart:314` (`setActiveIndex(1)`) has never
executed; this item fires it, so confirming the card opens Library and not Browse is
this run's manual check.

OBSERVATION-8: The brief's preamble (lines 76–78) still says the analyzer baseline is
30 issues and "a run that reports 28 has broken something". Phase 0 measured 29 (0
errors, 2 warnings, 27 info) and `+394 -10`. The 2 warnings are the invariant; the
total is not, and the preamble is stale.

OBSERVATION-9: `games_bloc_test`'s three failures are out of scope, but the cause is
in scope as a constraint: `GamesBloc` self-dispatches in its constructor with
`droppable()` handlers (`testing-conventions.md:231-245`). The new Library bloc must
not repeat that shape, or its own tests will be untestable in the house `blocTest`
style from day one.

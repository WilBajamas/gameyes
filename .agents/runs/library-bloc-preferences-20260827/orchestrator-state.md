# Orchestrator State
Feature: Item 3.4 — `LibraryBloc`, preferences, and the Featured repair (`.agents/week-3-task-briefs.md` lines 234–258)
Run ID: library-bloc-preferences-20260827
Run folder: .agents/runs/library-bloc-preferences-20260827/
Started: 2026-08-27
Current phase: TECH_LEAD
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 27 info (29 total) — captured 2026-08-27T18:45:00Z
Test baseline: +394 -10 — captured 2026-08-27T18:47:00Z
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: feature/library-bloc-preferences
Base branch: develop
Base SHA: 618bed1
Dev commit: NONE
Last updated: 2026-08-27T18:50:00Z

## Phase 0 notes

Branch cut fresh from `develop` at the human's instruction, rather than continuing
on the harness session branch. Item 3.3 was merged to `develop` at `618bed1` (a
`--no-ff` merge, so the item has a real marker in history rather than vanishing
into a fast-forward as items 3.1 and 3.2 did).

**Baselines verified on the untouched tree, not inherited.** They moved with 3.3
and both numbers are new:
- Analyzer **29 issues — 0 errors, 2 warnings, 27 info** (was 28 before 3.3).
- Suite **+394 -10** (was +363 -10). Same ten pre-existing failures by name.

**The 2 warnings are the invariant.** The deliberate `_TaskReminder` pair at
`task_detail_screen.dart:201` and `:204`. The *total* is not an invariant and has
now moved three times this week — 30 → 28 → 29. A run that reports a different
total has probably just added or deleted files; check the warnings, then find out
why, rather than assuming either breakage or safety.

**One info lint is a deliberate, human-approved survivor**:
`use_null_aware_elements` at `library_remote_datasource.dart:101`. It is the
`else if (rating != null)` half of the `clearRating` pair, and converting it to
`key: ?value` would break 3.3-AC26 — `clearRating` must write an *explicit* null,
while the null-aware form omits the entry. **Do not "fix" it.**

## What item 3.3 handed over

- `LibraryRepository` with four use cases (fetch page, add, update, remove) on
  `Result<T>`, `LibraryEntryEntity`, `LibraryEntryModel`, `LibraryStatus` ↔ column
  mapping, and `LibrarySort` (five options).
- `library_entries` now carries `platform`, `rating`, `playtime_hours`,
  `progress_percent`, `genre` and `updated_at`.
- `ErrorType` gained `duplicateEntry`, `invalidValue`, `notAllowed` and
  `notSignedIn`, mapped off SQLSTATE `23505`/`23514`/`42501` in
  `BaseRepositoryMixin`. Callers can now tell an RLS denial from a constraint
  violation from a unique conflict.
- `LibrarySnapshotEntity` no longer holds an Isar `SavedGame`; it holds
  `TrackerSavedGameEntity`. ~~`library_stats.dart:317` still pushes
  `TrackerGameDetailRoute`, which is the sole surviving entry point into the
  dormant tracker tree and must keep working.~~ **Struck by D14 below — that push
  is removed in this item and the route keeps no caller.** The `TrackerSavedGameEntity`
  retype itself still stands.

## Two things 3.3 deliberately did not do — this item must claim them

1. **Counts.** Nothing anywhere provides a count capability. §3's status chip
   counts and §8's `Showing 12 out of 312` cannot be served by any of 3.3's four
   use cases, and the Tech Lead declined to smuggle in a fifth. This item's BA
   will hit a spec line it cannot satisfy unless the brief claims it.
2. **A datasource test.** No test constructs a real `LibraryRemoteDatasource` —
   the repository test mocks it and the use case tests mock the repository above
   it. Eight of 3.3's criteria (AC16–AC25) rest on code inspection alone, and the
   `clearRating` behaviour has no automated guard at all. QA recommended a
   datasource test against a fake `SupabaseClient`; worth folding in here.

## Carried decisions that still bind

- **D9** — one status vocabulary, no wishlist boolean. This item's Featured repair
  must therefore repoint `getWishlistedGames()` at `status = 'wishlist'`; there is
  no successor to `isWishlisted`.
- **D10** — `rating` is the user's own nullable 1–10 integer. The input control is
  item 4.6's, not this one's.
- **D12** — Supabase is the source of truth. The Isar read cache, the IGDB refresh
  system and task-tree backup are **later items**, not this one. Do not pull them in.
- The tracker task tree is dormant by human decision and must not be cleaned up.

## Human decisions

**D14 — every now-playing tap goes to the Library tab. Resolves CRITICAL-1, option B.**
The single-game branch stops pushing `TrackerGameDetailRoute`; both branches now
call `setActiveIndex(1)`, so the destination no longer depends on how many games
are playing. The whole playing slice renders on the card, so the reported bug is
**fully** fixed rather than half fixed.
The reason the obvious fix was unavailable: that screen looks its game up by **Isar
row id**, which a Supabase library entry cannot supply. A placeholder id crashes on
`tracker_game_detail_section.dart:27`'s unguarded `state.game!`; a colliding
autoincrement id would send `TrackerDetailCubit.setPlatform` into a **different
game's row**. Neither is acceptable, and the real fix — re-keying the tracker tree
onto `igdb_id` — is reserved for a design convention that has not landed.
**What this costs, stated plainly:** the tracker task tree becomes **fully
unreachable**. It was previously reachable from exactly one place, and this removes
it. Two standing rules said it must keep that entry point; the human overrode them
deliberately and authorised the doc amendments, which are done:
- `handover.md` — the "Known non-blocking gaps" reminder, with the superseded
  sentence **struck rather than deleted**, per the week's own lesson that a
  reversed ruling read as live guidance for most of a day.
- `week-3-task-briefs.md` — the "What week 3 does NOT touch" section, same treatment.
**The rule that did NOT change: do not delete the tracker tree.**
`tracker_game_detail_screen.dart`, `task_detail_screen.dart`, `TaskCubit`,
`GroupTask`, `SavedGameTask` and `TaskStep` all stay, compiling and passing their
tests, until the convention lands. Unreachable is not the same as unwanted.
Also retires **3.3-AC32**, which pinned `library_stats.dart` still pushing that
route. That criterion belongs to a run already merged and closed, so nothing
re-gates on it — but a later reader comparing the two items would otherwise see a
contradiction.
Watch for at Dev: removing the last push may orphan the route registration and
produce new info-level lints. That is expected, not breakage. The **2-warning**
invariant is unaffected — `_TaskReminder` lives in `task_detail_screen.dart`, which
survives.

**D15 — `countSavedGames()` and `getOwnedGameIds()` repoint at `library_entries`.**
Resolves CRITICAL-2. Without this, one row of stat tiles reads two different stores
and a user who added games only through the Library sees `Total Games 0` beside
`Wishlist 3`, with no owned marks on Featured. The count capability this item must
build already serves the first of the two directly.

## Escalation history
2026-08-27T19:05:00Z Phase 1 — BA Agent — 2 CRITICAL ambiguities (the now-playing
tap's destination; the split-store stat row) — Resolved: human decisions D14 and
D15 recorded above, 2026-08-27T19:30:00Z. Docs amended. BA re-spawned.

## Deviation approvals
NONE

## Code review outcomes
NONE

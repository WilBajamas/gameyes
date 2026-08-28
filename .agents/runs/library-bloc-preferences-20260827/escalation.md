# Escalation
Agent: BA Agent
Run: library-bloc-preferences-20260827
Opened: 2026-08-28T09:20:00Z
Phase: BA
Reason: Two CRITICAL ambiguities in item 3.4's Featured repair force business
decisions the BA cannot make. `tech-ac.md` is not written.

1. **The now-playing card's tap destination.** Repointing the shelf at
   `library_entries` fires a branch that has never executed. Its single-game path
   pushes `TrackerGameDetailRoute` — the sole surviving entry point into the dormant
   tracker tree, protected by `handover.md:474-476` and 3.3-AC32 — and that screen is
   keyed on an Isar row id a library entry cannot supply
   (`tracker_detail_cubit.dart:24,76`, unguarded `state.game!` at
   `tracker_game_detail_section.dart:27`). Every resolution either shrinks the shelf,
   removes the protected entry point, or makes the tap's destination vary. The
   handover reserves the tracker re-keying for a design convention that has not
   landed (`:478-481`).

2. **How far the Featured repair goes.** `totalGamesCount` and `ownedGameIds` stay on
   Isar while the wishlist figure moves to Supabase, so `library_stats.dart:232-249`
   would render an Isar total beside a Supabase wishlist count, and
   `featured_screen.dart:161,238`'s owned marks would miss every Library-added game.

Full options, evidence and recommendations: `ambiguities.md ## CRITICAL`.
Recommended answers are C for the first and "repoint both" for the second.

Action required: Human decides both, the Orchestrator records them in
`orchestrator-state.md ## Deviation approvals` / carried decisions, then re-runs
Phase 1. The rest of the item (bloc state shape, search composing with the chip per
§9, counts, preferences rename, the datasource test, the wishlist repoint) is
analysed and ready — 13 assumptions and 9 verified observations are already recorded
in `ambiguities.md`, so the re-run is short.

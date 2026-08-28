# Orchestrator State
Feature: Item 3.3 — Schema migration and the remote data layer (`.agents/week-3-task-briefs.md` lines 211–232)
Run ID: library-data-layer-20260827
Run folder: .agents/runs/library-data-layer-20260827/
Started: 2026-08-27
Current phase: DEV
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 26 info (28 total) — captured 2026-08-27T16:05:00Z
Test baseline: +363 -10 — captured 2026-08-27T16:12:00Z
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/questloggd-week-3-stage-3-4sxzix
Base branch: develop
Base SHA: d881052dd10891246a6d481f9adeb38fb0674ce8
Dev commit: NONE
Last updated: 2026-08-27T16:45:00Z

## Phase 0 notes

Resume session — the pipeline runs directly on the harness-designated
`claude/...` branch per `git.md`'s standing exception. No nested `feature/` branch.

**Baselines were captured on the untouched tree at `d881052` before this run
opened**, with Flutter 3.41.4 in a fresh container. Both match the figures the
human carried in from the previous session.

- The **2 warnings are the invariant that carries meaning** — the deliberate
  `_TaskReminder` pair at `task_detail_screen.dart:201` and `:204`. The *total*
  (28) is not an invariant: it dropped from 30 when item 3.2 deleted three files
  whose only issues were info-level lints. A previous run was briefed that "28
  means something broke", hit 28, investigated rather than obeying, and was right.
- `develop` and this branch are the same commit. `d881052` carries items 3.1 and
  3.2, which reached `develop` by fast-forward rather than by a merge commit.

## Known escalation to raise, not guess

Legacy `toBuy` collides with `wishlist`. The legacy Isar model carries wishlist
as a **separate boolean** (`isWishlisted`), so the six-status mapping has five
clean cases and one that needs a human call. This belongs in `ambiguities.md`
as a CRITICAL, not in an assumption.

Raised as CRITICAL-1 on 2026-08-27. The BA phase found two more of the same
shape — see `ambiguities.md`.

## BA phase notes (2026-08-27)

Three of item 3.3's factual claims did not survive Phase 0 verification against
source: `platforms` is not writer-free (live but dormant chain from
`tracker_game_detail_section.dart:113`), `LibraryStatus` does not match the SQL
check constraint "exactly" (`onHold` vs `on_hold`), and the stated current column
list omits `id`, `user_id` and the `(user_id, igdb_id)` unique constraint.
Detail in `ambiguities.md ## Verified against source at Phase 0`.

## Human decisions

Numbering continues week 3's sequence — D1–D5 are in
`.agents/runs/library-foundations-20260826/orchestrator-state.md`, D6–D8 in
`.agents/runs/library-tab-swap-20260826/orchestrator-state.md`.

**D9 — `toBuy` maps to `wishlist`, and `isWishlisted` is dropped.**
Resolves CRITICAL-1, option (a). The two legacy concepts merge into one status
and `LibraryStatus` stays the single status vocabulary, matching the SQL check
constraint with no second axis beside it. The accepted cost is stated, not
overlooked: **"wishlisted AND completed" stops being expressible** — a game can
be wanted or finished, never recorded as both. Nothing is lost on real data,
because neither legacy field has ever had a writer.
Consequence for this item: no boolean wishlist column is added, and
`featured_local_datasource.dart`'s `isWishlistedEqualTo(true)` filter has no
successor field — repointing it at `status = 'wishlist'` is **item 3.4's**
Featured repair, not this run's.

**D10 — `rating` is the user's own rating on a 1–10 integer scale.**
Resolves CRITICAL-2. "Rating" (§4's sort) and "score" (§2/§9's filter) are **one
field**, not two, and it is the user's opinion rather than a denormalised IGDB
critic score. Nullable — an unrated game is the normal case, and a `0` would read
as a one-star verdict rather than as absent, the same trap §6 already names for
`progress_percent`.
Consequence beyond this item: a rating input must exist somewhere, and the
natural home is **item 4.6's add-to-library sheet**, which already plans a rating
control. This run ships the column, the constraint and the write path; it does
not build the input.

**D11 — the grid meta is two segments; `Ch. 9` is dropped.**
Resolves CRITICAL-3, taking the BA's recommendation. §6's *rule*
(`platform · contextual number`) stands and its *example* is wrong. No
chapter/marker column is added. The three surviving contextual numbers all
resolve against real columns: `24h` from `playtime_hours`, `Added 3d ago` from
the existing `created_at`, `Out 14 Aug` from the existing `release_date`.
Rationale worth keeping: shipping a column with no writer is the precise defect
this item exists to clear — `SavedGame.status`, `isWishlisted`,
`manualProgressPercentage` and `hoursLogged` are four such columns already, and
two of them produced branches that had never once fired.
**`library-design-conventions.md` §6's example needs correcting** so a later BA
cannot inherit it — the same doc-correction precedent item 1.4 set and item 3.1
followed for the desaturation filter. Whether that edit lands in this run or a
follow-up is a Tech Lead call.

**D12 — the architecture was re-opened at the Phase 3 gate and lands back where it
started: Supabase is the source of truth.**
The human questioned whether the library should be remote at all. Two alternatives
were worked through in full and rejected:
- *Isar as truth, no remote at all* — rejected because a device change or reinstall
  loses the user's whole library, while the app requires an account, which sets the
  opposite expectation.
- *Isar as truth, Supabase as backup mirror* — rejected once it became clear it
  converges on the same implementation as remote-truth-with-offline-writes. Both
  need an outbox, a retry path and a conflict rule; naming which side is "the truth"
  changes the read path, not the cost.
**What settles it:** `questloggd-design-product-brief.md` §8 already rules offline
out of scope for this phase, so v1 does not need offline *writes* at all. Writes go
straight to Supabase and fail with an inline error when there is no connection.
That removes the outbox, the conflict rule and last-writer-wins from v1 entirely.
Consequences worth recording, because two earlier notes in this run were wrong:
- **No doc correction is needed after all.** `roadmap-deferred.md`'s "this decision
  is what makes Postgres the right backend" is simply true again, and brief §8
  stands. An earlier note in this run claimed both needed correcting; that was
  written while the local-truth option was live.
- **Item 3's cross-account RLS check unblocks in this item**, exactly as the
  original brief said. An earlier note claimed it could never unblock.
- The human's stated direction is to move to local-truth in a later phase. The
  Isar read cache below is the stepping stone, so it is worth building well.

**D13 — data models are never suffixed `Dto`.**
`library_entry_dto.dart` / `LibraryEntryDto` becomes `library_entry_model.dart` /
`LibraryEntryModel`. The tree contains **zero** `*_dto.dart` files, and the
`flutter-dto` skill's own rule is `File: [entity_name].dart` — the skill is only
*named* "dto" and never prescribes the suffix. `LibraryEntryModel` also pairs
readably against `LibraryEntryEntity`.
Routed as a **Tech Lead-only** Phase 3 revision: `tech-ac.md` uses "DTO" as a
generic term only and contains no occurrence of the concrete class or file name, so
no criterion moves and no BA round is needed. `task-brief.md`'s allowlist is
corrected **in place** rather than by delta, because the Dev Agent's allowlist check
is literal and would otherwise read a stale filename.

## Deferred out of item 3.3 by D12 — new items, after 3.4

Recorded here so they are not lost; none of them is 3.3's work.

1. **Isar read cache.** Load from Supabase, keep a local snapshot, read the snapshot
   when there is no connection. The library is readable offline but not editable.
2. **IGDB refresh ("sync").** Staleness check, cooldown, three auto-sync triggers
   (app entry, library screen, library game detail), a non-blocking info-bar when
   auto-sync is off, a Settings toggle, and manual per-game sync.
   The cheap staleness check is two calls, not a property-by-property comparison:
   fetch `id, updated_at` for every saved game in one request, compare a single
   number per game, then fetch full records only for the ids that moved.
3. **Task-tree backup.** `GroupTask`, `SavedGameTask` and `TaskStep` have no remote
   tables. Deferred until the human's task-tree design convention lands, since
   building remote schema for a feature about to be redesigned is throwaway work.
4. **Offline-read amendment to `questloggd-design-product-brief.md` §8.** Human
   decision: land this at the end of stage 3, not now. §8 currently rules offline
   out of scope, which stays true for writes but not for reads once item 1 ships.
5. **Save-a-game control on browse list items.** No design convention exists yet.
   Deferred by the human.

## Escalation history
2026-08-27T16:45:00Z Phase 1 — BA Agent — 3 CRITICAL ambiguities (status mapping,
`rating` semantics, `Ch. 9` grid meta); `tech-ac.md` withheld — Resolved:
human decisions D9, D10 and D11 recorded above, 2026-08-27T16:52:00Z. BA re-spawned.

## Deviation approvals
NONE

## Code review outcomes
2026-08-27 Phase 3 gate — approved, with one Tech Lead-only revision (D13, the
`Dto` → `Model` rename). The architecture was re-opened and re-confirmed as D12.

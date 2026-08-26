# Orchestrator State
Feature: Week 3 item 3.1 — Foundations: art surfaces, and the three docs that keep re-seeding bad criteria
Run ID: library-foundations-20260826
Run folder: .agents/runs/library-foundations-20260826/
Started: 2026-08-26
Current phase: HUMAN_GATE
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 28 info (30 issues total) — captured 2026-08-26T15:36:00Z
Test baseline: +361 -10 — captured 2026-08-26T15:38:00Z
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: feature/library-foundations
Base branch: develop
Base SHA: ab586dc935ab84deaacb4b27d03061befe994bdb
Dev commit: NONE
Last updated: 2026-08-26T15:38:00Z

## Escalation history
2026-08-26T15:45:00Z Phase 1 — ba-agent — 3 CRITICALs: no hex for the art surfaces, violet-as-surface contradicts two colour-law rules, and flat-vs-gradient token shape — Resolved: human answered all four questions below at the Phase 1 gate

## Human decisions — 2026-08-26, Phase 1 escalation

These four answers resolve `ambiguities.md` CRITICAL-1, -2 and -3 plus its
RESIDUALS item. They are decisions, not proposals — build to them.

**D1 (resolves CRITICAL-2) — violet IS ratified as a surface.** §2.2 wins.
Amend `system-foundation-specs.md` §2 rule 4 ("not a UI colour until ratified")
and §7.1 ("never a surface") in this same edit, and record the carve-out the way
ruling 5 does for §12. Consequence: the new surface must be excluded from
`test/widget/theme/app_tokens_test.dart:97-111`'s violet assertion **with a
documented reason** — that assertion stays meaningful for every other token.

**D2 (resolves CRITICAL-1) — reuse existing tokens, mint no new brand colour.**
`surfaceArt` = `surfaceIndigoPanel` `#2F3782`. `surfaceArtDeep` = `statusViolet`
`#7D4EE0`. This is option B in `ambiguities.md`, and D1 is what makes it coherent.

**D3 (resolves CRITICAL-3) — FLAT FILL.** Note this is **not** the BA's
recommendation (it preferred two stops) and not the orchestrator's. The human
chose flat with the trade-off stated: §11's recruit card loses the gradient it
was designed around. `surfaceArtDeep` is one `Color`, `AppColorTokens` stays
uniform, and **`library-design-conventions.md` §11 is corrected to say fill, not
gradient**. Item 4.5 builds on this — do not reintroduce a ramp there.
Side effect: the two tokens are no longer a pair. `surfaceArt` serves §5's cover
placeholder only; `surfaceArtDeep` serves §11's card only.

**D4 (resolves RESIDUALS) — widen the doc allowlist to all 7 occurrences.**
The rejected `saturate(.5) contrast(1.05)` is corrected everywhere it appears,
not just the two the item named. Verified list: `system-foundation-specs.md:236`
(§3.2 Game card) and `:255` (§3.3 Cover tile), `library-design-conventions.md:65`
(§5), `home-screen-design-conventions.md:51` and `:123` — the latter declares the
treatment **app-wide** and is the root of the recurrence —
`game-detail-design-conventions.md:36`, and `onboarding-welcome-design-spec.md:85`.
**The indigo→canvas veil survives in every case; only the desaturation goes.**
Leave the "stand-in photography, tinted and desaturated" production notes alone —
they describe mockup assets, not app behaviour.

## Deviation approvals
NONE

## Code review outcomes
NONE

## Run notes

Requirement text: `.agents/week-3-task-briefs.md`, "Stage 3 — Foundations and
data", item 3.1. Read the handover's "Stage 3 brief" section for the six human
rulings that govern this week — three of them bear directly on this item.

The 2 analyzer warnings are the deliberate `_TaskReminder` pair in
`task_detail_screen.dart` and are NOT this run's to fix. The task tree is
dormant-by-decision all week, so a run reporting 28 issues has broken something.

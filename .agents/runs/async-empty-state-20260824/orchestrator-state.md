# Orchestrator State
Feature: Week 2 Stage 2 item 2.8 — Async states: shared empty state
Run ID: async-empty-state-20260824
Run folder: .agents/runs/async-empty-state-20260824/
Started: 2026-08-24
Current phase: TECH_LEAD
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 31 info — captured 2026-08-24T19:08:00+00:00
Test baseline: +343 -10 — captured 2026-08-24T19:07:00+00:00
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/async-states-empty-state-guasva (harness-designated session branch — no nested feature/ branch, per the standing resume-session process rule)
Base branch: develop
Base SHA: 2784c0275cd83a2e54acfefcbb8edad47e895751
Dev commit: NONE
Last updated: 2026-08-24T19:35:00+00:00

## Escalation history
2026-08-24T19:22:00+00:00 Phase 1 — ba-agent — 2 CRITICAL ambiguities: §3.2's "art-deep" card fill has no value anywhere in the project, and §3.2's mandatory "one action" has no defined target at sites 3, 4 and 5 — Resolved: human gate, both settled in `gate-decisions.md` (fill = existing `surfaceRaised`; action required at all five sites with a destination named per site). `escalation.md` deleted.

## Deviation approvals
NONE

## Code review outcomes
NONE

## Phase 0 recon — verified caller list

Scope is the **empty-state half** of `system-foundation-specs.md` §3.2's Async
states row only. Spec text: "Empty = art-deep card, glyph, caps display headline,
one line, one action; empty states recruit, they never apologise." The
loading/shimmer half is out of scope and unchanged.

Both callers named in the handover were verified on disk, and the grep found
**four more improvised empty states plus one silent one**:

| # | Site | What it does today | Shape |
|---|---|---|---|
| 1 | `games_screen.dart:85-95` | `ErrorRetryWidget(text: no_results_found)` for `GamesStatus.empty` | empty state wearing an error component |
| 2 | `library_stats.dart:270-320` | dashed-border card via `_DashedBorderPainter` (`BorderStyle.none, // We want dashed border`), 44px glyph, headline, `TextButton` action | violates "outlines are always solid" (item 1.4) |
| 3 | `critics_grid.dart:147-164` | 160px `Container`, `surfaceContainerLow`, hardcoded English `'No critic reviews found'`, no glyph, no action | improvised, unlocalised |
| 4 | `countdown_releases.dart:83-101` | 170px `Container`, same recipe, hardcoded English `'No releases in this period'` | improvised, unlocalised |
| 5 | `tracker_tasks_section.dart:42-49` | bare `Text(S.current.no_group_task_created, bodySmall)`; its action (`DefaultOutlinedButton`) is a *sibling*, rendered in both the empty and non-empty cases | plain-text workaround |
| 6 | `tracker_game_detail_section.dart:147-151` | bare `Text(S.current.no_pinned_tasks_desc, bodySmall)`, no action | plain-text workaround |
| 7 | `featured_screen.dart:199-201` | `SizedBox.shrink()` — the countdown section renders *nothing* when empty | silent empty; a design question, not obviously 2.8's to change |

**A fourth checklist inaccuracy, in the same shape as 2.1's, 2.6's and 2.7's.**
The bullet says "this supersedes `project-conventions.md`'s empty-state note".
That note is **not in `project-conventions.md`** — it was moved into
`.claude/skills/flutter-widgets/SKILL.md:218-220` by the 2026-08-07 skills
restructuring, and `project-conventions.md:11` now only points at the skill. The
doc to update when this ships is the **skill**, not the reference doc.

**Rework vs. extraction.** 2.8 is an **extraction** in file terms (a new shared
component beside untouched incumbents), so "ship unwired" is mechanically
available in the way it was for 2.6 and 2.7 — but unlike either, 2.8 has
identified callers that are already *wrong* (#1 renders an error component for an
empty state; #2 is a live standing-convention violation the handover has reserved
for this item across several runs). Shipping unwired would knowingly leave both
in place. Put to the human at the Phase 0 gate.

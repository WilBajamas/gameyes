# Orchestrator State
Feature: Week 2 Stage 2 item 2.6 — Rows & hairline groups (`system-foundation-specs.md` §3.2 "Rows & hairline groups")
Run ID: rows-hairline-20260824
Run folder: .agents/runs/rows-hairline-20260824/
Started: 2026-08-24
Current phase: BA
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 31 info (33 total) — captured 2026-08-24, re-verified on `develop` after the 2.5 merge
Test baseline: +315 -10 — captured 2026-08-24, re-verified on `develop` after the 2.5 merge
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/form-fields-token-treatment-imd2bg
Base branch: develop
Base SHA: cd08b35 (develop, immediately after item 2.5 merged and its run folder retired)
Dev commit: NONE
Last updated: 2026-08-24

Note the pass count moved 312 → 315 when item 2.5 added three tests. Both baselines
were re-run on the merged `develop` rather than inherited from the 2.5 run.

## Phase 0 recon (orchestrator, pre-BA)

**The checklist is wrong about one of the three files, in the same shape as item
2.1's bad caller list.** Item 2.6's bullet describes `group_task_item.dart`,
`task_item.dart` and `horizontal_separator.dart` together as "tracker/task-specific".
That holds for the first two. It does **not** hold for `horizontal_separator.dart`.

Real callers, grepped across `lib/` and `test/`:

| Component | Callers | Where |
|---|---|---|
| `GroupTaskItem` | 1 | `tracker_tasks_section.dart:51` |
| `TaskItem` | 1 | `tracker_game_detail_section.dart:159` |
| `HorizontalSeparator` | 2 | `detail_mid_section.dart:77` (**game_detail, not tracker**) and `group_task_item.dart:36` |

So `HorizontalSeparator` is already a shared, cross-feature primitive whose main
consumer sits outside the tracker entirely. Absorbing or replacing it is therefore
a change to a **game_detail** screen, not a tracker-local refactor — which is
exactly the kind of blast radius the checklist's "leave tracker's own rows alone"
instruction was written to avoid, and it does not cover this case.

`HorizontalSeparator` is 15 lines and carries two defects of its own:
- **`color: Colors.grey` is hardcoded** — a §2 colour-law violation of the same
  shape as the `Colors.red` that item 2.5 removed. The `hairline` token
  (`_ink12`) already exists in `app_color_tokens.dart`.
- **`width: context.screenWidth`** — a separator forcing itself to full screen
  width rather than filling its parent. Fragile inside any padded or constrained
  container.

**Extraction vs rework — the question item 2.5 taught us to ask at Phase 0.** 2.5
established that an in-place rework *cannot* ship unwired: same class, same file
means every caller changes on merge. 2.6 is framed as an **extraction**, which is
the one shape where shipping unwired genuinely is available — a new generic row
beside the three existing files, with tracker's rows as later optional adopters.
That option is real here **provided** the new component is a new file and
`HorizontalSeparator` is left alone. The moment the plan touches
`horizontal_separator.dart` itself, `detail_mid_section.dart` changes on merge and
the unwired option is gone. This is a gate decision, not an implementation detail.

**Spec text** (§3.2): "Price, session and settings rows share one pattern: raised
card at r16, `overflow:hidden`, a single hairline *between* rows only — never a
border on both edges of every row. Label left, value right, optional chevron."

Note the spec describes a **group** (a card containing rows with hairlines between
them), not only a row. Whether 2.6 ships one component or two — a row and its
container — is a real design question for the Tech Lead, since "hairline between
rows only" is a property no single row can enforce about itself.

**Two live follow-ups sit inside this item's likely blast radius**, both recorded
in `handover.md`:
- `_SignOutButton` (`settings/sign_out_section.dart`) is a third hand-rolled copy
  of the `ActionRow` anatomy, and the follow-ups call it "the natural second
  caller". Whether it adopts 2.6's row is a genuine scope question.
- `library_stats.dart`'s `_DashedBorderPainter` violates "outlines are always
  solid" but **belongs to item 2.8**, explicitly not to be fixed in passing.

## Escalation history
NONE

## Deviation approvals
NONE

## Code review outcomes
NONE

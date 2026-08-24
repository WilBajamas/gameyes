# Orchestrator State
Feature: Week 2 Stage 2 item 2.6 — Rows & hairline groups (`system-foundation-specs.md` §3.2 "Rows & hairline groups")
Run ID: rows-hairline-20260824
Run folder: .agents/runs/rows-hairline-20260824/
Started: 2026-08-24
Current phase: COMPLETE
Result: PASS — pending manual checks
Completed: 2026-08-24
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 31 info (33 total) — captured 2026-08-24, re-verified on `develop` after the 2.5 merge
Test baseline: +315 -10 — captured 2026-08-24, re-verified on `develop` after the 2.5 merge
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/form-fields-token-treatment-imd2bg
Base branch: develop
Base SHA: cd08b35 (develop, immediately after item 2.5 merged and its run folder retired)
Dev commit: 409fe04 (with part of the implementation in 6689860 — see the note below)
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

## Phase 3 gate outcome (human, 2026-08-24)

**APPROVED as written**, no delta. `LabelValueRow` + `HairlineGroup` as two flat
files, ships unwired, 10 tests across 2 files, `flutter-widgets` catalogue rows
updated.

Two sub-questions were put alongside the gate and resolved by approving the design
as designed: the **ten tests stay** (AC8's guarantee is a three-case contract and
four more are named by `tech-ac.md`'s own "Verified by" lines — items 2.2 and 2.4
each lost criteria to trimmed tests), and the **`flutter-widgets` "one file per
widget family" rule sentence stays unedited**, remaining a follow-up rather than
being settled inside a component run.

### `Column` vs `ListView` — asked at the gate, settled, recorded so 2.7 doesn't re-litigate it

The human asked whether `HairlineGroup` would be better built on a `ListView`
builder. Answer: no, and the reasoning is worth keeping.

- **`ListView.builder` buys nothing here.** The API takes `List<Widget> children` —
  widgets the caller has *already constructed*. Laziness requires building items on
  demand from a data source; handed a prebuilt list, a builder builds nothing
  lazily. Getting real laziness would mean `itemBuilder` + `itemCount` in the public
  API, which is the data-driven shape of **option C** — already rejected at
  CRITICAL-2 precisely so callers can pass a bespoke child.
- **It is a card, not a list.** These groups sit inside already-scrolling screens, so
  a nested `ListView` needs `shrinkWrap: true` + `NeverScrollableScrollPhysics` —
  and `shrinkWrap` builds every child anyway to measure, losing laziness a second
  time while adding a viewport, hit-test layer and semantics node. `Column(mainAxisSize:
  .min)` also sizes to content, which a card needs; an unbounded `ListView` inside a
  `Column` throws unless shrink-wrapped.
- **The strongest form of the question was `ListView.separated`**, whose
  `separatorBuilder` fires exactly `itemCount − 1` times — AC8's contract guaranteed
  by the framework rather than by a hand-rolled loop. Rejected anyway: it pays the
  nested-viewport cost to buy a guarantee that `if (index > 0)` already provides in
  three tokens, fully visible in review and pinned by tests at N = 1, 2, 3.
- **Where it would genuinely win:** if a group could ever be *long*. Nothing in §3.2
  suggests that (price, session and settings rows are handfuls), and a
  `HairlineGroup.builder` named constructor could be added later without disturbing
  this API.

## Escalation history
2026-08-24 Phase 1 — BA Agent — Two CRITICAL scope ambiguities: which files 2.6 may
touch (and therefore whether it can ship unwired at all), and whether §3.2's
"hairline between rows only" ships as one component or two. `tech-ac.md`
deliberately not written; every hairline/fill/radius/clipping criterion changes
shape depending on the second answer, and whether `HorizontalSeparator`'s two
defects are criteria at all depends on the first. — Resolved 2026-08-24: human
answered both at a gate (CRITICAL-1 → A, CRITICAL-2 → B). BA re-spawned against
the settled scope; `escalation.md` deleted.

## Gate decisions (human, 2026-08-24, resolving the BA escalation)

- **CRITICAL-1 — scope: option A.** New file(s) only; `group_task_item.dart`,
  `task_item.dart` and `horizontal_separator.dart` are all left **untouched**. The
  item ships genuinely **unwired** — no shipped surface changes appearance on merge,
  and tracker's rows stay optional adopters exactly as the checklist intends. This
  is available only because 2.6 is an *extraction*; item 2.5 established that an
  in-place rework can never ship unwired.
  **Consequence to carry:** `HorizontalSeparator`'s two defects stay open as a
  follow-up — a hardcoded `Colors.grey` (a §2 colour-law violation of the same
  shape as the `Colors.red` 2.5 removed, with the `hairline` token already
  available) and `width: context.screenWidth`. Add to the handover follow-ups when
  this run completes.
  **Known tension, accepted:** with no caller anywhere, the new API has to be
  derived from the design docs rather than a live call site, which sits awkwardly
  against the "no parameter nothing calls" rule that trimmed `suffixIcon` in 2.5.
  Keep the API minimal for that reason.
- **CRITICAL-2 — grain: option B.** Two public components — a row, plus a group
  container that owns the card fill, r16, clipping, and inserts the hairlines
  *between* its children. This makes §3.2's load-bearing "hairline between rows
  only, never a border on both edges" rule **unbreakable by construction** rather
  than a rule each caller must remember. Accepted cost: a second public class, and
  the row is usable standalone in a way the spec doesn't sanction.

## Deviation approvals
NONE

## Code review outcomes

2026-08-24 `409fe04` (+ `6689860`) — Reviewed and approved by human, sent to QA.
Deviations: NONE.

### Two process incidents on this Dev phase — both worth avoiding next time

1. **The orchestrator's `git add -A` swept up the Dev Agent's in-progress files.**
   The "Phase 3 approved" docs commit `6689860` therefore carries both that docs
   change *and* the first pass of `label_value_row.dart`, `hairline_group.dart` and
   both test files, under a message describing only the docs. Harmless to the code,
   misleading in history. **Rule for next time: never `git add -A` while a subagent
   is live in the same tree** — stage explicit paths, or wait for the agent to
   return. This is the orchestrator's error, not the Dev Agent's.
2. **The Dev Agent hit an account-wide session limit at its commit step** and
   terminated with its work finished but uncommitted (`diff-summary.md` written,
   all three required sections present). The orchestrator committed that work
   unchanged as `409fe04`, after independently verifying the baseline rather than
   trusting `diff-summary.md`. Recorded as a deliberate, one-off departure from
   "only the Dev Agent commits" — the alternative was losing finished work to an
   ephemeral container. The commit message states the authorship.

Verified independently before the gate: analyzer 33 (0/2/31); tests +325 -10
(baseline +315 plus this run's 10, the 10 failures unchanged in identity); zero
comments in both widget files; no golden test; tests import only the two public
widget files plus the permitted harness; and `HairlineGroup`'s constructor is
exactly `{super.key, required this.children}`, so no divider flag crept in during
implementation and `[2.6-AC9]` holds as designed.

**Dev's one self-correction found a broken test, not a broken widget**, which is
worth remembering: `find.byType(ColoredBox)` was matching an unrelated `ColoredBox`
elsewhere in the pumped tree, so the "no card fill when empty" assertion was not
testing what it claimed. Both finders are now scoped to the group's subtree with
`find.descendant`. An unscoped `byType` finder in a `MaterialApp` harness can pass
forever while asserting nothing.

Also worth carrying: the N−1 separator tests use plain `Text` children rather than
`LabelValueRow`, which *demonstrates* that arity alone drives hairline placement
(`[2.6-AC12]`) rather than merely asserting it.

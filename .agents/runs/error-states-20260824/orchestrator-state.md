# Orchestrator State
Feature: Week 2 Stage 2 item 2.7 — Error states (`system-foundation-specs.md` §3.2 "Error states" row + §3.4)
Run ID: error-states-20260824
Run folder: .agents/runs/error-states-20260824/
Started: 2026-08-24
Current phase: BA
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 31 info (33 total) — re-verified on `develop` after the 2.6 merge
Test baseline: +325 -10 — re-verified on `develop` after the 2.6 merge
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/form-fields-token-treatment-imd2bg
Base branch: develop
Base SHA: e0b2111 (develop, immediately after item 2.6 merged and its run folder retired)
Dev commit: NONE
Last updated: 2026-08-24

The pass count has moved twice recently — 312 → 315 (2.5's three tests) → 325
(2.6's ten). Both baselines were re-run on merged `develop`, not inherited.

## Phase 0 recon (orchestrator, pre-BA)

### Scope is REDUCED from the checklist bullet — three levels, not four

The checklist lists Field / Action / Screen / Item. **The Field level is already
built**: item 2.5's `LabeledTextField` ships the tinted fill plus error hairline,
and a human gate decision on 2026-08-24 settled that **2.7 inherits it unchanged**.
2.7 therefore covers **Action, Screen and Item only**.

This is exactly the trap the handover warns about — §3.4's text still describes all
four levels, and a BA writing criteria straight from it would rebuild the field
level. Third instance of that failure mode if it happens (after two on the
desaturation filter).

### Existing error surfaces — grepped, not inherited

The checklist has been wrong about callers **twice** in Stage 2 (2.1's named two
files that never referenced the component; 2.6's called
`horizontal_separator.dart` tracker-specific when its main caller is a game_detail
screen). So:

| Component | Live callers | Where |
|---|---|---|
| `ErrorRetryWidget` (37 lines) | **5** | `detail_top_header.dart:34`, `detail_mid_section.dart:29`, `games_screen.dart:68/78/88` |
| `DefaultSnackbar` (21 lines) | **1** | `task_detail_screen.dart:70` |

Note `detail_screenshot_section.dart:22` and `:52` hold two **commented-out**
`ErrorRetryWidget` blocks — dead code, not callers. Worth flagging rather than
counting either way.

### Rework or extraction — decide this before anything else

Items 2.5 and 2.6 together established the rule that decides whether "ship unwired"
is even available:
- **2.5 (in-place rework): unwired is impossible.** Same class, same file means
  every caller changes on merge.
- **2.6 (extraction, new files): unwired is genuinely available.** Nothing existing
  was touched.

**2.7 is a mix, and that is the gate question.** The Screen level overlaps
`DefaultSnackbar` (1 caller) and the Action/Screen levels arguably overlap
`ErrorRetryWidget` (5 callers, across two features). New components beside them ship
unwired; absorbing either changes shipped surfaces. Put the real shape to the human
rather than assuming.

### Tokens — all present, but one naming question

`errorStrong` (`0xFFD92D20`), `errorInk`, `errorLine`, `errorTint` all exist.

**§3.4's Screen toast specifies `#2e3236`, and a token with exactly that value
already exists — but it is named `surfaceTabChrome`** (`0xFF2E3236`, minted for
item 2.4's tab bar). So the value is right and the name is wrong for this use.
Either the toast reuses a token named for the tab bar, or a semantic alias is
minted. Worth raising rather than silently reusing — a component reading
`surfaceTabChrome` for a toast is the kind of thing that reads as a mistake later.

### §3.4's Item level has a positional dependency

"a wordless corner alert badge **in the same slot as the indigo library tick**" —
`lib/widgets/library_tick.dart` exists (promoted to an app-wide primitive during
item 2.1). The Item-level badge must share its slot, so `LibraryTick` is the
positional reference and probably wants reading side by side.

### Grain — a live question the checklist itself raises

The bullet asks the Tech Lead to confirm whether three sub-components in one item is
the right grain, or whether they should be separate runs. That question is real and
should reach the human at a gate. With three sub-components, this is also the
strongest candidate yet for a module folder — though note 2.5 and 2.6 both
deliberately shipped flat files, so it is a judgement, not a default.

## Escalation history
NONE

## Deviation approvals
NONE

## Code review outcomes
NONE

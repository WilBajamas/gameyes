# Orchestrator State
Feature: Week 2 Stage 2 item 2.5 — Form fields (`system-foundation-specs.md` §3.2 "Form fields")
Run ID: form-fields-20260823
Run folder: .agents/runs/form-fields-20260823/
Started: 2026-08-23
Current phase: TECH_LEAD
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 31 info — captured 2026-08-23T19:05:00Z
Test baseline: +312 -10 — captured 2026-08-23T19:10:00Z
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/form-fields-token-treatment-imd2bg
Base branch: develop
Base SHA: 4680dedae591d7cfc4955625a9843de7a72fc99a
Dev commit: NONE
Last updated: 2026-08-23T19:15:00Z

## Phase 0 recon (orchestrator, pre-BA)

Environment built from scratch: Flutter 3.41.4 installed to `/opt/flutter` (matches
`.fvmrc`), exposed via `/etc/profile.d/flutter.sh` so every login shell — including
subagents' Bash calls — picks it up. `flutter pub get` and
`dart run build_runner build --delete-conflicting-outputs` both run; codegen produced
**no git churn**, so the working tree was clean before and after.

All three baseline numbers were re-verified on the untouched tree rather than
inherited, per the handover's warning that the baseline had moved twice during item
2.4. All three match what the handover predicted, exactly.

**Real caller list for `DefaultBorderTextField` — grepped, not inherited.** The
checklist's "has multiple existing callers" claim is CORRECT this time (unlike item
2.1's, which named two files that never referenced the component). Three files, seven
call sites:

| File | Sites | Usage shape |
|---|---|---|
| `lib/widgets/add_content_dialog.dart` | 2 | title (required, maxLength 30, hint) + description (required, multiline minLines 5, maxLength 100, hint) |
| `lib/features/filter/presentation/widgets/filter_bottom_sheet.dart` | 3 | search (prefixIcon) + date-from / date-to (both `readOnly` with `onClicked` date pickers) |
| `lib/features/tracker/presentation/screens/task_detail_screen.dart` | 2 | inline title + description editors, both behind an `_isEditing` toggle |

Notable properties of the current API that the rework has to reckon with:
- The widget takes **`BuildContext context` as a constructor field** — an antipattern
  every one of the seven call sites currently feeds. Removing it touches all three
  caller files whatever else is decided.
- `hint` is used as a genuine placeholder at 2 sites and absent at the other 5, so
  "no placeholder-as-label anywhere" does not, by itself, force the hint out.
- `readOnly` + `onClicked` (3 sites) means the component doubles as a tap target, not
  only a text input.
- `isRequired` drives an internal `validator`, so the error state the spec describes
  already has a live producer.

**Tokens confirmed present** in `lib/config/theme/tokens/app_color_tokens.dart`:
`surfaceRaised` = `Color(0xFF2F333C)` (the spec's `#2f333c` fill), `green`
(`0xFF35ED7E`, the focus ring), `errorTint`, `errorLine`, `errorInk`, `error`,
`hairline`. Nothing new needs minting for the colours.

**Scope boundary worth a gate decision:** checklist item **2.7 (Error states, 4
levels)** explicitly owns "field-level tinted fill + red hairline" — the same
treatment 2.5's error state describes. 2.5 and 2.7 overlap here and the boundary
should be settled deliberately rather than by whichever item runs first.

## Gate decisions (human, 2026-08-23, pre-Tech-Lead)

The BA routed three decisions to a gate rather than halting. All three were put to
the human before Phase 2, because GATE-1 and GATE-2 between them determine the task
brief's file allowlist and whether four criteria stand — designing before they were
settled would have meant a near-certain Tech Lead re-run.

- **GATE-1 — rewiring scope: option A.** Rework in place and revisit all 7 call
  sites across the 3 caller files. Three shipped surfaces change appearance on
  merge, which is accepted and deliberate. Matches how item 2.1 settled the
  identical fork. Renaming the widget off its `Default` prefix is in scope, since
  every caller is being edited anyway.
- **GATE-2 — field-level error treatment: option A.** Item 2.5 builds it now.
  `[2.5-AC8]`–`[2.5-AC11]` stand as written. Item **2.7 therefore covers only the
  Action, Screen and Item levels** and inherits the field level unchanged — record
  this against 2.7 when it runs.
- **GATE-3 — type steps: option A.** Use the existing 14/500 and 16/400 tokens;
  mint nothing. `[2.5-AC18]` stands. The 15px token is now a **third**-occurrence
  follow-up (after items 1.9 and 2.2), raised separately rather than absorbed into
  a component run.

## Escalation history
NONE

## Deviation approvals
NONE

## Code review outcomes
NONE

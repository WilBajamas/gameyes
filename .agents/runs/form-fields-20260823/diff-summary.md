# Diff Summary
Source: `tech-ac.md` — week 2 Stage 2 item 2.5 Form fields (`system-foundation-specs.md` §3.2)
Date: 2026-08-24
Branch: claude/form-fields-token-treatment-imd2bg
Commit: 79255bdc99f4a64ad3b5c103643a6c0a0bbc818e

## Files created
lib/widgets/labeled_text_field.dart — `LabeledTextField`, the token-driven text input: label row above the box, a `FormField<String>`-composed `TextField` inside a raised/error-tint `InputDecoration`, and the private `_FieldLabelRow` / `_FieldFocusRing` sub-widgets. No comments.
test/widget/components/labeled_text_field_test.dart — three smoke tests: required-field validation message, read-only tap callback, single character-count render.

## Files modified
lib/widgets/add_content_dialog.dart — both fields swapped to `LabeledTextField`; dropped `context:`, renamed `title`→`label`, `textEditingController`→`controller`, `hint`→`placeholder`, `maxLengthEnforce`→`enforceMaxLength`; dropped the redundant `minLines: 1` on the title field; updated import.
lib/features/filter/presentation/widgets/filter_bottom_sheet.dart — all three fields (search, date-from, date-to) swapped to `LabeledTextField` with the same renames; dropped `inputType: TextInputType.number` from both date fields (inert on a read-only field); `readOnly`/`onClicked` unchanged; updated import.
lib/features/tracker/presentation/screens/task_detail_screen.dart — both editors (title, description) swapped to `LabeledTextField` with the same renames, and each now passes `enforceMaxLength: true` per the approved Phase 3 gate delta so their shipped enforced-length behaviour is unchanged; updated import.
.claude/skills/flutter-widgets/SKILL.md — catalogue row: replaced `DefaultBorderTextField` with `LabeledTextField`. The "one file per widget family" rule sentence left untouched, as instructed.

## Files deleted
lib/widgets/default_border_text_field.dart — replaced in full by `LabeledTextField`; no caller remains.

## Test files
test/widget/components/labeled_text_field_test.dart — required-message-on-empty-validate, onClicked-fires-on-tap-for-read-only, character-count-renders-once-in-label-row-not-duplicated-below-input. All pass.

## Self-corrections
File: test/widget/components/labeled_text_field_test.dart — Error: `tester.tap(find.byType(LabeledTextField))` failed a hit test (offset landed on an Overlay/theater render layer above the widget's own bounding box, not the widget itself) — Fix: tapped `find.byType(TextField)` instead, the actual interactive surface within `LabeledTextField` (still only imports the widget's own file plus Material) — Attempts: 1

## Deviations from implementation plan
NONE — plan followed exactly, including the Phase 3 gate delta (`enforceMaxLength: true` on both `task_detail_screen.dart` sites, superseding the stale `tdd.md`/`task-brief.md` text the delta names).

## Verification against baseline
`flutter analyze` — 33 issues (0 errors, 2 warnings, 31 info), matches `orchestrator-state.md` baseline exactly. The 2 warnings are the pre-existing `_TaskReminder` pair in `task_detail_screen.dart`, left untouched.
`flutter test` — 315 passed, 10 failed (+312 baseline +3 new tests = 315; the 10 failures are the pre-existing `tracker_repository_test` (4), `game_detail_cubit_test` (3), `games_bloc_test` (3) — no new in-scope failure).

## Acceptance criteria status
[2.5-AC1]: satisfied — label always renders above the box via `_FieldLabelRow`, outside the `TextField`; empty label suppresses the row.
[2.5-AC2]: satisfied — `hintText: widget.placeholder` renders only inside the empty box, Material's own hint behaviour.
[2.5-AC3]: satisfied — `helper` renders in the label row's trailing slot when no `maxLength` is set; nothing renders below the input.
[2.5-AC4]: satisfied — `maxLength` set → `'<used>/<max>'` in the label row trailing slot; `counterText: ''` suppresses Material's own below-field counter; no `maxLength` → no count anywhere.
[2.5-AC5]: satisfied — `fillColor: tokens.color.surfaceRaised` at rest, `border`/`enabledBorder` use `BorderSide.none` when not in error.
[2.5-AC6]: satisfied — `OutlineInputBorder`/`Border.all` are always solid; no dashed/dotted construct used anywhere.
[2.5-AC7]: satisfied — `_FieldFocusRing` draws a 2px `tokens.color.green` border at a 2px padding/offset when `_focusNode.hasFocus`, transparent otherwise; fill unaffected by focus.
[2.5-AC8]: satisfied — `field.hasError` swaps `fillColor` to `errorTint` and `borderSide` to `errorLine`; resting fill not retained.
[2.5-AC9]: satisfied — error message renders below the ring in `tokens.color.errorInk`; no error-ramp colour used elsewhere; no literal red.
[2.5-AC10]: satisfied — ring and hairline are driven by independent conditions (`_focusNode.hasFocus`, `field.hasError`) so both render together when both hold.
[2.5-AC11]: satisfied — no glow/animation/icon added on error; `TextField`'s own text state is untouched by validation.
[2.5-AC12]: satisfied — `_validateRequired` returns `S.current.please_enter_value` on empty; non-required fields pass no validator. Covered by test.
[2.5-AC13]: satisfied — `minLines`/`maxLines` pass straight to `TextField`; label row, ring and error treatment are identical regardless of line count; default `maxLines: 1`.
[2.5-AC14]: satisfied — `readOnly: true` plus `onTap: widget.onClicked` on the underlying `TextField` gives tap-fires/no-keyboard/no-edit; resting fill unaffected by `readOnly`. Covered by test.
[2.5-AC15]: satisfied — `enforceMaxLength` maps explicitly to `MaxLengthEnforcement.enforced`/`.none` (never `null`), so the flag means what it says.
[2.5-AC16]: satisfied — `LabeledTextField` takes no `context` parameter; resolves `context.tokens` from its own `build`; all 7 call sites compile with no `context:` argument.
[2.5-AC17]: satisfied (manual check) — `contentPadding` vertical 12 + body text line height clears 44px; not asserted in the test per the binding constraint against dimension assertions.
[2.5-AC18]: satisfied — label/message at `typography.meta` (14/500), input/placeholder at `typography.body` (16/400), helper/counter at `typography.caption` (13/400); no new token minted.

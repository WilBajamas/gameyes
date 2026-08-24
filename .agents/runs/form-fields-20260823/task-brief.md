# Task Brief
Source: `tech-ac.md` — week 2 Stage 2 item 2.5 Form fields (`system-foundation-specs.md` §3.2)
Date: 2026-08-24

## Context

Replace the app's only text input with `LabeledTextField`, a token-driven field
whose label sits above the box, whose helper/counter folds onto that label row,
and whose focus ring and error treatment never share an edge — and rewire all 7
call sites so nothing keeps the old hardcoded red or the caller-passed
`BuildContext`.

## Testing mode

**smoke** — Rule applied: "UI-only with no new logic ... isolated with no shared
dependencies." Justification: presentation only; the required-field rule and
max-length behaviour carry over from the widget being replaced. One dedicated
widget test file, for `LabeledTextField` only (see `tdd.md ## Testing` for which
widgets deliberately get none and what the test file may import). Never a golden
test; no test asserts a dimension, gap, radius, offset or position.

## File allowlist

### CREATE NEW
`lib/widgets/labeled_text_field.dart` — the field: label row, token-driven box,
focus ring, error treatment, and the `FormField<String>` that carries validation.

### MODIFY EXISTING
`lib/widgets/default_border_text_field.dart` — **delete this file.** It is
replaced, not deprecated: leaving it alive would keep `Colors.red` and the
caller-passed `BuildContext` in the tree, which GATE-1 explicitly rejected.
`lib/widgets/add_content_dialog.dart` — swap 2 sites to `LabeledTextField`
(title, description) and update the import.
`lib/features/filter/presentation/widgets/filter_bottom_sheet.dart` — swap 3
sites (search, date-from, date-to) and update the import.
`lib/features/tracker/presentation/screens/task_detail_screen.dart` — swap 2
sites (title editor, description editor) and update the import.
`.claude/skills/flutter-widgets/SKILL.md` — **catalogue row only**: replace the
`DefaultBorderTextField` row with a `LabeledTextField` one. Do not touch the
"one file per widget family" rule sentence — that contradiction is a separate
live follow-up. If the human would rather this file stayed out of a component
run, strike it at the gate and the row goes stale instead.

### TEST FILES
`test/widget/components/labeled_text_field_test.dart` — three tests: the required
message on an empty validate, the read-only tap callback, and the counter
appearing exactly once on the label row.

No generated files are involved: nothing here is annotated, and the test file
uses no `@GenerateMocks`. **No `build_runner` step and no `intl_utils` step is
needed** — no new user-facing string is added (the counter is digits and a slash;
the required message reuses `S.current.please_enter_value`).

## Implementation plan

Step 1: Create `lib/widgets/labeled_text_field.dart` — `LabeledTextField`
(stateful, owns and disposes a `FocusNode`) plus the private `_FieldLabelRow` and
`_FieldFocusRing` in the same file. Shape and parameter list are in
`code-plan.md`. No comments anywhere in the file.

Step 2: Rewire `lib/widgets/add_content_dialog.dart` — both sites to
`LabeledTextField`, dropping `context:`, renaming `title`→`label`,
`textEditingController`→`controller`, `hint`→`placeholder`,
`maxLengthEnforce`→`enforceMaxLength`, and dropping the redundant `minLines: 1`
on the title. Update the import.

Step 3: Rewire
`lib/features/filter/presentation/widgets/filter_bottom_sheet.dart` — all three
sites with the same renames; additionally drop `inputType: TextInputType.number`
from both date fields (inert on a read-only field). `readOnly` and `onClicked`
stay exactly as they are. Update the import.

Step 4: Rewire
`lib/features/tracker/presentation/screens/task_detail_screen.dart` — both
editors with the same renames. Update the import.

Step 5: Delete `lib/widgets/default_border_text_field.dart`.

Step 6: Update the widget catalogue row in
`.claude/skills/flutter-widgets/SKILL.md`.

Step 7: Write `test/widget/components/labeled_text_field_test.dart` per
`code-plan.md`, following `flutter-widget-test` — build the subject with the real
`buildDarkTheme()` and the `S.delegate` harness the reference files use, do not
pre-resolve tokens in `setUpAll`, import only the widget's own file.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md` verbatim — `Analyzer baseline: 0 errors, 2 warnings, 31
info` and `Test baseline: +312 -10`, with the pre-existing failures being
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3) and
`test/cubit/games/games_bloc_test.dart` (3). The suite is not green and the
analyzer is not clean; only a new, in-scope regression is yours. Expect the pass
count to rise by the three new tests.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: `[2.5-AC1]`–`[2.5-AC18]` (all eighteen; GATE-2 kept AC8–AC11 here,
GATE-3 kept AC18 as written).

## Constraints

- **The widget file carries no comments at all** — not a header, not a `///`, not
  a note above the ring or a token lookup. Stricter than the project-wide "few
  comments" rule and it overrides it here.
- Every colour, type step and radius comes from `context.tokens`. Never
  `Theme.of(context)` directly, never a literal hex, never `Colors.red` or
  `Colors.grey`. `Colors.transparent` for the unfocused ring is the one
  permitted literal.
- Red only through the error-ramp tokens, never in a non-error state. Green only
  in the focus ring.
- Outlines are always solid — no dashed or dotted edge in any state.
- Dimensions the widget writes itself are even numbers. The 1px hairline and the
  2px ring/offset are the spec's own numbers (§3.2, §1.8, §2.1) and stand.
- The widget adds no spacing outside its own outer edge and takes no padding or
  gap parameter; callers own the rhythm between fields. Internal gaps between the
  label row, box and message are its own anatomy and are fine.
- No Widget-returning function or getter — extracted UI is a widget class.
- All user-facing strings via `S.current`; do not hardcode and do not add a key
  for the counter.
- Import order: package imports (flutter → third-party → project), then the
  relative `generated/l10n.dart`, each group blank-line-separated and
  alphabetised. `const` wherever the linter allows.
- Do not change the theme's `inputDecorationTheme`, do not mint a token, do not
  add a package, do not touch `pubspec.yaml` beyond reading it.
- `test/widget/components/` is the folder for this test file; test folders are
  layer-based, never mirrored from `lib/`.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead.

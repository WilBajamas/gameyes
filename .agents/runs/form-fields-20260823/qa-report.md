# QA Report
Source: `tech-ac.md` — week 2 Stage 2 item 2.5 Form fields (`system-foundation-specs.md` §3.2)
Date: 2026-08-24

Overall result: PASS — pending manual checks

Verified against commit `79255bdc99f4a64ad3b5c103643a6c0a0bbc818e` on
`claude/form-fields-token-treatment-imd2bg`, not against `diff-summary.md`'s
account of itself.

## Manual verification required

All eight are visual/pixel checks the binding constraints in `tech-ac.md` put
outside the test suite. Per the standing decision, the manual backlog is
deferred until Stage 2's eight items are done — listed, not attempted.

[2.5-AC5] — Open the filter sheet (Search field, untouched) — expect a solid
`surfaceRaised` (#2f333c) fill at radius 16 and no stroke on any edge, including
the two read-only date fields.
[2.5-AC7] — Open the Add-content dialog, tap into Title — expect a 2px green ring
drawn outside the box at a 2px gap, the fill unchanged, and the ring gone on blur.
Green appears nowhere else in the field.
[2.5-AC8] — Add-content dialog, submit with Title empty — expect the fill to swap
to the error tint (raised fill not showing through) and a 1px error-line hairline
on the box edge; expect both to clear once a valid value is entered and validation
re-runs.
[2.5-AC10] — Add-content dialog, submit empty then tap back into Title — expect
the green ring and the error hairline visible at the same time, neither
suppressing the other.
[2.5-AC11] — Same state, re-run validation on the same content — expect no glow,
no shake, no icon inside the box, and the typed text unchanged.
[2.5-AC13] — Add-content dialog, Description (minLines 5, maxLines null) — expect
the label above the box, the fill wrapping the whole grown box, and focus/error
treatment identical to the single-line Title.
[2.5-AC17] — Every configuration, but especially the filter sheet's read-only
date fields and a single-line field with no placeholder — expect the tappable box
to measure at least 44px tall.
[2.5-AC18] — Any of the three surfaces — expect label and validation message at
14/500, input and placeholder at 16/400, counter at 13/400. Token values were
verified in source; only the rendered result is manual.

Also worth a look on-device while the above are being checked (not a criterion):
the three shipped surfaces whose appearance changes on merge — already accepted
as deliberate at GATE-1.

## Static analysis
Status: PASS
Errors: NONE

`flutter analyze` — **33 issues (0 errors, 2 warnings, 31 info)**. Matches the
`orchestrator-state.md` baseline exactly; Dev's reported number is confirmed, not
taken on trust.

The 2 warnings are still exactly the deliberate `_TaskReminder` pair, and no more,
in the file this run edited:
- `lib/features/tracker/presentation/screens/task_detail_screen.dart:201:7` — `unused_element`
- `lib/features/tracker/presentation/screens/task_detail_screen.dart:204:29` — `unused_element_parameter`

No issue of any severity is attributed to `lib/widgets/labeled_text_field.dart`
or `test/widget/components/labeled_text_field_test.dart`.

`build_runner` was not run: per `.claude/pipeline/rules/generation.md` it is read
only when the allowlist carries annotated sources, generated outputs, Mockito
tests, routing, DI or localisation changes. This allowlist carries none — nothing
is annotated, the test file uses no `@GenerateMocks`, and no `.arb` key was added.
Phase 0 also recorded codegen producing no git churn on this tree.

## Test results
Status: PASS (testing-mode: smoke)
Tests run: 325  |  Passed: 315  |  Failed: 10

Matches the `+312 -10` baseline plus the three new tests. Dev's 315/10 is
confirmed independently.

Failing tests — all 10 pre-existing, none in scope, none new:
- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

All three new tests pass:
- `test/widget/components/labeled_text_field_test.dart` — shows the required message when an empty required field is validated
- `test/widget/components/labeled_text_field_test.dart` — calls onClicked when a read-only field is tapped
- `test/widget/components/labeled_text_field_test.dart` — shows the character count once when a maximum length is set

## Coverage gaps (coverage mode only)
N/A — testing mode is `smoke`.

## Acceptance criteria

[2.5-AC1]: PASS — `labeled_text_field.dart:93-94` renders `_FieldLabelRow` as a
sibling above the ring, outside the `TextField`; the old `labelText:` that
floated into the box edge is gone with the deleted widget. Empty label with no
trailing suppresses the row entirely (`:93`).
[2.5-AC2]: PASS — `labeled_text_field.dart:116` passes `hintText: widget.placeholder`
(null when unsupplied, so an empty box stays empty); the label is never repeated
inside the box.
[2.5-AC3]: PASS — `labeled_text_field.dart:78-80` routes `helper` to the label
row's trailing slot, rendered at `:175-176`. Nothing is emitted below the input
except the error message.
[2.5-AC4]: PASS — count composed at `:78-79` into the label row's trailing slot;
Material's own below-field counter suppressed by `counterText: ''` at `:122`.
Proven by `shows the character count once when a maximum length is set` — the
single match is the assertion's point. No `maxLength` → `trailing` falls back to
`helper`, so no count renders.
[2.5-AC5]: MANUAL — code is correct (`fillColor: tokens.color.surfaceRaised` at
`:115`, `BorderSide.none` at `:86`, `radius.lg` = 16 confirmed in
`app_radius_tokens.dart:37`), and `readOnly` does not branch the fill. Resting
appearance is a visual check — see above.
[2.5-AC6]: PASS — statically verifiable: the only strokes the file draws are
`OutlineInputBorder` (`:82-87`) and `Border.all` (`:195-199`). No dashed/dotted
construct and no `CustomPainter` anywhere in the file.
[2.5-AC7]: MANUAL — code is correct (`_FieldFocusRing` at `:182-204`: 2px border,
2px padding, `tokens.color.green` when focused and `Colors.transparent`
otherwise — the one permitted literal; fill is not focus-dependent). Green appears
at exactly one place in the file (`:196`). Ring geometry is a visual check.
[2.5-AC8]: MANUAL — code is correct (`field.hasError` swaps `fillColor` to
`errorTint` at `:113-115` and `borderSide` to `BorderSide(color: errorLine)` —
default width 1.0 — at `:84-86`; the raised fill is replaced, not layered).
Appearance is a visual check.
[2.5-AC9]: PASS — the message renders as a Column sibling *below* the ring
(`:138-144`) in `tokens.color.errorInk`, guarded by `field.hasError` so no
error-ramp colour reaches a valid state. No literal red survives anywhere: the
deleted widget's `errorStyle: TextStyle(color: Colors.red)` is gone. Presence
proven by `shows the required message when an empty required field is validated`.
[2.5-AC10]: MANUAL — code is correct: the ring reads `_focusNode.hasFocus`
(`:96`) and the hairline reads `field.hasError` (`:84`), two independent
conditions with no mutual suppression, so both hold together by construction.
Simultaneous appearance is a visual check.
[2.5-AC11]: MANUAL — code is correct: no `AnimatedContainer`, `Tween`,
`Transform` or error icon exists in the file, and validation never touches the
`TextField`'s controller or text. Absence of motion is a visual check.
[2.5-AC12]: PASS — `_validateRequired` at `:63-68` returns
`S.current.please_enter_value` on null/empty and is attached only when
`isRequired` (`:76`), so a non-required field never fails on empty. Proven by
`shows the required message when an empty required field is validated`.
[2.5-AC13]: MANUAL — code is correct: `minLines`/`maxLines` pass straight through
(`:102-103`, default `maxLines: 1`), and the label row, ring and error treatment
sit outside the `TextField` so they cannot vary with line count. Grown-box
appearance is a visual check.
[2.5-AC14]: PASS — `readOnly: true` (`:101`) plus `onTap: widget.onClicked`
(`:135`) on the `TextField`; no fill branches on `readOnly`. Tap half proven by
`calls onClicked when a read-only field is tapped`; keyboard suppression and
non-editability are Material's own `readOnly` contract, unchanged from the widget
being replaced.
[2.5-AC15]: PASS — **both halves confirmed against the approved delta.** The
widget maps the flag explicitly and never to `null`:
`maxLengthEnforcement: widget.enforceMaxLength ? MaxLengthEnforcement.enforced : MaxLengthEnforcement.none`
(`:105-107`). And both `task_detail_screen.dart` editors pass
`enforceMaxLength: true` — `:135-139` (title, `maxLength: 30`) and `:180-185`
(description, `maxLength: 100`) — so their shipped enforced-length behaviour is
preserved. `add_content_dialog.dart:76-95` carries `enforceMaxLength: true` at
both sites (was `maxLengthEnforce: true`, no behaviour change), and
`filter_bottom_sheet.dart`'s three sites set no `maxLength`, so enforcement is
moot there. The delta's table is accurate at every site.
[2.5-AC16]: PASS — the constructor takes no `BuildContext` (`:8-24`) and resolves
`context.tokens` from its own `build` (`:72`, `:160`, `:190`). Grepped `lib/`:
7 `LabeledTextField(` call sites — `add_content_dialog.dart` 2,
`filter_bottom_sheet.dart` 3, `task_detail_screen.dart` 2 — and none passes a
`context:` argument. No reference to `DefaultBorderTextField` or
`default_border_text_field.dart` remains in `lib/`, `test/` or `.claude/`; the
only survivors are two historical mentions in `.agents/` planning docs.
[2.5-AC17]: MANUAL — see above. `contentPadding` is vertical 12 (`:123-126`) over
the `body` 16/1.45 line box, which clears 44 on paper; not asserted, per the
binding constraint against dimension assertions.
[2.5-AC18]: PASS — verified against `app_type_tokens.dart`: `body` = 16/400
(`:92-97`) for input and placeholder, `meta` = 14/500 (`:100-107`) for the label
and the validation message, `caption` = 13/400 (`:172-179`) for helper/counter.
No token is minted or edited — `app_type_tokens.dart` is not in the diff.

No criterion is FAIL or PARTIAL.

## Architectural compliance
Status: PASS

Checked against three sources, each read in full this run rather than inherited
from the Phase 4 review: `tdd.md`, the `flutter-widgets` skill, and the
`flutter-widget-test` skill.

### Against `tdd.md`
No FAILs. Class names, file path, the stateful shape owning and disposing one
`FocusNode` (`:46-59`), the two private sub-widgets in the same file, the
`FormField<String>` composition, the `radius.lg + 4` ring, the untouched
`inputDecorationTheme`, the dropped `suffixIcon` and `context`, and every one of
the seven call-site rows in `## Call-site review` match the design — with the two
`task_detail_screen.dart` rows correctly superseded by `code-plan.md`'s
`## Approved feedback delta` rather than by the stale `tdd.md` decision-4 text.
No package added; `pubspec.yaml` untouched.

### Against `flutter-widgets`
No FAILs.
- **No comments at all** — `labeled_text_field.dart` carries none: not a header,
  not a `///`, not a note above the ring or a token lookup. Confirmed line by
  line across all 205 lines.
- No `default` prefix on the new name; global widget correctly in `lib/widgets/`;
  single file, so the file itself is the public entry point.
- No Widget-returning function or getter — `_FieldLabelRow` and `_FieldFocusRing`
  are widget classes.
- Every dimension the widget writes itself is even: `spacing: 6` / `spacing: 8`,
  `contentPadding` 16/12, ring padding 2 and width 2, `radius.lg + 4` = 20. The
  2px ring/offset and the 1px hairline are §3.2/§1.8/§2.1's own numbers, sanctioned
  by the task brief.
- Outlines solid everywhere; `Expanded` (not `Flexible`) for the label; no outer
  spacing and no padding/gap constructor parameter — the `Container`'s padding at
  `:193` sits *inside* the ring border, which is the widget's own anatomy.
- `context.tokens` throughout, never `Theme.of(context)`; no literal hex, no
  `Colors.red`, no `Colors.grey`; `Colors.transparent` is the one permitted
  literal. All user-facing text via `S.current`; the counter adds no `.arb` key.
- Import order correct: `flutter/material` → `flutter/services` → project, then
  the relative `generated/l10n.dart`, blank-line separated and alphabetised.
- Catalogue row replaced as specified; the "one file per widget family" rule
  sentence is untouched, per the gate decision (that contradiction remains a
  separate live follow-up, not this run's defect).

### Against `flutter-widget-test`
No FAILs. All three tests were checked independently against the review
checklist.
- Names are behaviour statements with condition and outcome; no comments; setup
  is a nine-line subject builder, one action, one expectation each.
- Assertions are visible text and a fired callback — no dimension, gap, radius,
  offset or position is measured anywhere, no colour is asserted, and no widget
  hierarchy is mirrored. **No golden test and no `matchesGoldenFile`.**
- No `Completer`, no fake image bytes, no manually invoked internal builder, no
  arbitrary delay, no zone, no swallowed error.
- No `setUpAll` token or theme pre-resolution — the real `buildDarkTheme()` is
  passed into `pumpWidget` and `GoogleFonts.config.allowRuntimeFetching = false`
  is set at `main`, so handover gotcha #10 is avoided.
- **Imports only the module's public entry point** — the exact defect QA caught
  on item 2.4. The file imports
  `package:gaming_library_assessment_flutter/widgets/labeled_text_field.dart`
  plus the harness `tdd.md ## Testing` permits (`theme_data_dark.dart`,
  `generated/l10n.dart`, `flutter_localizations`, `google_fonts`,
  `flutter_test`, `material`). Nothing private is reached for.
- The self-corrected `find.byType(TextField)` in the read-only tap test is
  acceptable: `TextField` is a public Material class and is the component's
  actual interactive surface, not a module internal or a private sub-widget, so
  the public-surface rule holds. Each test would fail if its behaviour were
  removed and would survive a behaviour-preserving refactor.
- File placement `test/widget/components/` is correct — layer-based, not mirrored
  from `lib/`. At 77 lines and three tests it is proportional to the
  `context_chip_test.dart` / `stat_pill_test.dart` reference shape.

FAILs: NONE

WARNINGs:
1. **Deletion instead of `@Deprecated`, unrecorded in `## Deviation approvals`.**
   `flutter-widgets` says a full rebuild should mark the old widget
   `@Deprecated` rather than delete it outright. `default_border_text_field.dart`
   was deleted. This is correct and deliberate — GATE-1 option A and the Phase 3
   gate both approve the deletion by name, and the task brief mandates it,
   because leaving the file alive keeps `Colors.red` and the caller-passed
   `BuildContext` in the tree. Not a defect. Worth a bookkeeping fix though:
   `orchestrator-state.md ## Deviation approvals` reads `NONE`, so the one place
   a future reader would look for a sanctioned skill deviation does not record
   it. Recommend the orchestrator add the line.
2. **`onChanged` and `helper` have zero call sites.** `flutter-widgets` bars a
   parameter for a case nothing calls yet, and `tdd.md` invoked exactly that rule
   to drop `suffixIcon`. `helper` is criterion-driven — `[2.5-AC3]` requires the
   slot and the counter shares it — so it stands. `onChanged` is a straight
   carry-over from the deleted widget's API (also uncalled there) that `tdd.md`
   lists as "unchanged" and the human approved with the parameter list at the
   Phase 3 gate. Additive and harmless; flagged for a future trim, not this run.
3. **Uncommitted working-tree change.** `.agents/runs/form-fields-20260823/orchestrator-state.md`
   is modified but uncommitted (phase → QA, Dev commit recorded, code-review
   outcome added). Pipeline bookkeeping only, no source file involved. Worth
   naming per the reporting rule; not a scope violation.

### Scope check (git, not `diff-summary.md`'s self-report)
`git diff --name-only 4680deda..79255bdc` over source paths returns exactly the
allowlist and nothing else:

| Path | git | Allowlist |
|---|---|---|
| `lib/widgets/labeled_text_field.dart` | A | CREATE NEW |
| `lib/widgets/default_border_text_field.dart` | D | MODIFY (delete) |
| `lib/widgets/add_content_dialog.dart` | M | MODIFY |
| `lib/features/filter/presentation/widgets/filter_bottom_sheet.dart` | M | MODIFY |
| `lib/features/tracker/presentation/screens/task_detail_screen.dart` | M | MODIFY |
| `.claude/skills/flutter-widgets/SKILL.md` | M | MODIFY (catalogue row only — verified: the diff is one table row, the rule sentence is untouched) |
| `test/widget/components/labeled_text_field_test.dart` | A | TEST FILES |

The range also contains the run folder's own pipeline artifacts
(`ambiguities.md`, `code-plan.md`, `orchestrator-state.md`, `task-brief.md`,
`tdd.md`, `tech-ac.md`), added by the earlier phase commits inside the range, not
by the Dev commit. `git show --name-status 79255bdc` confirms the Dev commit
itself touches exactly the seven allowlisted paths. No file appears in git that
`diff-summary.md` failed to mention, and no generated file was regenerated.

No deviation is claimed by `diff-summary.md`, and none was found, so the empty
`## Deviation approvals` section is consistent (subject to WARNING 1).

## Known and not re-reported
- Three shipped surfaces change appearance on merge — accepted and deliberate at
  GATE-1.
- `_AddContentDialogState.initState` calls `super.initState()` inside its
  `if (widget.titleDescription case final values?)` branch — a real latent bug,
  pre-existing, explicitly out of this item's scope and already recorded in
  `tdd.md` and `orchestrator-state.md`.
- `.claude/skills/flutter-widgets/SKILL.md`'s "one file per widget family"
  contradiction — a separate live follow-up, deliberately untouched.

## Escalation required
NONE

# Task Brief
Source: `tech-ac.md` — item 2.6, `system-foundation-specs.md` §3.2 line 246
Date: 2026-08-24

## Context

Ship §3.2's row-and-hairline-group anatomy as two new unwired widgets, so the
"single hairline between rows only" rule becomes a property the container
guarantees instead of one every future caller has to remember.

## Testing mode

`smoke` — Rule applied: UI-only with no new logic, isolated with no shared
dependencies. Justification: both widgets are stateless presentation with no
data, domain or state layer behind them; the tests exist to hold the [2.6-AC8]
count contract and the two token colours, not to cover logic.

## File allowlist

### CREATE NEW
`lib/widgets/label_value_row.dart` — the row: label, value, optional chevron; no
fill, no radius, no edge of its own.
`lib/widgets/hairline_group.dart` — the card: `surfaceRaised` fill, `lg` radius,
clip, and a hairline between each adjacent pair of its generic children.

### MODIFY EXISTING
`.claude/skills/flutter-widgets/SKILL.md` — add one catalogue row per new
component to the "Existing reusable widgets catalogue" table. Documentation only;
nothing else in that file changes, and in particular the "one file per widget
family" rule sentence is **not** to be edited (live follow-up, human's call).

### TEST FILES
`test/widget/components/label_value_row_test.dart` — chevron shown only when
requested, label/value ink levels, row draws no separator alone.
`test/widget/components/hairline_group_test.dart` — separator counts at one, two
and three children, empty group draws no card, fill and hairline tokens.

## Implementation plan

Step 1: Create `lib/widgets/label_value_row.dart` — `LabelValueRow`, a
`StatelessWidget` with `label`, `value` (both required) and `showChevron`
(default `false`). Interior padding 16 horizontal / 14 vertical, then a row of
the label taking the leftover width and the value at its natural width, plus the
chevron when requested. Both texts use `context.tokens.typography.meta`; the
label copies in `color.ink`, the value keeps the token's `ink70`. No decoration,
no `BorderRadius`, no `Border`, no outer margin, no comments.

Step 2: Create `lib/widgets/hairline_group.dart` — `HairlineGroup`, a
`StatelessWidget` whose only parameter is `children`. Empty list returns
`SizedBox.shrink()`. Otherwise `ClipRRect` at `radius.lg` around a `ColoredBox`
in `color.surfaceRaised` around a `Column` (`MainAxisSize.min`,
`CrossAxisAlignment.stretch`) that emits a `Divider(height: 1, thickness: 1,
color: color.hairline)` before every child except the first. Placement comes from
the index alone — do not add any parameter, flag or per-child option touching
hairlines, and do not inspect a child's type.

Step 3: Create `test/widget/components/label_value_row_test.dart` — four tests,
shape and length per `test/widget/components/context_chip_test.dart`. Import only
`lib/widgets/label_value_row.dart`.

Step 4: Create `test/widget/components/hairline_group_test.dart` — six tests,
same shape. Import only `lib/widgets/hairline_group.dart`.

Step 5: Add the two catalogue rows to
`.claude/skills/flutter-widgets/SKILL.md`, matching the wording style of the
existing rows and ending each with "adds no spacing of its own".

Step 6: Run `flutter analyze` and `flutter test`. Compare against
`orchestrator-state.md`'s recorded baselines, quoted verbatim: Analyzer baseline
`0 errors, 2 warnings, 31 info (33 total)`; Test baseline `+315 -10`. The pass
count should rise only by this run's ten new tests; the ten pre-existing failures
(`tracker_repository_test.dart` 4, `game_detail_cubit_test.dart` 3,
`games_bloc_test.dart` 3) must stay at ten and unchanged.

No code generation is needed: no annotated source, no new `.arb` key, no
`build_runner` step, no `intl_utils` step. Both widgets take their strings from
the caller.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: [2.6-AC1] through [2.6-AC13]

## Constraints

- **No parameter beyond the four named above.** [2.6-AC9] is the point of the
  item: any divider flag, `separatorBuilder`, per-child option, tap callback,
  value-colour override or padding parameter fails it or the minimal-API rule
  that trimmed `suffixIcon` from 2.5. If something looks missing, escalate rather
  than add it.
- **Widget files carry no comments at all** — not a header, not a `///`, not a
  note above the index loop (`flutter-widgets`, stricter than the project rule).
- **Tokens only.** Every colour and radius through `context.tokens`; never
  `Theme.of(context)`, never a literal colour, never `Colors.*`.
- **Even dimensions**: 16 / 14 / 12 / 16-px icon. The 1px hairline is the
  sanctioned exception recorded in `tech-ac.md ## Assumptions` — a hairline has no
  even alternative and two shipped widgets already use 1.
- **No spacing of its own.** Neither widget adds outer padding or margin. The
  row's 16/14 interior padding is its own anatomy, assigned to the row by §4.4 and
  required by [2.6-AC6] — that is interior, not spacing around the widget, and it
  must not be exposed as a parameter.
- **Do not touch** `group_task_item.dart`, `task_item.dart` or
  `horizontal_separator.dart`, and do not make any existing widget reference the
  new components ([2.6-AC13]). `HorizontalSeparator`'s `Colors.grey` and
  `width: context.screenWidth` are a recorded follow-up, not this run's work.
- **Never a golden test**, and no assertion of a dimension, gap, radius or
  position. A colour assertion must name the design token, not a literal hex.
- Test files import only the two public widget files; no test reaches past a
  public component into anything else.
- Import ordering per `flutter-widgets`: package imports alphabetised, `const`
  wherever the linter allows.
- Both classes are `StatelessWidget`. Neither is `final`/`sealed`/`base`.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside the
allowlist — escalate instead.

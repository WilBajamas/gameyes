# Task Brief
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §3.3 · `onboarding-auth-design-spec.md` §3, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13

## Context

Rework the global logo placeholder into the spec's two-preset, dashed-outline
placeholder slot, migrate its one caller, and correct the two reference-doc
passages that still describe the old solid-border API.

## Testing mode

smoke — Rule applied: "UI-only with no new logic, isolated with no shared
dependencies" — Justification: one presentational widget with no state, no
repository, and one caller. It sits on the auth screen but touches no
authentication logic, so the `coverage` auth rule does not apply; [1.4-AC16]
still fixes the exact assertion list, including the dashed-outline and dash-count
checks that cover the painter.

## File allowlist

### CREATE NEW
`lib/widgets/placeholder_slot.dart` — the reworked placeholder slot: enum
`PlaceholderSlotSize`, widget `PlaceholderSlot`, private `_DashedOutline`
painter. Created by renaming `logo_placeholder.dart`, not written beside it.

### MODIFY EXISTING
`lib/widgets/logo_placeholder.dart` — removed by that rename; no file may remain
at this path and no `@Deprecated` alias is left behind.
`lib/features/auth/presentation/screens/auth_screen.dart` — import swap plus the
one header call site in `_AuthContent`; nothing else in the file changes.
`.agents/references/onboarding-auth-design-spec.md` — §9's replacement-checklist
line and §10's Flutter-composition bullet, both of which still say solid border
and explicit width/height.
`.claude/skills/flutter-widgets/SKILL.md` — one new row in the reusable-widgets
catalogue, after the `StatusChip` row.

### TEST FILES
`test/widget/components/placeholder_slot_test.dart` — both presets' box size,
radius, `ink12` fill, dashed 1px `ink24` outline with no solid `Border`, marker
text present only at the app mark preset and in the display-face 700 style,
dash count at the 20px preset, self-sizing in fixed-size and unbounded parents,
and no spacing of its own.

`test/widget/auth/auth_screen_test.dart` is deliberately NOT allowlisted. Its
`find.text('LOGO')` assertion must keep passing untouched ([1.4-AC16]).

## Implementation plan

Step 1: Rename `lib/widgets/logo_placeholder.dart` to
`lib/widgets/placeholder_slot.dart` (`git mv`), leaving nothing at the old path.

Step 2: In `lib/widgets/placeholder_slot.dart`, replace the widget with the enum
`PlaceholderSlotSize` (`appMark` dimension 88, `providerMark` dimension 20, plus
an `isAppMark` getter) and `PlaceholderSlot`, a `const` `StatelessWidget` taking
one required `size` input: `SizedBox.square` → `DecoratedBox` with the `ink12`
fill and the resolved radius (literal 20 for the app mark, the `xs` token for the
provider mark, chosen with an exhaustive switch expression) → `CustomPaint` →
`Center` + `Text('LOGO')` at the app mark preset only, `null` child otherwise.
The marker style is `context.tokens.typography.zoneLabel.style.copyWith(
fontSize: 14, letterSpacing: 2.24)` — no font family, weight, or colour declared
in the widget.

Step 3: In the same file, add the private `_DashedOutline` `CustomPainter`: build
one `Path` from the `RRect` deflated by half the 1px stroke, walk
`Path.computeMetrics()`, and draw alternating 2px dash / 2px gap segments in
`ink24`; `shouldRepaint` compares colour and border radius. One pattern serves
both presets. Dash and gap live as private `static const` members of the painter,
not as bare top-level values.

Step 4: In `lib/features/auth/presentation/screens/auth_screen.dart`, swap the
`logo_placeholder.dart` import for `placeholder_slot.dart` and change the header
child to `const Center(child: PlaceholderSlot(size: PlaceholderSlotSize.appMark))`.
Leave the surrounding column, gaps, and `BlocBuilder` untouched.

Step 5: Write `test/widget/components/placeholder_slot_test.dart` per the
allowlist entry above, following `test/widget/components/cover_tile_test.dart`'s
pumping and font warm-up shape. No `matchesGoldenFile`, no golden files.

Step 6: In `.agents/references/onboarding-auth-design-spec.md`, correct §9's
`88px` app mark checklist line and §10's `LogoPlaceholder` bullet so both
describe the dashed two-preset widget under its new name.

Step 7: In `.claude/skills/flutter-widgets/SKILL.md`, add the catalogue row for
`PlaceholderSlot` noting the two presets, the dashed outline, and that it adds no
spacing of its own.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s recorded baselines, quoted verbatim —
`Analyzer baseline: 0 errors, 2 warnings, 32 info — captured 2026-08-13T05:59:30Z`
and `Test baseline: +257 -11 — captured 2026-08-13T06:03:00Z`, with
`Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart
(4), test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`. Only a
new, in-scope failure is yours to fix. No `build_runner` step is needed: nothing
in this run is annotated or generated.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 1.4-AC1 … 1.4-AC17

## Constraints

- `pubspec.yaml` is read-only. No package for the dashed border — Flutter's SDK
  only ([1.4-AC17]). A package here would be a recorded deviation, not a choice.
- Never `Theme.of(context)` — read tokens through `context.tokens`
  (`ContextExtensions`, `lib/core/utils/extensions.dart`). No colour, radius, or
  font literal beyond the ones `tech-ac.md` allows plus the marker's 14px /
  2.24 tracking (see `tdd.md ## Design notes`).
- Private helper widgets and painters stay in the same file; no
  `Widget`-returning function or getter; no `default` name prefix.
- No spacing of its own — no outer padding, margin, or spacer, and no
  `EdgeInsets`/`padding`/gap constructor parameter (`flutter-widgets` standing
  convention, [1.4-AC11]).
- Lints: single quotes, trailing commas on multi-line argument lists, 80-char
  lines, `const` wherever permitted, no `default:` on an enum switch.
- Import order: Dart SDK, then package (flutter → third-party → project), each
  group blank-line separated and alphabetised.
- Comments: few, plain English, only where the code is not self-evident. The
  literal radius 20 and the dash pattern each earn one short line; nothing else
  does.
- Tests are unit and widget only. Never a golden test or `matchesGoldenFile`,
  whatever the criteria say about appearance.
- Do not weaken, edit, or delete `test/widget/auth/auth_screen_test.dart`.
- Do not open the provider rows or any screen other than the auth screen.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.

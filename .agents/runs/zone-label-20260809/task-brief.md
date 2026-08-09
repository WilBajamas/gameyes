# Task Brief
Source: Week 2 task brief item 1.1 · `system-foundation-specs.md` §3.2 "Zone label"
Date: 2026-08-09

## Context

Ships the app-wide zone-label primitive — caps heading in the `zoneLabel`
token, optional trailing cyan link in the `zoneLink` token, and the vertical
gap that separates zones — so screens stop hand-rolling section headers. The
component is delivered unwired; no screen changes in this run.

## Testing mode

smoke — Rule applied: "UI-only with no new logic, isolated with no shared
dependencies" — Justification: a stateless presentation widget with no data,
domain or state layer, no persistence, and no current caller. It is not yet a
shared utility used by 3+ features, so the `coverage` rule does not trigger.
[1.1-AC11] enumerates the behaviours the widget test must cover; that list is
the required scope, not a suggestion.

## File allowlist

### CREATE NEW
`lib/widgets/zone_label.dart` — the `ZoneLabel` widget plus its file-private
`_ZoneLink` helper.

### MODIFY EXISTING
`.claude/skills/flutter-widgets/SKILL.md` — add one row to the "Existing
reusable widgets catalogue" table for `ZoneLabel`. Table row only; change
nothing else in that file.

### TEST FILES
`test/widget/components/zone_label_test.dart` — covers uppercase rendering,
label style, link style, link presence/absence, single callback invocation, and
the absence of a divider.

## Implementation plan

Step 1: Create `lib/widgets/zone_label.dart` — `ZoneLabel` (StatelessWidget,
`const` constructor, required `label`, optional `linkLabel` and
`onLinkPressed`) rendering `Padding(top: 40, bottom: 16)` → `Row` →
`Expanded(Text)` with the label formatted and styled by
`context.tokens.typography.zoneLabel`, single-line with ellipsis, followed by
the link through a collection `if` only when both link parameters are non-null.

Step 2: In the same file, add the file-private `_ZoneLink` StatelessWidget —
`GestureDetector` (`HitTestBehavior.opaque`) → `ConstrainedBox(minHeight: 44)`
→ `Center` → `Text` styled from `context.tokens.typography.zoneLink.style`, no
horizontal padding, no decoration.

Step 3: Create `test/widget/components/zone_label_test.dart` — pump
`MaterialApp(theme: buildDarkTheme(), home: Scaffold(body: ZoneLabel(...)))`
after `TestWidgetsFlutterBinding.ensureInitialized()` and
`GoogleFonts.config.allowRuntimeFetching = false`, then assert the behaviours
listed in `code-plan.md ## TEST FILES`. Compare individual style fields
(`fontSize`, `fontWeight`, `letterSpacing`, `color`) against
`AppTokens.dark.typography.<token>.style` rather than whole-`TextStyle`
equality — the font family will not resolve identically in a test environment.

Step 4: Modify `.claude/skills/flutter-widgets/SKILL.md` — add the `ZoneLabel`
row to the catalogue table, alphabetically irrelevant, append at the end of the
table.

Final step: run `flutter analyze` and `flutter test`, then compare against
`orchestrator-state.md`, quoted verbatim: `Analyzer baseline: 0 errors, 2
warnings, 32 info — captured 2026-08-09T16:24:00Z` and `Test baseline: +214 -11
— captured 2026-08-09T16:20:00Z`, with `Pre-existing test failures:
test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`. Only a
new, in-scope failure or analyzer error is yours to fix.

No `build_runner` checkpoint applies: nothing annotated is created and the
widget test mocks nothing. No `.arb` edit and no Flutter Intl regeneration
applies: the widget contains no user-facing string.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 1.1-AC1, 1.1-AC2, 1.1-AC3, 1.1-AC4, 1.1-AC5, 1.1-AC6, 1.1-AC7,
1.1-AC8, 1.1-AC9, 1.1-AC10, 1.1-AC11, 1.1-AC12

## Constraints

- Theme access is `context.tokens` / `context.themeData` from
  `lib/core/utils/extensions.dart`. Never `Theme.of(context)`
  (`dart-style.md`, `flutter-widgets`).
- Reuse `AppTypeTokens.zoneLabel` and `.zoneLink` exactly as they exist,
  including `AppTextToken.format()` for casing. No new, duplicated or
  re-declared token; no new colour, type or spacing token.
- Global widget naming: no `default` prefix on new widgets; file
  `snake_case.dart` in `lib/widgets/`. Extracted UI is always a widget class,
  never a `Widget`-returning function or getter (`flutter-widgets`).
- A helper used only by its parent stays a private class in the same file
  (`flutter-widgets`).
- Do not use `ButtonPressScale` for the link — see `tdd.md ## Reuse decisions`
  (it draws a focus border and a press scale, both out of scope).
- `const` wherever the linter permits; `EdgeInsets`, `TextStyle`, `Color`,
  `Duration` literals are `const` (`dart-style.md`).
- Lints: `prefer_single_quotes`, `require_trailing_commas`,
  `lines_longer_than_80_chars` (hard 80-char limit), `avoid_unnecessary_containers`
  (`dart-style.md`).
- Import ordering: dart SDK, then package (flutter → third-party → project),
  then relative; groups blank-line separated and alphabetised. Prefer package
  imports (`dart-style.md`).
- Comments: few, plain English, explain only what the code cannot. No `///`
  doc comment restating a parameter name (`execution.md`).
- No new package in `pubspec.yaml` — it is read-only.
- Only unit and widget tests. Never a golden test, never `matchesGoldenFile`,
  whatever [1.1-AC7]/[1.1-AC8] say about appearance (`execution.md`,
  `testing-conventions.md`).
- Test naming: `'should [expected behaviour] when [condition]'`; long
  descriptions may use `// ignore: lines_longer_than_80_chars`
  (`testing-conventions.md`).
- Tests touching `AppTokens`/GoogleFonts must call
  `TestWidgetsFlutterBinding.ensureInitialized()` and set
  `GoogleFonts.config.allowRuntimeFetching = false` before the tokens are
  touched — see `test/widget/onboarding/welcome_screen_test.dart`.
- `test/widget/components/` is a new folder: this widget belongs to no feature,
  matching the existing non-feature `test/widget/theme/` grouping.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to
make tests pass. Do not add packages to `pubspec.yaml` or touch files outside
the allowlist — escalate instead.

# Task Brief
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §0, §1.9, §3.3 ·
`onboarding-auth-design-spec.md` §3, §5, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13
Revised: 2026-08-13 (Phase 3 human override — dashed outlines removed project-wide)

## Context

Rework the global logo placeholder into the spec's two-preset placeholder slot with a plain
solid 1px outline, migrate its one caller, and correct every document that still specifies
or justifies a dashed border — two reference docs and the `flutter-widgets` skill — while
recording "outlines are always solid" as a standing project principle.

Revised in place from the original 2026-08-13 brief, per `handover.md`'s rule that a
substantial Phase 3 revision may correct `tdd.md`/`task-brief.md` rather than only append a
delta. Two things moved: the dashed outline became a solid one (so the `CustomPainter` is
gone from the design entirely), and the doc-correction scope went from one file to three.
The allowlist below is the current one — do not reconstruct it from any earlier version.

## Testing mode

smoke — Rule applied: "UI-only with no new logic, isolated with no shared dependencies" —
Justification: one presentational widget with no state, no repository, and one caller. It
sits on the auth screen but touches no authentication logic, so the `coverage` auth rule
does not apply; [1.4-AC16] still fixes the exact assertion list. That list shrank with the
revision — there is no painter left to test, so the dash-geometry assertions are gone and
the outline assertion is a plain solid-border check.

## File allowlist

### CREATE NEW
`lib/widgets/placeholder_slot.dart` — the reworked placeholder slot: enum
`PlaceholderSlotSize` and widget `PlaceholderSlot`, nothing else. Created by renaming
`logo_placeholder.dart`, not written beside it. No private painter class.

### MODIFY EXISTING
`lib/widgets/logo_placeholder.dart` — removed by that rename; no file may remain at this
path and no `@Deprecated` alias is left behind.

`lib/features/auth/presentation/screens/auth_screen.dart` — import swap plus the one header
call site in `_AuthContent`; nothing else in the file changes.

`.agents/references/onboarding-auth-design-spec.md` — four passages: §3's anatomy line and
the paragraph under it, §5's anatomy line and its rationale paragraph, §9's replacement
checklist bullet, §10's Flutter-composition bullet.

`.agents/references/system-foundation-specs.md` — **newly allowlisted by this revision**;
three passages: §0 Principles gains a new numbered entry, §1.9's iconography sentence, and
§3.3's "Placeholder slot" row.

`.claude/skills/flutter-widgets/SKILL.md` — two edits: one new convention bullet under
"Building a new reusable widget", and one new row in the reusable-widgets catalogue after
the `StatusChip` row.

### TEST FILES
`test/widget/components/placeholder_slot_test.dart` — both presets' box size, radius,
`ink12` fill, a solid 1px `ink24` `Border` with no `CustomPaint` anywhere in the slot's
subtree, marker text present only at the app mark preset and in the display-face 700 style,
self-sizing in fixed-size and unbounded parents, and no spacing of its own.

`test/widget/auth/auth_screen_test.dart` is deliberately NOT allowlisted. Its
`find.text('LOGO')` assertion must keep passing untouched ([1.4-AC16]).

## Implementation plan

Step 1: Rename `lib/widgets/logo_placeholder.dart` to `lib/widgets/placeholder_slot.dart`
(`git mv`), leaving nothing at the old path.

Step 2: In `lib/widgets/placeholder_slot.dart`, replace the widget with the enum
`PlaceholderSlotSize` (`appMark` dimension 88, `providerMark` dimension 20, plus an
`isAppMark` getter) and `PlaceholderSlot`, a `const` `StatelessWidget` taking one required
`size` input: `SizedBox.square` → `DecoratedBox` whose single `BoxDecoration` carries the
`ink12` fill, the resolved radius (literal 20 for the app mark, the `xs` token for the
provider mark, chosen with an exhaustive switch expression) and
`Border.all(color: ink24)` → `Center` + `Text('LOGO')` at the app mark preset only, `null`
child otherwise. Write `Border.all` with **no `width` argument**: its default is already
1.0, and `avoid_redundant_argument_values` is an enabled lint here, so an explicit
`width: 1` would add a new analyzer info beyond the recorded baseline. The border is still
1px, and the test asserts 1px ([1.4-AC7]). The marker style is
`context.tokens.typography.zoneLabel.style.copyWith(fontSize: 14, letterSpacing: 2.24)` —
no font family, weight, or colour declared in the widget. The file ends with those two
declarations: no private painter, no `dart:math` import, no dash or gap constant.

Step 3: In `lib/features/auth/presentation/screens/auth_screen.dart`, swap the
`logo_placeholder.dart` import for `placeholder_slot.dart` and change the header child to
`const Center(child: PlaceholderSlot(size: PlaceholderSlotSize.appMark))`. Leave the
surrounding column, gaps, and `BlocBuilder` untouched.

Step 4: Write `test/widget/components/placeholder_slot_test.dart` per the allowlist entry
above and the assertion list in `code-plan.md`, following
`test/widget/components/cover_tile_test.dart`'s pumping and font warm-up shape. No
`matchesGoldenFile`, no golden files.

Step 5: In `.agents/references/onboarding-auth-design-spec.md`, correct all four passages
([1.4-AC15a–c]) — §3's `1px dashed` anatomy line and the "reserved slot, not a design"
paragraph beneath it, §5's `1px dashed` anatomy line and the "dashed square is honest about
being empty" paragraph, §9's `LogoPlaceholder` checklist bullet, and §10's
`LogoPlaceholder` composition bullet. Both rewritten paragraphs must keep their original
point and rest it on the slot being empty, not on its edge being dashed. Leave §5's
`rgba(255,255,255,.18)`/`.32` values alone — only the word `dashed` changes on that line.

Step 6: In `.agents/references/system-foundation-specs.md`, make all three corrections —
§3.3's "Placeholder slot" row ([1.4-AC15d]), §1.9's "reserve a dashed placeholder box"
sentence ([1.4-AC15e]), and a new §0 Principles entry stating that outlines, borders and
hairlines are always solid ([1.4-AC18]). Append the principle as item **6**; do not insert
it mid-list, because §0 entries are cited by number elsewhere and renumbering 1–5 would
break live references.

Step 7: In `.claude/skills/flutter-widgets/SKILL.md`, add the `PlaceholderSlot` catalogue
row ([1.4-AC15f]) and the "Outlines are always solid" bullet under "Building a new reusable
widget", placed beside "No spacing of its own" and pointing at
`system-foundation-specs.md` §0 as the full rule.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s recorded baselines, quoted verbatim —
`Analyzer baseline: 0 errors, 2 warnings, 32 info — captured 2026-08-13T05:59:30Z`
and `Test baseline: +257 -11 — captured 2026-08-13T06:03:00Z`, with
`Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4),
test/cubit/game_detail/game_detail_cubit_test.dart (3),
test/cubit/games/games_bloc_test.dart (3), test/widget_test.dart (1)`. Only a new, in-scope
failure is yours to fix. No `build_runner` step is needed: nothing in this run is annotated
or generated.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria` (revised 2026-08-13 — read its
revision note before starting)
IDs in scope: 1.4-AC1 … 1.4-AC18

## Constraints

- **No dashed or dotted outline anywhere, and no custom painting for a border**
  ([1.4-AC7], [1.4-AC8]). No `CustomPainter`/`CustomPaint`, no `Path`/`PathMetrics`
  dashing, no `dashWidth`/`gap` constant or parameter. A `Border` in a `BoxDecoration` is
  the whole implementation. This is now a standing project rule, not a task preference —
  step 6 writes it into `system-foundation-specs.md` §0.
- `pubspec.yaml` is read-only. No package for the border ([1.4-AC17]). A package here would
  be a recorded deviation, not a choice.
- Never `Theme.of(context)` — read tokens through `context.tokens` (`ContextExtensions`,
  `lib/core/utils/extensions.dart`). No colour, radius, or font literal beyond the ones
  `tech-ac.md` allows plus the marker's 14px / 2.24 tracking (see `tdd.md ## Design notes`).
- Private helper widgets stay in the same file; no `Widget`-returning function or getter;
  no `default` name prefix.
- No spacing of its own — no outer padding, margin, or spacer, and no
  `EdgeInsets`/`padding`/gap constructor parameter (`flutter-widgets` standing convention,
  [1.4-AC11]).
- Doc edits: fix the rationale, not just the adjective. A passage that still argues a
  dashed edge is what signals pending art fails [1.4-AC15] even if its anatomy line now
  says solid.
- Lints: single quotes, trailing commas on multi-line argument lists, 80-char lines,
  `const` wherever permitted, no `default:` on an enum switch, and no argument passed at
  its own default value (`avoid_redundant_argument_values` — see step 2's `Border.all`).
- Import order: Dart SDK, then package (flutter → third-party → project), each group
  blank-line separated and alphabetised.
- Comments: few, plain English, only where the code is not self-evident. The literal radius
  20 earns one short line; nothing else in the widget does.
- Tests are unit and widget only. Never a golden test or `matchesGoldenFile`, whatever the
  criteria say about appearance.
- Do not weaken, edit, or delete `test/widget/auth/auth_screen_test.dart`.
- Do not open the provider rows or any screen other than the auth screen.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist — escalate
instead.

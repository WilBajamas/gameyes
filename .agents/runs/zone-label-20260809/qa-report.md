# QA Report
Source: Week 2 task brief item 1.1 · `system-foundation-specs.md` §3.2 "Zone label"
Date: 2026-08-12

Overall result: PASS — pending manual checks

## Manual verification required
1.1-AC10 — Place `ZoneLabel(label: <a label longer than the row width>, linkLabel: 'See all', onLinkPressed: ...)` in a 24px-guttered column — expect the label on one line ending in an ellipsis, the link fully rendered at its intrinsic width, no yellow overflow stripe and no overlap between the two.

## Static analysis
Status: PASS
Errors: NONE
`flutter analyze` — 34 issues: 0 errors, 2 warnings, 32 info. Identical to
`orchestrator-state.md`'s `Analyzer baseline: 0 errors, 2 warnings, 32 info`.
No issue of any severity is attributed to `lib/widgets/zone_label.dart` or
`test/widget/components/zone_label_test.dart`.

`build_runner`: not applicable and not run — the allowlist contains no
annotated source and the widget test mocks nothing, so no generated output
depends on this change (`generation.md` scope, confirmed in `tdd.md ## Out of
scope`).

## Test results
Status: PASS
Testing mode: smoke — allowlisted test file only.
Tests run: 10  |  Passed: 10  |  Failed: 0
Failing tests: NONE
No comparison against the `Test baseline: +214 -11` full-suite figure was needed;
smoke mode scopes the run to `test/widget/components/zone_label_test.dart`.

## Coverage gaps (coverage mode only)
N/A — testing mode is `smoke`.

## Acceptance criteria
1.1-AC1: PASS — `lib/widgets/zone_label.dart:4` `class ZoneLabel extends StatelessWidget` with `const` constructor at :5; global `lib/widgets/` placement, no `default` prefix, plain Flutter widgets only, sole import is `package:flutter/material.dart` plus a project import (:1–2) — no new third-party package.
1.1-AC2: PASS — `zone_label.dart:12` `final String label;` required at :7; the file contains no string literal at all, so no user-facing text is baked in.
1.1-AC3: PASS — `zone_label.dart:18,29,30` read `context.tokens.typography.zoneLabel` and use `.format(label)` + `.style`; no `Theme.of(context)`, no literal size/weight/colour/letter-spacing anywhere in the file. Tests `'should render the label in capitals when the caller passes lower case'` (renders `NOW PLAYING`, `now playing` absent) and `'should style the label from the zoneLabel token when rendering'` (fontSize/fontWeight/letterSpacing/color vs `AppTokens.dark.typography.zoneLabel.style`).
1.1-AC4: PASS — `zone_label.dart:35–36` collection `if (linkLabel != null && onLinkPressed != null)` gates the single `_ZoneLink`, styled from `zoneLink` at :57. Tests `'should style the link from the zoneLink token when a link is supplied'`, `'should render the link when both text and callback are supplied'`, `'should render no link when only the text is supplied'`, `'should render no link when only the callback is supplied'`, `'should invoke the callback once when the link is tapped'` (asserts exactly 1).
1.1-AC5: PASS — the collection `if` at `zone_label.dart:35` adds no child at all when the link is absent, so no placeholder or reserved width exists; the `Expanded` at :27 takes the full row. Tests `'should render no link when only the text is supplied'` / `'…only the callback is supplied'` assert no `GestureDetector` descendant of `ZoneLabel`.
1.1-AC6: PASS — `zone_label.dart:54–55` `ConstrainedBox(constraints: const BoxConstraints(minHeight: 44))` constrains height only; the `Text` at :57 keeps the unmodified `zoneLink.style`. Test `'should keep the link tap target at least 44 high when rendering'` asserts height >= 44 *and* that the link's `fontSize` still matches the token.
1.1-AC7: PASS — the widget's whole subtree is `Row`/`Expanded`/`Text`/`GestureDetector`/`ConstrainedBox`/`Center`/`Text` (`zone_label.dart:25–61`); no `Divider`, `Border`, `BoxDecoration`, shadow or ordinal appears in the file in any configuration. Test `'should render no divider in any configuration'` covers both with and without a link.
1.1-AC8: PASS — `zone_label.dart:25` `Row` is the root widget returned from `build`; no `Padding`, `Container`, `SizedBox` or margin wraps it, and the constructor (:5–10) exposes only `label`, `linkLabel`, `onLinkPressed` — no `EdgeInsets`/`padding`/gap parameter. Test `'should add no vertical spacing around the label when rendering'` asserts `ZoneLabel` height equals the label `Text` height and that no `Padding` ancestor sits above the `Row`. (The `Center` at :56 centres text inside the link's own 44px hit target — the tap target's anatomy, not space around the widget; explicitly reconciled in `tdd.md` "Height note".)
1.1-AC9: PASS — no horizontal padding anywhere: `zone_label.dart:25` `Row` root has none and `_ZoneLink` (:50–60) adds none, so the widget fills the width its parent gives it.
1.1-AC10: MANUAL — code is correct (`zone_label.dart:31–32` `maxLines: 1` + `overflow: TextOverflow.ellipsis`, label in `Expanded` at :27 so the link keeps its intrinsic width and cannot be clipped or overlapped), but no test exercises an over-long label — [1.1-AC11] did not require one and this is layout appearance. See the manual check above.
1.1-AC11: PASS — `test/widget/components/zone_label_test.dart` covers every enumerated behaviour: uppercase rendering, label style, link style, link present/absent both ways, single callback invocation, no divider. No `matchesGoldenFile` and no golden test in the file. The two extra tests (44px hit target, flush render) are the approved additions from `code-plan.md ## TEST FILES`. All 10 pass.
1.1-AC12: PASS — `.claude/skills/flutter-widgets/SKILL.md` catalogue gains `| ZoneLabel | zone_label.dart | Caps section heading with optional trailing link; adds no spacing of its own |`, appended after the existing `AddContentDialog` row.

## Architectural compliance
Status: PASS

Against `tdd.md`: class names (`ZoneLabel`, file-private `_ZoneLink`), file path
`lib/widgets/zone_label.dart`, constructor surface, `Row`-as-root structure,
`GestureDetector(opaque)` → `ConstrainedBox(44)` → `Center` → `Text` link
composition, theme via `context.tokens`, `ButtonPressScale` and
`HorizontalSeparator` both correctly not used, and `44` as the only numeric
literal — all match the design exactly. No new package; `pubspec.yaml`
untouched.

Against the `flutter-widgets` skill, including the new standing convention added
this run: placement in `lib/widgets/`, categorical name with no `default`
prefix, `const` constructor, private helper in the same file, plain Flutter
widgets, no `Theme.of(context)`, no hardcoded user-facing string, import
ordering (flutter → project, alphabetised, blank-line separated), no golden
test, no `Widget`-returning function or getter. **"No spacing of its own"** is
satisfied both ways — no outer padding/margin/spacer and no spacing parameter in
the API. Comment discipline holds: two comments, both explaining a *why* the
code cannot state (type-promotion locals, and the deliberate absence of
padding); no `///` parameter-restating doc comments.

Against `.claude/skills/flutter-widgets/SKILL.md` itself: both edits land exactly
where `code-plan.md` specified — the convention bullet between "Configurable, not
hardcoded." and "Reuse before rebuilding.", and the catalogue row appended last.
Nothing else in the file changed. This second edit is wider than [1.1-AC12]'s
literal wording but is recorded approved scope (`tdd.md ## Revision decisions`,
`code-plan.md ## Approved feedback delta`, human-directed at the Phase 3 gate),
so it is not drift.

FAILs: NONE
WARNINGs: NONE

## Scope check (git, not self-report)
`git diff --name-only 063cf88..2a220f63` limited to the dev commit shows exactly
three files — `lib/widgets/zone_label.dart`,
`test/widget/components/zone_label_test.dart`,
`.claude/skills/flutter-widgets/SKILL.md` — all allowlisted. No file appears in
git that `diff-summary.md` failed to mention. No deviations declared, and
`orchestrator-state.md ## Deviation approvals` is correspondingly `NONE`.

Worth reporting, not a scope violation: the working tree has five uncommitted
modifications, all pipeline artifacts inside the run folder
(`tech-ac.md`, `tdd.md`, `task-brief.md`, `code-plan.md`,
`orchestrator-state.md`) plus untracked `diff-summary.md`. These are the Phase 3
revision and Phase 4B state updates, not source. QA verified against the
working-tree (revised) `tech-ac.md`, which is the canonical copy. They should be
committed before merge so the reversed [1.1-AC8] rationale is not lost.

## Escalation required
NONE

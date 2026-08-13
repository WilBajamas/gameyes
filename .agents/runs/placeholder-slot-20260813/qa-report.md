# QA Report
Source: Week 2 task brief item 1.4 · `system-foundation-specs.md` §0, §1.9, §3.3 ·
`onboarding-auth-design-spec.md` §3, §5, §9, §10 · `flutter-widgets` skill
Date: 2026-08-13

Overall result: PASS — pending manual checks

Verified against `tech-ac.md` as revised 2026-08-13 (Phase 3 human override): solid
outline is the current requirement, dashing is forbidden. The absence of any dashed
border, `CustomPainter` or dash constant is therefore correct, not a spec gap.

## Manual verification required

[1.4-AC9] — Open the auth screen (`AuthScreen`, any state) — expect the `LOGO` marker
centred inside the 88px box in Space Grotesk 700 at 14px with wide tracking, fully
contained: no clipping at the box edges and no horizontal bleed past the border. The
label grew from the old 10px `microLabel` to 14px with `letterSpacing: 2.24`, so the
glyph run is roughly 55–60px wide inside an 88px box minus a 1px border. Tight but
expected to fit; a widget test cannot see paint overflow from a `Center` child, so a
human must look.

[1.4-AC7] — Open the auth screen — expect one continuous solid hairline around all four
sides of the box, following the 20px corner radius, with no visible break, doubling, or
corner artefact.

[1.4-AC12] — Open the auth screen — expect the placeholder in the same header position
as before, still 88×88, still centred, with the same 32px gap to the welcome headline
beneath it; only the marker's type treatment should look different.

## Static analysis

Status: PASS
Errors: NONE

`flutter analyze` — 34 issues total: 0 errors, 2 warnings, 32 info. Matches the recorded
`Analyzer baseline: 0 errors, 2 warnings, 32 info` exactly. Zero issues attributed to
`lib/widgets/placeholder_slot.dart`, `lib/features/auth/presentation/screens/auth_screen.dart`
or `test/widget/components/placeholder_slot_test.dart`.

`build_runner` not run: no allowlisted file is annotated and nothing in this run is
generated (`task-brief.md` final step states the same). No generated output is in scope,
so analysis is not running against stale output.

## Test results

Status: PASS
Tests run: 276  |  Passed: 265  |  Failed: 11

Testing mode: `smoke`.

- `test/widget/components/placeholder_slot_test.dart` — 8/8 passed.
- `test/widget/auth/auth_screen_test.dart` — 4/4 passed, run unmodified (git confirms the
  file is untouched between `c1db072` and the Dev commit).
- Full suite — `+265 -11`. Baseline is `+257 -11`; +8 is exactly the new file. The 11
  failures are precisely the recorded pre-existing set, by file and count:
  `test/repository/tracker/tracker_repository_test.dart` (4),
  `test/cubit/game_detail/game_detail_cubit_test.dart` (3),
  `test/cubit/games/games_bloc_test.dart` (3), `test/widget_test.dart` (1).
  No new, in-scope failure.

No `matchesGoldenFile` and no golden files in the new test.

## Coverage gaps (coverage mode only)

N/A — testing mode is `smoke`.

## Acceptance criteria

1.4-AC1: PASS — `lib/widgets/logo_placeholder.dart` is deleted in the Dev commit and
`lib/widgets/placeholder_slot.dart` created (git shows both in `482a319`); `ls lib/widgets/`
has no `logo_placeholder.dart`, and a repo-wide grep for `LogoPlaceholder`/`logo_placeholder`
across `lib/`, `test/`, `.agents/references/` and `.claude/` returns nothing. No `@Deprecated`
alias anywhere in the file.

1.4-AC2: PASS — `placeholder_slot.dart:15` `class PlaceholderSlot extends StatelessWidget`,
file and class names agree, no `default` prefix, `const` constructor at line 16, plain
Flutter widgets only, no helper class and no `Widget`-returning function or getter in the
50-line file.

1.4-AC3: PASS — `placeholder_slot.dart:16-18`: the only constructor input is
`required this.size` of type `PlaceholderSlotSize`. No `width`/`height`/`size` dimension
parameter survives; the enum at lines 4-13 has exactly two values.

1.4-AC4: PASS — `placeholder_slot.dart:5-6` (`appMark(dimension: 88)`,
`providerMark(dimension: 20)`) rendered via `SizedBox.square` at line 25. Test
`'should render an 88 box at the app mark preset and a 20 box at the provider mark preset'`
asserts `Size(88, 88)` and `Size(20, 20)`.

1.4-AC5: PASS — `placeholder_slot.dart:30-33`, exhaustive switch: `appMark => 20` (literal),
`providerMark => tokens.radius.xs` (= 6, `app_radius_tokens.dart:34`). No new radius token
declared. Test `'should round the app mark to 20 and the provider mark to the xs radius'`.

1.4-AC6: PASS — `placeholder_slot.dart:29` `color: tokens.color.ink12`. No colour literal in
the file. Test `'should fill both presets with ink12'`.

1.4-AC7: PASS (with the visual check above) — `placeholder_slot.dart:34`
`border: Border.all(color: tokens.color.ink24)` on the same `BoxDecoration` as the
`borderRadius`; `Border.all`'s default width is 1.0, omitted deliberately for
`avoid_redundant_argument_values`. Test
`'should draw a solid 1px ink24 border at both presets'` asserts `isUniform`, and per side
`color == ink24`, `width == 1`, `style == BorderStyle.solid`, at both presets.

1.4-AC8: PASS — verified independently by reading the whole file: no `CustomPainter`, no
`CustomPaint`, no `Path`/`PathMetrics`, no `dart:math` import, no `dashWidth`/`gap`/interval
constant or parameter anywhere in `placeholder_slot.dart` (its only imports are
`flutter/material.dart` and the project's `extensions.dart`). One `Border.all` serves both
presets. Test `'should not custom-paint its outline'` guards it with a `findsNothing` on
`CustomPaint` in the slot's subtree at both presets.

1.4-AC9: MANUAL (code correct, appearance to confirm) — `placeholder_slot.dart:36-46`:
`Text('LOGO')` inside a `Center`, app-mark preset only (`size.isAppMark ? ... : null`);
style is `tokens.typography.zoneLabel.style.copyWith(fontSize: 14, letterSpacing: 2.24)`.
`zoneLabel` is Space Grotesk `w700` at `ink55` (`app_type_tokens.dart:82-89`), so the widget
declares no family, weight or colour of its own; `2.24` is `.16em` at 14px. Test
`'should render the LOGO marker in the display face at 700 only at the app mark preset'`
asserts w700 / 14 / 2.24 / `ink55` / the `zoneLabel` family, and `findsNothing` for `Text`
at the provider preset. Human check: fit inside the 88px box — see above.

1.4-AC10: PASS — `SizedBox.square(dimension: size.dimension)` at
`placeholder_slot.dart:25-26` fixes both axes. Test
`'should hold its box inside a fixed-size parent and inside an unbounded parent'` measures
`Size(88, 88)` inside a 200×200 `SizedBox`+`Center` and inside a `Row` (horizontally
unbounded), with `takeException()` null in both.

1.4-AC11: PASS — checked independently of the diff summary. The whole file contains no
`Padding`, no `margin`, no `EdgeInsets`, no `SizedBox` spacer and no padding/gap/spacing
constructor parameter; the outermost widget is the `SizedBox.square` itself, so the widget
occupies exactly its preset dimension. Test `'should add no spacing of its own'` measures
`Size(dimension, dimension)` at both presets. (That test's `Padding`-ancestor assertion is
weak — it inspects the test's own wrapper, not the widget — but the exact-size assertion is
what actually proves the rule, and it holds.) `flutter-widgets`' standing "No spacing of its
own" convention is satisfied, and the catalogue row records it.

1.4-AC12: PASS (with the visual check above) — `auth_screen.dart:12` import swapped to
`placeholder_slot.dart`; `auth_screen.dart:57-59` header child is now
`const Center(child: PlaceholderSlot(size: PlaceholderSlotSize.appMark))`. The diff for that
file is exactly those two hunks — the `Column`, `crossAxisAlignment`, the following
`SizedBox(height: 32)`, the headline and the `BlocBuilder` are byte-identical. Genuinely a
rename/reference update with no behaviour change: the unmodified
`test/widget/auth/auth_screen_test.dart` passes 4/4, including `find.text('LOGO')`.

1.4-AC13: PASS — `provider_action_button.dart` and both provider rows are not in the Dev
commit at all (`git show --stat 482a319` lists 7 files, none of them a provider row or asset).
No placeholder slot inserted; `discord-logo.png` / `google-logo.png` untouched.

1.4-AC14: PASS — no `onTap`, `InkWell`, `GestureDetector`, or hover/focus/press treatment in
the file; no `Theme.of(context)` — tokens come through `context.tokens`
(`placeholder_slot.dart:22`). The only literals are `88`, `20` (enum dimensions), the app
mark's radius `20`, plus the marker's `14` / `2.24`, which `tdd.md ## Design notes` item 2
resolves in favour of [1.4-AC9]. `Border.all`'s 1px comes from the framework default.

1.4-AC15: PASS — all three files corrected, and a grep for `dashed|dotted|dash` across
`onboarding-auth-design-spec.md`, `system-foundation-specs.md` and the `flutter-widgets`
skill returns only two hits, both of which are the new prohibitions themselves
(`system-foundation-specs.md:26` and `flutter-widgets/SKILL.md:87`). Per sub-item:
  a. §3 anatomy line now `1px solid rgba(255,255,255,.24)`, and the paragraph under it was
     rewritten — the old "the dashed outline is the explicit signal that real art must be
     dropped in" / "drop the dashed border" is replaced by "the box is deliberately empty,
     and that emptiness is the signal…" / "drop the placeholder fill and border with it".
     The rationale moved to emptiness; nothing dangles.
  b. §5 anatomy line now `1px solid rgba(255,255,255,.32)` with the `.18`/`.32` values left
     alone as required, and the rationale's "the dashed square is honest about being empty"
     became "the slot stays empty, which is honest" — the glyph rejection now rests on
     emptiness.
  c. §9's bullet reads "use the global `PlaceholderSlot` at its app-mark preset"; §10's
     bullet describes the two fixed presets, "no width or height input", and "adds no
     spacing of its own". "Solid border" retained in both.
  d. §3.3's row is now "Reserved empty box: `--color-ink-12` fill,
     `1px solid rgba(255,255,255,.24)`, display 700 caps label".
  e. §1.9 now reads "reserve a placeholder box at the final size".
  f. `flutter-widgets` catalogue gained the `PlaceholderSlot` row after `StatusChip`,
     noting "adds no spacing of its own".

1.4-AC16: PASS — `test/widget/components/placeholder_slot_test.dart` covers all eight
required assertions (size, radius, fill, solid 1px `ink24` border, no `CustomPaint`, marker
present only at the app mark in the display-face 700 style, fixed and unbounded parents, no
spacing). `test/widget/auth/auth_screen_test.dart` is unmodified in git and passes. No
golden test, no `matchesGoldenFile`. No new failure beyond baseline.

1.4-AC17: PASS — `pubspec.yaml` is not in the Dev commit's file list; no new dependency.

1.4-AC18: PASS — `system-foundation-specs.md` §0 Principles gained item 6, "Outlines are
always solid… Dashed and dotted strokes are not used anywhere in the app", appended after
item 5 so 1–5 keep their numbers. It sits in the global principles list, not under §3.3's
placeholder row, and does not contradict principle 4 (which governs *when* lines appear, not
how they are stroked). Reinforced as a convention bullet in the `flutter-widgets` skill
pointing back at §0.

## Architectural compliance

Status: PASS

Checked against `tdd.md` and the `flutter-widgets` skill.

Against `tdd.md`: class names (`PlaceholderSlot`, `PlaceholderSlotSize`), file path
(`lib/widgets/placeholder_slot.dart`), the `SizedBox.square` → `DecoratedBox` → `Center`+`Text`
composition, the single `BoxDecoration` carrying fill + radius + border, the `isAppMark`
getter, radius resolved in `build` rather than on the enum, no private helper class, and no
new package — all as designed. No domain, data or state layer touched.

Against `flutter-widgets`: global widget correctly placed in `lib/widgets/`, categorical name
with no `default` prefix, `const` constructor, plain Flutter widgets, no `Widget`-returning
function or getter, `context.tokens` rather than `Theme.of(context)`, import order correct,
no golden test, catalogue updated, "no spacing of its own" satisfied.

FAILs: NONE

WARNINGs:
- The skill's "Reuse before rebuilding" bullet says a replaced widget should be marked
  `@Deprecated` rather than deleted. `LogoPlaceholder` was deleted outright. This is
  explicitly mandated by [1.4-AC1] and the `tech-ac.md` assumption ("no `@Deprecated` alias
  retained, since nothing is left pointing at the old API"), and the sole caller was migrated
  in the same commit with no dangling reference anywhere in the repo. Compliant with the
  criteria; recorded because it departs from the skill's default.
- The `'LOGO'` marker is a hardcoded string, against the skill's "never hardcode a
  user-facing string" rule. Explicitly out of scope in `tech-ac.md` ("Localising the `LOGO`
  marker or adding an l10n key for it") and covered by a stated assumption. Recorded, not
  charged.
- The new test's `'should add no spacing of its own'` case asserts `findsNothing` for a
  `Padding` *ancestor* of the slot, which can only ever inspect the test harness's own
  wrapper — it would not catch a `Padding` the widget itself added. The criterion still
  holds via the exact-size assertion in the same test and via source inspection, so this is a
  redundant assertion rather than a gap. Worth tightening if the file is touched again.

Scope check (git, not `diff-summary.md`'s self-report): `git show --stat 482a319` lists
exactly 7 files — the 6 allowlisted source/doc files plus the allowlisted test file, with
`logo_placeholder.dart` deleted and `placeholder_slot.dart` added, which is the required
rename. Nothing outside the allowlist. `git diff c1db072..482a319` additionally shows the
run-folder documents (`ambiguities.md`, `code-plan.md`, `task-brief.md`, `tdd.md`,
`tech-ac.md`, `orchestrator-state.md`), which come from the two Phase 3 revision commits
(`5bf569d`, `05c6315`) that sit between the base SHA and the Dev commit — pipeline artifacts,
not Dev source changes.

Uncommitted at QA time: `.agents/runs/placeholder-slot-20260813/orchestrator-state.md`
(modified) and `.agents/runs/placeholder-slot-20260813/diff-summary.md` (untracked). Both are
pipeline bookkeeping written after the Dev commit, not source or test files. Flagged for the
orchestrator to commit; not a scope violation and not a QA blocker.

`orchestrator-state.md ## Deviation approvals` reads NONE, and `diff-summary.md` declares no
deviations — consistent, nothing awaiting sign-off.

## Escalation required

NONE

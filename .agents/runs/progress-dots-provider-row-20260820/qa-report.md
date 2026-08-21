# QA Report
Source: Week 2 task briefs items 1.8, 1.9 (combined run)
Date: 2026-08-21

Overall result: FAIL

One defect: a dimension assertion left in `action_row_test.dart` violates the
revised `flutter-widget-test` skill. Everything else — analyzer, tests, all 32
criteria, `tdd.md` compliance, `flutter-widgets` compliance — passes.

## Manual verification required
[1.8-AC12] — Open the welcome flow, both pages, and swipe between them including a
partial drag — expect the dots identical to before: 22-wide active + 5-wide inactive
on page one, reversed on page two, same left alignment, same 6px gap, same gap to
the headline, tracking the drag.
[1.9-AC12] / [ALL-AC4] — Open the sign-in screen idle, mid-sign-in and after a
failure — expect no visible change from before the run: same row order, fills, mark
size, label brightness (70% ink), 10px gap between rows, spinner on the tapped row
only, both rows locked while in flight, inline error below and retry working.

## Static analysis
Status: PASS
Errors: NONE
0 errors, 2 warnings, 31 info — identical to the `Analyzer baseline`. Both warnings
are pre-existing (`task_detail_screen.dart:201`, `:204`); no info attributable to an
allowlisted file. No `build_runner` run: `generation.md` does not apply — the
allowlist has no annotated source, generated output, Mockito test, routing, DI or
localisation change, as `tdd.md ## Out of scope` states.

## Test results
Status: PASS
Testing mode: smoke
Tests run: 277  |  Passed: 267  |  Failed: 10
Failing tests: all 10 are the recorded pre-existing failures, in exactly the three
recorded files — `test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3). No new failure.
`+267 -10` matches the post-revision figure in `diff-summary.md` (`+259` baseline,
+15 new, −7 removed at Phase 4B). `welcome_screen_test.dart` and
`auth_screen_test.dart` both pass untouched; `_countDots` still resolves.

## Coverage gaps (coverage mode only)
N/A — smoke mode.

## Acceptance criteria

### 1.8 — Progress dots
1.8-AC1: PASS — `lib/widgets/progress_dots.dart:4` `ProgressDots`, const ctor,
  private `_Dot` at `:31` in the same file; no alias at `welcome_container.dart:4`.
1.8-AC2: PASS — `progress_dots.dart:15-16` only `count`/`activeIndex`; imports at
  `:1-2` are Flutter + `core/utils/extensions.dart` only, no default of 2.
1.8-AC3: PASS — `progress_dots.dart:23-26` `List.generate(count, …)` with
  `active: index == activeIndex`; test `renders the requested number of dots`.
1.8-AC4: PASS — `progress_dots.dart:40-44` 22×5 / 5×5 at `tokens.radius.pill`;
  `:22` `spacing: 6` on the `Row`, so no leading or trailing gap; none exposed.
1.8-AC5: PASS — `progress_dots.dart:43` `tokens.color.ink` / `tokens.color.ink12`;
  test `fills the active dot with ink and inactive dots with ink12`.
1.8-AC6: PASS — `progress_dots.dart:21` `mainAxisSize: MainAxisSize.min`, `:41`
  `height: 5`; no `Center`/`Align`/`Padding`/`Transform` in the file.
1.8-AC7: PASS — no `Text`, bar or string in the file; test
  `shows no text and no tap handler`.
1.8-AC8: PASS — no `GestureDetector`/`InkWell`/callback param; same test.
1.8-AC9: PASS — no `Animated*`, `Tween` or `Duration` anywhere in the file.
1.8-AC10: PASS — `progress_dots.dart:9-13`, both asserts in the const initialiser
  list; test `fails in debug when the active index is out of range`.
1.8-AC11: PASS — `welcome_container.dart:58` is the sole replacement; the git diff
  for that file is exactly the import plus the inline `Row` → `ProgressDots` swap.
  Hero height, shortfall, paddings, the 22/18 gap, headline, body and actions are
  byte-identical. `WelcomeStep` stays in the feature.
1.8-AC12: MANUAL — see checklist above.

### 1.9 — Provider / list row
1.9-AC1: PASS — `lib/widgets/action_row.dart:5` `ActionRow`, const ctor; git shows
  `provider_action_button.dart` gone (`R069` → `action_row.dart`) and
  `auth_screen.dart` no longer declares that `part`. No `@Deprecated` shim.
1.9-AC2: PASS — `action_row.dart:17-23`, seven required params; no auth type,
  `S.current`, provider name or asset path in the file.
1.9-AC3: PASS — `action_row.dart:35-42` `SizedBox(height: 52, width:
  double.infinity)` over a `DecoratedBox` with the caller's `fill` at
  `tokens.radius.sm`; no gradient, border, shadow or elevation.
1.9-AC4: PASS — `action_row.dart:46-52` 20×20 required `Image.asset` + 10px gap,
  `:44` `MainAxisAlignment.center` centring the pair; neither is a parameter.
1.9-AC5: PASS (as amended) — `action_row.dart:56-58` pins
  `typography.body.style.copyWith(color: tokens.color.ink70)`; `:59-60` `maxLines: 1`
  + `TextOverflow.ellipsis`. `ink70` not `ink` per the approved Phase 3 deviation.
  Test `shows the label on one line ellipsised in a narrow parent`.
1.9-AC6: PASS — drawn height is exactly 52 (`:36`) with no growth padding;
  `ButtonPressScale` uses `HitTestBehavior.opaque` over that full 52px box.
1.9-AC7: PASS — `action_row.dart:31-32` `IgnorePointer(ignoring: !enabled)` with no
  opacity or colour change on the disabled path; tests
  `calls onPressed once per tap when enabled` and `calls nothing when disabled`.
1.9-AC8: PASS — `action_row.dart:63-72`, indicator only under `if (loading)`, 16px
  square, `strokeWidth: 2`, 10px gap after the label, `semanticsLabel: loadingLabel`;
  test `shows the busy indicator only while loading` also asserts the label stays.
1.9-AC9: PASS — `ButtonPressScale` reused unchanged (`action_row.dart:33`); it owns
  the 0.97 scale, `motion.resolve(context, motion.stateChange)` (reduced-motion
  aware) and the green focus ring at `button_press_scale.dart:35-41`.
1.9-AC10: PASS — `action_row.dart:28-30` `Semantics(button: true, enabled: enabled)`,
  a single node, unchanged from the shipped class.
1.9-AC11: PASS — `auth_screen.dart:67-87`: Discord first with `accentIndigo` and
  `assets/icons/discord-logo.png`, Google second with `surfaceRaised` and
  `assets/icons/google-logo.png`, both marks 20px via the widget, both labels the
  existing `S.current` keys; the 10px `SizedBox` at `:77` stays in the screen's
  `Column`. `auth_screen_test.dart`'s `renders only Discord then Google provider
  actions` still passes.
1.9-AC12: PASS — the diff changes only the class name and `assetPath:` → `markAsset:`;
  `enabled: !loading` and `loading: state.activeProvider == …` are unchanged, so the
  in-flight lock and single spinner are the same code. `auth_screen_test.dart`'s
  `shows provider failures inline and remains retryable` still passes. Pixel-level
  confirmation is on the manual checklist.

### ALL
ALL-AC1: PASS — neither file has outer padding/margin or a spacing/`EdgeInsets`
  parameter; the 6px dot gap and the row's 10px interior gaps are anatomy.
ALL-AC2: PASS — every colour, radius and type style reads `context.tokens`
  (`progress_dots.dart:38,43-44`; `action_row.dart:27,41,56-57`). No
  `Theme.of(context)`, no `ColorScheme`, no `Colors.*` or hex, no local font or
  duration. Only the sanctioned dimension literals (22, 5, 6, 52, 20, 10, 16, 2).
ALL-AC3: PASS — no `CustomPaint`/`CustomPainter`, no dash constant, no `Border` in
  either file.
ALL-AC4: MANUAL — see checklist above. Code-level the row's only visual deltas are
  the approved ellipsis wrap and the `ink70` pin, both no-ops at today's call sites.
ALL-AC5: PASS — no user-facing string in either widget; no `.arb` and no
  `lib/generated/` file in `git diff --name-only cf6d4d8~1..29a516d`.
ALL-AC6: PASS — `pubspec.yaml` not in the diff; analyzer exactly at baseline.
ALL-AC7: PASS — `.claude/skills/flutter-widgets/SKILL.md` gains exactly two rows,
  both ending "adds no spacing of its own"; the diff touches no existing row.
ALL-AC8: PASS — both components have their own file, both pass, no golden test, no
  `matchesGoldenFile`, `welcome_screen_test.dart` and `auth_screen_test.dart` pass
  untouched, and the suite is at `+267 -10` with no new failure. AC8's literal
  coverage list (the 22×5 / 5×5 dimensions, the 6px gap, the `sm` radius, the 20px
  mark) is superseded by the human's Phase 4B removal and by the revised
  `flutter-widget-test` skill, which now forbids asserting those at all — not
  counted as a gap.

## Architectural compliance
Status: FAIL

FAILs:
- `test/widget/components/action_row_test.dart:34` —
  `expect(tester.getSize(find.byType(ActionRow)).height, 52);` inside
  `shows the busy indicator only while loading`. `flutter-widget-test` (revised
  2026-08-21) is now categorical: "Do not test dimensions … Height, width, padding,
  gaps, radii, offsets and positions are not behaviour", and the review checklist
  reads "No assertion measures a dimension, gap, radius or position." This is the
  last surviving dimension assertion in the run — Phase 4B's removal pass took out
  the seven standalone dimension tests but missed this line because it sits inside a
  behaviour test. Fix is to delete the single line; the test's actual behaviour
  (indicator appears only while loading, label stays visible) is unaffected.

WARNINGs:
- `test/widget/components/progress_dots_test.dart:11,20` count and index raw
  `Container`s. That is structural coupling — a `SizedBox` + `DecoratedBox` refactor
  would break it — but `_Dot` is private and the widget renders no text or semantics,
  so there is no public observable for "how many dots", and `tdd.md ## Reuse
  decisions` pins `Container` deliberately so `welcome_screen_test.dart` needs no
  edit. Accepted, flagged so it is not mistaken for a precedent.
- `test/widget/components/progress_dots_test.dart:28` `shows no text and no tap
  handler` asserts the absence of `Text`/`GestureDetector`/`InkWell`. The skill says
  "Do not test invisible implementation details negatively", but [ALL-AC8] names this
  coverage explicitly. A genuine criterion-vs-skill conflict, not a Dev error — the
  human's call whether the skill should win here too.
- `test/widget/components/action_row_test.dart:64-65` reads `Text.maxLines` and
  `Text.overflow` off an internal `Text`, which duplicates constructor arguments; the
  behaviour is already carried by `takeException(), isNull` at `:66`. Minor.
- Test names `renders the requested number of dots` and `calls nothing when disabled`
  do not follow the skill's `<outcome> when <condition>` shape. Cosmetic.
- `welcome_container.dart` still carries four comments (`:17`, `:29-30`, `:36-37`,
  `:50-51`), which the revised `flutter-widgets` no-comments rule now covers for
  feature `presentation/widgets/` files. All pre-existing and outside this run's
  permitted edit ("change nothing else in the file") — a follow-up, not a defect.

`tdd.md` compliance: no deviations. Class names, file paths, the seven required
parameters, `Row(mainAxisSize: min, spacing: 6)`, `Container`-based `_Dot`, both
asserts in the initialiser list, the `Flexible` wrap, the `ink70` pin and the
`ButtonPressScale` reuse all match the design as written.

`flutter-widgets` compliance: PASS. Both new files are comment-free, `const`,
categorically named with no `default` prefix, add no spacing of their own, draw no
border and read every token through `context.tokens`. The 5px odd dimension and the
`Flexible`-over-`Expanded` choice are both recorded, approved exceptions
(`orchestrator-state.md ## Deviation approvals`, 2026-08-20) and are not counted.

Scope: clean. `git diff --name-only cf6d4d8~1..29a516d` returns exactly the
allowlist plus the two run artifacts; `git status --short` is empty. Nothing
undeclared, nothing uncommitted.

## Escalation required
`action_row_test.dart:34` dimension assertion → route to: Dev Agent

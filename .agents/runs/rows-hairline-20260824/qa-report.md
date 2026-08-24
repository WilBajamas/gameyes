# QA Report
Source: `tech-ac.md` — item 2.6, `system-foundation-specs.md` §3.2 line 246
Date: 2026-08-24

Overall result: PASS — pending manual checks

Implementation read as one change across `6689860` + `409fe04`
(`git diff 424fb04..HEAD -- lib/ test/ .claude/`): 5 files, +234, no deletions.
Working tree clean, no uncommitted changes.

## Manual verification required

Both components ship unwired, so every check below needs a scratch harness or
the first real caller — there is no shipped screen to open today. The project's
manual-check backlog is deferred until Stage 2's eight items are done; these
join it rather than being attempted now.

[2.6-AC6] — Render a `LabelValueRow` in a scratch harness — expect 16 horizontal
/ 14 vertical interior padding and a row height at or above the 44px touch-target
floor (`game-detail-design-conventions.md` §6 says 43–46px for list rows).
[2.6-AC7] — Render a `HairlineGroup` of 2–3 rows in a scratch harness — expect a
16-radius raised card whose corners stay rounded, with a child that paints to its
own edge confirming the clip actually cuts it (`overflow:hidden`).
[2.6-AC10] — Same harness — expect the separator to read as a single solid 1px
stroke, not a 2px line or a gap, at 1x/2x/3x device pixel ratios.

## Static analysis
Status: PASS
Errors: NONE

`flutter analyze` — 33 issues (0 errors, 2 warnings, 31 info), identical to the
recorded baseline. Zero issues attributed to any allowlisted file (grep for
`label_value_row` / `hairline_group` in the analyzer output returns nothing).
The 2 warnings remain the pre-existing `_TaskReminder` pair in
`task_detail_screen.dart:201`/`:204`, a file this run did not touch.

No code generation step applies (`build_runner`/`intl_utils`): no annotated
source, no new `.arb` key, both widgets take their strings from the caller.
Confirmed against the allowlist — nothing generated is in scope.

## Test results
Status: PASS
Tests run: 335  |  Passed: 325  |  Failed: 10

Testing mode: `smoke`. Full suite `+325 -10`, exactly the baseline `+315 -10`
plus this run's 10 new tests. The 10 failures are unchanged in count *and*
identity from the recorded pre-existing set:

- `test/repository/tracker/tracker_repository_test.dart` — 4 (pre-existing)
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3 (pre-existing)
- `test/cubit/games/games_bloc_test.dart` — 3 (pre-existing)

No regression. The two allowlisted test files run green in isolation
(`+10`, all passed), with no unhandled `google_fonts` exception leaking.

## Acceptance criteria

[2.6-AC1]: PASS — `lib/widgets/label_value_row.dart:7-8` (`required this.label`,
`required this.value`); both render as `Text` inside one `Row` at `:23-39`, and
both are found by name in `label_value_row_test.dart` — "shows the label in ink
and the value in ink70".
[2.6-AC2]: PASS — label overrides to `tokens.color.ink` at
`label_value_row.dart:29`; value keeps `meta`'s own colour at `:36`, and
`app_type_tokens.dart:100-104` confirms `meta` is Inter 14/w500 carrying
`ink70`. No new type token. Asserted naming both tokens by
`label_value_row_test.dart` — "shows the label in ink and the value in ink70".
[2.6-AC3]: PASS — `showChevron` defaults `false` at `label_value_row.dart:9`;
the `Icon` is emitted only under `if (showChevron)` at `:40-41` and sits last in
the `Row`. Tests "shows one chevron when a chevron is requested" (findsOneWidget)
and "hides the chevron by default" (findsNothing).
[2.6-AC4]: PASS — the row's tree is `Padding > Row > Text/Text/Icon` only
(`label_value_row.dart:21-43`); no `Divider`, `Border`, `DecoratedBox` or
`BoxDecoration` anywhere in the file. Test "draws no separator of its own".
[2.6-AC5]: PASS (code review, per `tech-ac.md`'s "Verified by" — no widget test
is due here) — no `Container`, `DecoratedBox`, `BorderRadius`, `ClipRRect` or
`Color` fill appears in `label_value_row.dart`; the only colours it writes are
text and icon foregrounds.
[2.6-AC6]: MANUAL (code review PASS) — `label_value_row.dart:22`
`EdgeInsets.symmetric(horizontal: 16, vertical: 14)` matches §4.4 exactly. No
dimension test is written and none is due — `tech-ac.md` says "Never a widget
test" for this criterion. Visual check listed above.
[2.6-AC7]: MANUAL (every element verified; one half needs a human's eye) — fill PASS by test
(`hairline_group_test.dart` — "fills the card with the surfaceRaised token",
asserting `ColoredBox.color == AppColorTokens.dark.surfaceRaised`, the token, not
a hex). Radius and clip PASS by code review: `ClipRRect` at
`BorderRadius.circular(tokens.radius.lg)` wrapping the `ColoredBox`
(`hairline_group.dart:15-18`), and `app_radius_tokens.dart:37` resolves `lg` to
16. The radius/clip half is MANUAL by `tech-ac.md`'s own instruction, listed
above — no criterion element is unverified.
[2.6-AC8]: PASS — `hairline_group.dart:23-27` emits a `Divider` only when
`index > 0`. Three count assertions in `hairline_group_test.dart`: "shows no
separator when given a single child" (findsNothing), "shows one separator
between two children" (findsOneWidget), "shows two separators between three
children" (findsNWidgets(2)).
[2.6-AC9]: PASS — API review, the criterion being the absence of a parameter.
`hairline_group.dart:5` is exactly
`const HairlineGroup({super.key, required this.children});` and `:7` declares
the single field `final List<Widget> children;`. That is the entire public
surface: no divider flag, no `showDividers`, no `separatorBuilder`, no per-child
wrapper, no static or extension member, and no named constructor. Placement is
computed from `children.length` and the loop index alone (`:23-24`), so a
leading or trailing hairline is not a case the code contains. Nothing in the
file reads a property off, type-tests or unwraps a child, so no child can
influence placement either.
[2.6-AC10]: PASS (colour) — `Divider(..., color: tokens.color.hairline)` at
`hairline_group.dart:25`, asserted naming the token by "uses the hairline token
for the separator". `height: 1, thickness: 1` is the sanctioned 1px exception
recorded in `tech-ac.md ## Assumptions`; `Divider` is solid by construction, no
dash or dot. The 1px stroke itself is MANUAL per `tech-ac.md`, listed above.
[2.6-AC11]: PASS — `hairline_group.dart:11` returns `const SizedBox.shrink()`
before any fill, radius or divider is built. Test "shows no card fill when given
no children" scopes `find.descendant(of: HairlineGroup, matching: ColoredBox)`
to findsNothing.
[2.6-AC12]: PASS — the parameter is `List<Widget>` (`hairline_group.dart:7`) and
the build method never inspects an element. The three [2.6-AC8] count tests pass
plain `const Text` children rather than `LabelValueRow`, so they demonstrate
arity is the sole input rather than merely asserting it. The two widget files do
not import each other.
[2.6-AC13]: PASS — verified by git and grep, not by `diff-summary.md`'s claim.
`git diff --name-only 424fb04..HEAD` lists only the five allowlisted files plus
this run's own docs. `git log cd08b35..HEAD -- lib/widgets/horizontal_separator.dart
lib/widgets/group_task_item.dart lib/widgets/task_item.dart` returns nothing —
all three untouched. `grep -rn "LabelValueRow\|HairlineGroup\|label_value_row\|
hairline_group" lib/ test/` returns hits only inside the two new widget files and
their two test files; no existing file references either component. Analyzer and
test baselines moved only by this run's 10 tests.

## Architectural compliance
Status: PASS
FAILs: NONE
WARNINGs: NONE

**Against `tdd.md`** — class names, file paths and parameter lists match the
design exactly: `LabelValueRow` at `lib/widgets/label_value_row.dart`,
`HairlineGroup` at `lib/widgets/hairline_group.dart`, both `StatelessWidget`,
neither `final`/`sealed`/`base`, two flat files with no module folder, and the
two classes do not import each other. No package added to `pubspec.yaml`. The
`Divider`-not-a-new-widget and `HorizontalSeparator`-deliberately-not-reused
decisions both hold. `## Deviation approvals` is NONE and `diff-summary.md`
declares no deviation — consistent; the one self-correction was a test-harness
finder fix, not a plan deviation.

**Against `flutter-widgets`** — zero comments in either widget file (grep for
`//` returns nothing in both). Tokens only: every colour and radius via
`context.tokens`, no `Theme.of(context)`, no literal `Color`, no `Colors.*`.
`Expanded` used for the label that takes the leftover width, per the
Expanded-over-`Flexible` rule. Dimensions are even (16 padding, 14 padding, 12
row gap, 16 icon) with the 1px hairline as the recorded sanctioned exception.
Imports are package-form and alphabetised; constructors and literals are `const`
where the linter allows. The catalogue edit is exactly two added rows
(`git diff` shows `2 +`, zero deletions), each ending "adds no spacing of its
own" in the established wording, and the "one file per widget family" sentence
is untouched as the gate directed.

**Against `flutter-widget-test`** — each test checked independently against the
review checklist. All ten are behaviour-named ("shows/hides <outcome> when
<condition>"), comment-free, one pump and one or two expectations each, with no
completer, fake image bytes, arbitrary delay, zone or swallowed error, and no
manual invocation of an internal builder. Nothing measures a dimension, gap,
radius or position; there is no golden test or `matchesGoldenFile` anywhere in
`test/`. Both colour assertions carry meaning (§2's colour law — the failure
case is a literal shipping instead of a token) and name the design token rather
than a hex.

Three points I checked hard rather than assumed, all clearing:

- **The `google_fonts` async trap (gotcha #10).** Neither file has a `setUpAll`,
  and neither pre-resolves `AppTokens.dark`, `buildDarkTheme()` or any typography
  value to compare against later. The theme resolves inside `pumpWidget`'s own
  zone; the only pre-resolved values are `AppColorTokens.dark.<colour>`, a plain
  `const` colour class with no font loading behind it. Confirmed empirically —
  the two files run `+10` clean with no leaked unhandled exception.
- **Test imports.** Each file imports exactly one widget — its own public entry
  point — and reaches into no internal file (there are none to reach into). The
  remaining imports are the `theme_data_dark.dart` / `generated/l10n.dart` /
  `google_fonts` harness copied verbatim from the human-written reference
  `context_chip_test.dart`, plus `app_color_tokens.dart`. That last one is
  required, not a reach-past: `tech-ac.md`'s own "Verified by" lines on
  [2.6-AC2] and [2.6-AC10] demand a colour assertion *naming the token*, which
  cannot be written without importing the public token class. This is not the
  item-2.4 violation, which was a test importing a module's internals.
- **Coupling to `Divider`/`ColoredBox`.** The count and fill assertions do name
  public Flutter types, which normally reads as structural coupling. Here it is
  the sanctioned design: `tdd.md`'s "Reuse decisions" chose `Divider` precisely
  because being a public type makes [2.6-AC8]'s count assertable without
  reaching into a private class, and [2.6-AC8]/[2.6-AC7] are explicit documented
  component contracts, which the skill lists as worth protecting. Accepted, not
  a violation.

Two known items, correctly left alone and not counted against this run: the
`flutter-widgets` allowlisting for catalogue rows only (a human gate decision),
and `horizontal_separator.dart`'s hardcoded `Colors.grey` / `context.screenWidth`
(out of scope by the CRITICAL-1 answer, a recorded follow-up).

One observation, no action: `LabelValueRow` bakes in 16/14 padding while drawing
no surface of its own, which sits slightly against `flutter-widgets`' "no
spacing of its own" wording (that rule exempts padding inside a surface *the
widget itself draws*). It is not a defect — [2.6-AC6] mandates the padding, §4.4
assigns it to the row, `task-brief.md` pre-empted the question in writing, and
the padding is correctly *not* exposed as a parameter. Noting it only so a
future reader does not re-open it.

## Escalation required
NONE

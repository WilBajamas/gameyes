# QA Report
Source: Week 2 task briefs items 1.5, 1.6, 1.7 (combined run) · `tech-ac.md` 2026-08-13 (rev. 2026-08-14)
Date: 2026-08-20

Overall result: PASS — pending manual checks

## Manual verification required

[1.5-AC11] — Open the filter bottom sheet (ordering, platform, genre groups) — expect three chip
groups rendering as before, indigo-filled capsules when selected and 8%-ink when not, single-select
on ordering and multi-select on platforms/genres, same items in the same order, chip and title
spacing unchanged. No automated test covers `filter_bottom_sheet.dart`.

[1.7-AC10] — Open the featured screen with a non-empty library — expect three equal-width stat
tiles (total games, wishlist, this week) in that order, figure above label, no icons and no
blue/orange/green tints, 12px gaps between them and 20px below. No automated test covers
`LibraryStatsWidget`.

[1.6-AC2] — Render `ContextChip` over busy artwork — expect the blur to read as glass and to stop
at the capsule's rounded edge (structure is correct; only the visual can confirm it).

[1.7-AC5] — Render `StatPill` with 2 and with 3 entries over artwork — expect the pairs to read as
evenly distributed. Note the trade-off already flagged in `code-plan.md`'s second-pass delta:
`Expanded` gives each pair an equal *slot*, so the outer pairs no longer touch the capsule's inner
edges as `spaceBetween` would have made them.

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` succeeded and left the working tree
clean — generated output is current, so analysis is meaningful.

`flutter analyze`: 0 errors, 2 warnings, 31 info (33 issues).
Baseline: 0 errors, 2 warnings, 32 info (2026-08-13T13:39:30Z). One fewer info, consistent with the
deletion of `default_choice_chip.dart`. Zero issues of any severity attributed to
`filter_count_chip.dart`, `context_chip.dart` or `stat_pill.dart`. The two warnings are the
pre-existing `_TaskReminder` ones in `task_detail_screen.dart`. The three
`avoid_redundant_argument_values` infos in `library_stats.dart:288-290` sit in
`_buildNowPlayingCard`, untouched by this run.

## Test results

Status: PASS
Tests run: 269  |  Passed: 259  |  Failed: 10

Testing mode: `smoke`, with no Dev-authored test file this run per [ALL-AC7] as revised 2026-08-14.
Result matches the current baseline **+259 -10** exactly (the `## Phase 3 revision` note at the
bottom of `orchestrator-state.md`; the `+265 -11` and `+256 -10` lines earlier in that file are
both superseded).

The 10 failures are the recorded pre-existing ones, unchanged in file and name:
- `test/repository/tracker/tracker_repository_test.dart` (4)
- `test/cubit/game_detail/game_detail_cubit_test.dart` (3)
- `test/cubit/games/games_bloc_test.dart` (3)

No regression. The three human-authored files (`context_chip_test.dart`,
`filter_count_chip_test.dart`, `stat_pill_test.dart`, commit 1b669d2) all pass. No
`matchesGoldenFile` anywhere in them.

## Coverage gaps (coverage mode only)

N/A — testing mode is `smoke`. Advisory gaps against [ALL-AC7]'s state matrix are listed under
"Human-authored test review" below.

## Scope check

Dev commit `bb9b6e5` touched exactly 8 files, all allowlisted:
`lib/widgets/filter_count_chip.dart`, `context_chip.dart`, `stat_pill.dart` (create);
`lib/widgets/default_choice_chip.dart` (delete); `type_values_selection.dart`,
`multi_type_values_selection.dart`,
`lib/features/featured/presentation/widgets/library_stats.dart`,
`.claude/skills/flutter-widgets/SKILL.md` (modify). No test file, no `pubspec.yaml`, no `.arb`, no
screen file. Working tree clean; nothing uncommitted.

The two standing-convention bullets in `flutter-widgets/SKILL.md` ("Dimensions are even numbers",
"Prefer `Expanded` over `Flexible`") were added by the Tech Lead in `6e2b4cb`, not by Dev — Dev's
own edit to that file is the catalogue table only, as `code-plan.md` instructed.

Everything else on the branch between `e1d3126` and `f013c4b` (all existing widget tests revised,
`flutter-widget-test` skill added and wired into the agent skills, `test/widget_test.dart` deleted,
the three new test files) belongs to the declared out-of-band detour and the human's own test
authorship, both recorded in `orchestrator-state.md`. Not a scope violation of this run's commit.

`## Deviation approvals` reads NONE and `diff-summary.md` declares no deviations — consistent.

## Acceptance criteria

### 1.5 — Filter / count chip

1.5-AC1: PASS — `default_choice_chip.dart` deleted in `bb9b6e5`; no `DefaultChoiceChip` reference
survives anywhere under `lib/` or `test/`; no `@Deprecated` shim.
1.5-AC2: PASS — `filter_count_chip.dart:4` `class FilterCountChip`; no `default` prefix, no
collision with `Chip`/`ChoiceChip`/`FilterChip`; neither call site uses an alias or `hide`; `const`
constructor at `:5`.
1.5-AC3: PASS — `filter_count_chip.dart:35` `BorderRadius.circular(tokens.radius.pill)`, one radius
for both states.
1.5-AC4: PASS — `filter_count_chip.dart:34` fill `colors.accentIndigo` when selected;
`:46` label `colors.ink` = `rgba(255,255,255,1)` (`app_color_tokens.dart:4`). Covered by
`filter_count_chip_test.dart` "color appear accentIndigo when isSelected is true".
1.5-AC5: PASS — `filter_count_chip.dart:34` `colors.ink08` when unselected; label `colors.ink` at
`:46`. Covered by "color appear ink08 when isSelected is false".
1.5-AC6: PASS — `filter_count_chip.dart:51` `if (count != null)`, so a `null` count builds no
widget and `0` renders as `'0'`; the count is inside the same `Row` within the capsule's `Padding`;
`:55` colour is `ink` when selected, `ink55` when not.
1.5-AC7: PASS — `filter_count_chip.dart:38` `EdgeInsets.symmetric(horizontal: 14, vertical: 8)`;
`:22` label style is `typography.meta.style` = Inter 14 / w500 (`app_type_tokens.dart:100-106`).
Neither is a constructor parameter (`:13-16`).
1.5-AC8: PASS — `filter_count_chip.dart:25-29` opaque `GestureDetector` over a
`ConstrainedBox(minHeight: 44)`, one `onTap: onSelected`, no second gesture layer; the drawn
capsule stays at its padding because the `Center(widthFactor: 1)` at `:30` sits inside the
constraint. Callback verified by `filter_count_chip_test.dart` "calls onSelected when tapped".
1.5-AC9: PASS — the whole subtree is `DecoratedBox` → `Padding` → `Row` of one or two `Text`s
(`:32-58`); no icon, checkmark, avatar, delete, border, shadow or elevation, and no Material chip
in the tree, so the app's chip theme cannot reach it.
1.5-AC10: PASS — `:30` `Center(widthFactor: 1)` + `:40` `mainAxisSize: MainAxisSize.min` keep it at
content width; `:43-49` label is `Flexible` with `maxLines: 1` and ellipsis; `:52` count is
unconstrained, so it never wraps or ellipsises.
1.5-AC11: MANUAL — see "Manual verification required". Code side is correct: both call sites swap
class and import only (`type_values_selection.dart:5,44` and `multi_type_values_selection.dart:4,33`),
parameter names identical, `Wrap(spacing: 5)` / `Wrap(spacing: 4)`, the titles and the
`SizedBox(height: 2)` all unchanged, no count supplied by either.

### 1.6 — Context chip

1.6-AC1: PASS — `lib/widgets/context_chip.dart:5` `class ContextChip`, `const` constructor at `:6`,
categorical name, no alias needed, no helper split out.
1.6-AC2: MANUAL (visual) — structurally correct: `context_chip.dart:17-19` `GlassSurface(fill:
colors.glass32, borderRadius: circular(radius.pill))`, and `glass_surface_widget.dart:20-26`
`ClipRRect` → `BackdropFilter(effect.glassBlur)` → `ColoredBox`, so the blur is clipped to the
capsule. `glass32` is `rgba(0,0,0,0.32)` (`app_color_tokens.dart:127`), inside the `.30–.34` ramp
and not the status chip's `.42`.
1.6-AC3: PASS — `context_chip.dart:19` `radius.pill`; `:21`
`EdgeInsets.symmetric(horizontal: 12, vertical: 6)`; neither is a parameter (`:8-9`).
1.6-AC4: PASS — `:29-30` `pill.format(label)` with `pill.style.copyWith(color: colors.ink)`; the
`pill` token is Inter 11 / w500 / `letterSpacing: 0.88` (= 11 × .08em) with `uppercase: true`
(`app_type_tokens.dart:116-124`). No local font family or weight. Verified by
`context_chip_test.dart` "shows the label in uppercase".
1.6-AC5: PASS — `:26` `Icon(icon, size: 12, color: colors.ink)`, same colour as the label, first in
the `Row`, `spacing: 6` at `:24`; `icon` is `required` at `:6` with no iconless branch. **12px, not
the 13px written in this criterion** — the even-dimension revision approved by the human at Phase 3
round 2 and recorded in `code-plan.md`'s second-pass delta, which states QA measures 12 against the
delta. Not an undeclared deviation.
1.6-AC6: PASS — `:23` `mainAxisSize: MainAxisSize.min`; `:27-33` `Flexible` + `maxLines: 1` +
ellipsis; no `GestureDetector`, `InkWell`, `onTap`, hover or focus anywhere in the file.
1.6-AC7: PASS — no `Positioned`, `Align`, `Transform`, `Stack`, offset or `top` parameter in
`context_chip.dart`; nothing encodes 54.
1.6-AC8: PASS — `ContextChip` appears nowhere under `lib/` except its own file; the welcome screens
are not in the Dev commit.

### 1.7 — Stat pill

1.7-AC1: PASS — `StatEntry`, `StatTile`, `StatPill` and private `_StatPair` all in
`lib/widgets/stat_pill.dart`; both forms render `_StatPair` (`:30` and `:65`), so the figure/label
treatment is written once.
1.7-AC2: PASS — `stat_pill.dart:23-27` `DecoratedBox(color: ink08, borderRadius:
circular(radius.lg))` (`lg` = 16, `app_radius_tokens.dart:37`), fill only; `:29`
`EdgeInsets.all(14)` on all sides; `_StatPair` at `:92-107` is a `Column` (default centre
cross-alignment) with the figure first. It draws no sibling or row. **14px, not the 13px written in
this criterion** — same approved even-dimension delta as [1.6-AC5].
1.7-AC3: PASS — `:97` figure is `typography.statFigure.style` = Space Grotesk 18 / w700 / `ink`
(`app_type_tokens.dart:163-171`); `:33-35` label is `typography.pill.style` (Inter 11 / w500) with
`color: ink55`. No local `TextStyle` literal.
1.7-AC4: PASS — `stat_pill.dart:23-38` has no `SizedBox`, width or height; under `Expanded` in
`library_stats.dart:229-247` it receives a tight width and fills it, and in an unbounded parent it
sizes to content rather than collapsing.
1.7-AC5: MANUAL (visual distribution) — structurally correct: `:56-60` `GlassSurface(fill: glass30,
borderRadius: circular(radius.pill))` with `EdgeInsets.symmetric(horizontal: 14, vertical: 10)`;
`glass30` = `rgba(0,0,0,0.30)` (`app_color_tokens.dart:126`); blur clipped by `GlassSurface`; `:63`
each pair wrapped in `Expanded`, no inserted gap widgets. See the equal-slots-vs-equal-gaps note in
"Manual verification required".
1.7-AC6: PASS — figure is the same `statFigure` token both forms share (`:97`); `:54` glass label
is `typography.microLabel.style` = Inter 10 / w500 / `ink70` (`app_type_tokens.dart:180-188`).
1.7-AC7: PASS — `stat_pill.dart:43-47` `assert(stats.length == 2 || stats.length == 3)` in the
`const` constructor. Verified by `stat_pill_test.dart` "should assert on list length not 2 or 3".
1.7-AC8: PASS — `StatTile` takes only `figure`/`label` (`:14`), `StatPill` only `stats` (`:43`),
`StatEntry` only two strings (`:7`); no `IconData`, no colour parameter, no icon in either tree.
1.7-AC9: PASS — both fields are `String` rendered verbatim (`:95-106`); no formatting, no
`S.current` in the file; both `Text`s are `maxLines: 1` with ellipsis.
1.7-AC10: MANUAL — see "Manual verification required". Code side is correct:
`library_stats.dart:229-247` renders three `StatTile`s with `totalGames.toString()` /
`S.current.total_games`, `wishlistCount.toString()` / `S.current.wishlist`, `formattedHours` /
`S.current.this_week`, in that order, each inside `Expanded` with the two `SizedBox(width: 12)` and
the `SizedBox(height: 20)` below all retained; the three `IconData`s and the
`blueAccent`/`orangeAccent`/`green` tints are gone with no replacement.
1.7-AC11: PASS (with a warning, below) — `_buildStatTile` is deleted in full; `_buildNowPlayingCard`,
`_DashedBorderPainter`, the checklist card and rows, and the file's `// TODO` are all behaviourally
untouched.
1.7-AC12: PASS — `StatPill(` appears nowhere under `lib/` outside its own declaration.

### ALL — standing rules

ALL-AC1: PASS — none of the three files contains an outer `Padding`, `margin` or spacer around its
content, and no constructor exposes `padding`, `margin`, `gap`, `spacing` or `EdgeInsets`. Every
`Padding` present is inside a surface the widget itself draws.
ALL-AC2: PASS — no `Border`, `CustomPaint`, `CustomPainter`, dash or gap constant in
`filter_count_chip.dart`, `context_chip.dart` or `stat_pill.dart`; every surface is a fill.
ALL-AC3: PASS — every colour, radius, type style and blur is read through `context.tokens`; no
`Theme.of`, `context.themeData`, `ColorScheme`, `Colors.*`, hex/`rgba` literal or `GoogleFonts.*`
call in the three files. Numeric literals present are 44 / 14 / 8 / 6 (chip), 12 / 6 (context chip)
and 14 / 14 / 10 (stat pill) — all stated by `tech-ac.md` or by the approved `tdd.md`/`code-plan.md`
decisions (6px label-to-count gap; the 12/14 even-dimension revision).
ALL-AC4: PASS — no user-facing string in the three files; `intl_en.arb`, `intl_zh.arb` and
`generated/l10n.dart` are absent from the Dev commit.
ALL-AC5: PASS — `pubspec.yaml` is not in `bb9b6e5`.
ALL-AC6: PASS — `.claude/skills/flutter-widgets/SKILL.md` catalogue: the `DefaultChoiceChip` row is
removed, and `FilterCountChip`, `ContextChip` and `StatTile` / `StatPill` rows are added, each
ending "adds no spacing of its own".
ALL-AC7: PASS — Dev created no file under `test/` in `bb9b6e5`; the full suite matches baseline
+259 -10 with the same 10 pre-existing failures; no existing test was weakened, skipped or deleted
by this run's commit; no golden test or `matchesGoldenFile` anywhere, including the three
human-authored files. The behaviour matrix is exhibited by the implementation and is reachable at
widget-test level (fills via `DecoratedBox`/`GlassSurface`, styles via the tokens, the assert via
the public constructor) — the criteria above cite the evidence per line. Advisory review of the
human's own files follows; per the 2026-08-14 revision those files are not a Dev deliverable and
their grading is a later pass, so nothing there changes this run's result.

Note on `test/widget_test.dart`: deleted during the declared out-of-band detour (vestigial), not by
this run's commit. Its removal is why the baseline moved from 11 to 10 pre-existing failures.

## Human-authored test review (advisory — not in this run's allowlist)

Reviewed against `.claude/skills/flutter-widget-test/SKILL.md` at the human's request. All nine
tests pass and none trips a banned pattern: no `Completer`, no fake image bytes, no manual builder
invocation, no arbitrary delays, no zones, no swallowed errors, no golden test, no deep
hierarchy-mirroring finders. Setup is proportional throughout — a small `buildSubject`, one pump,
direct expectations.

**What is good**
- `stat_pill_test.dart` "should show 2 stats when passed 2 entries" is the model case: named for
  condition and outcome, asserts visible text, would survive any implementation-only refactor.
- The assert test protects a genuine public contract ([1.7-AC7]) through the public constructor.
- `filter_count_chip_test.dart` "calls onSelected when tapped" acts through the public UI
  (`tester.tap`) and asserts the callback, exactly as the skill prescribes.
- `context_chip_test.dart` "shows the label in uppercase" targets a real contract ([1.6-AC4])
  rather than restating the source.

**Real gaps**
1. `filter_count_chip_test.dart:89-92` and `:100-103` — the two colour tests hardcode the palette
   (`const Color(0xFF5865F2)`, `const Color.fromRGBO(255, 255, 255, 0.08)`) and reach the fill via
   `tester.widget<DecoratedBox>(find.byType(DecoratedBox))`. The fill *is* an explicit design
   contract, so testing it is defensible under "Treat visual styling deliberately", but as written
   the test freezes the literal palette rather than the contract "uses `accentIndigo`" — a token
   value change breaks it with no behaviour change — and `find.byType(DecoratedBox)` throws the
   moment a second `DecoratedBox` enters the tree. Asserting against
   `AppColorTokens.dark.accentIndigo` / `.ink08` would protect the same contract refactor-safely.
2. **No `StatTile` test at all.** `stat_pill_test.dart` covers only the glass form, which ships
   unwired; the tile form is the only one of the three components with a live caller
   (`library_stats.dart`) and therefore the only one whose regression a user would actually see.
   Biggest gap across the three files.
3. `stat_pill_test.dart:43` — the test is named "should assert on list length not 2 or 3" but only
   exercises 1. The 4+ case and the 3-pair success case are both unexercised. (Also, the assert
   fires inside `buildSubject` before any pump, so `tester` is unused — this is a constructor test
   wearing `testWidgets`; a plain `test()` would be honest.)
4. `filter_count_chip_test.dart:74-80` — "count is not displayed when count is null" asserts
   `find.text('1')` finds nothing when no count was ever supplied, which is close to tautological.
   The case actually worth protecting is the one [ALL-AC7] calls out by name: **count `0` renders as
   `0` and is not treated as absent** — the exact regression `if (count != null && count != 0)`
   would introduce. Not covered.
5. `context_chip_test.dart:32-33` — `tester.widget<Text>(find.byType(Text))` assumes exactly one
   `Text` in the tree and reads `.data`; `expect(find.text('TEXT'), findsOneWidget)` says the same
   thing more directly and survives a second `Text` being added.
6. `context_chip_test.dart` has one test and no assertion on the required leading icon, which is a
   public contract with a trivially observable outcome (`find.byIcon`). As you noted, the minimal
   scope may be deliberate — recording it as an observation, not a defect. "Label shows" is
   effectively covered by the uppercase test, so the icon is the only real omission here.
7. `filter_count_chip_test.dart` omits `GoogleFonts.config.allowRuntimeFetching = false`, which the
   other two files and the rest of `test/widget/components/` all set. It passes today, but it is an
   inconsistency that can flake wherever a font fetch is attempted.
8. Naming drift in `filter_count_chip_test.dart` only: "label is displayed", "count is displayed
   when count is not null", "color appear accentIndigo when isSelected is true" do not follow the
   skill's `shows <outcome> when <condition>` form, and the last two are phrased around the
   implementation (and the third is ungrammatical). The other two files' names are fine.

Also unexercised from the [ALL-AC7] matrix, in rough priority order: pill radius on both chips,
label truncation in a narrow parent, the 44px hit target, absence of a checkmark/icon in the chip
tree, the glass fill/blur on `ContextChip` and `StatPill`, and "no tap handler in the tree" for
`ContextChip`. Several of these are styling assertions the skill would rather see kept minimal, so
they are listed for the grading pass to decide, not as required additions.

## Architectural compliance

Status: PASS

Checked against `tdd.md`, the `flutter-widgets` skill and the `flutter-widget-test` skill.

`tdd.md` — every class name, file path and structure matches: `FilterCountChip`, `ContextChip`,
`StatEntry`, `StatTile`, `StatPill`, private `_StatPair`, all in the three named files; the
`GestureDetector` → `ConstrainedBox` → `Center` → `DecoratedBox` → `Padding` → `Row` shape; the
`GlassSurface` reuse in both glass components; every token composition (`meta`, `pill`,
`statFigure`, `microLabel`) as designed; no unlisted package; no state, repository or use case
added. Where `tdd.md` still shows `13`, `Flexible` in `StatPill` and a `for` loop, `code-plan.md`'s
second-pass delta explicitly supersedes it and the code follows the delta.

`flutter-widgets` skill — placement in `lib/widgets/`, one file per family, private helper in the
same file, no `default` prefix, `const` constructors, no `Widget`-returning function, no spacing of
its own, no border or custom paint, all dimensions even, and the `Expanded`-over-`Flexible` rule
correctly applied with its hug-content exception (`Expanded` in `StatPill`, `Flexible` held in the
two `mainAxisSize.min` chips — the exception was flagged and confirmed by the human at Phase 3
round 2). Deleting `default_choice_chip.dart` rather than deprecating it is the skill's
"reuse before rebuilding" clause being overridden by [1.5-AC1], recorded in `tdd.md ## Reuse
decisions`. Import order and `const` usage conform.

`flutter-widget-test` skill — no test file is in this run's allowlist, so its mandatory-FAIL clause
does not bind here. The human's three files are reviewed above as advisory findings routed to the
human, not as a compliance failure of this commit.

FAILs: NONE

WARNINGs:
- `library_stats.dart` carries whole-file formatter churn beyond the stat-tile edit — roughly a
  dozen hunks in `_buildNowPlayingCard`, `_buildTopGameCard`, the checklist rows and the
  `showChecklist` expression that only rewrap arguments. Behaviour is identical and
  `_DashedBorderPainter` is semantically untouched, so [1.7-AC11] is not failed, but "no other part
  of that file changes" was taken loosely. Worth a one-line note for the next run that edits this
  file so the churn is not mistaken for intent.
- `tech-ac.md` [1.6-AC5] and [1.7-AC2] still read `13` while the shipped, approved values are 12 and
  14. The override lives only in `code-plan.md`'s second-pass delta. Documentation drift, not a code
  defect — but the next reader of `tech-ac.md` alone will measure the wrong number. Suggest the
  orchestrator fold the delta into `tech-ac.md` or add a pointer beside those two criteria.
- `orchestrator-state.md` still shows three different test baselines (+265 -11, +256 -10, +259 -10)
  with only prose marking which wins. The correct one is +259 -10. Suggest updating the header
  fields rather than leaving the correction in a note.

## Escalation required

NONE

The Dev commit passes. Two follow-ups for the human, neither blocking:
- the four manual visual checks at the top of this report;
- the advisory findings on the three human-authored test files, for the grading pass — in
  particular the missing `StatTile` coverage, the uncovered count-`0` case, and the hardcoded
  palette literals in `filter_count_chip_test.dart`.

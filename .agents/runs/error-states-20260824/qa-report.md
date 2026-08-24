# QA Report
Source: `tech-ac.md` (week 2 Stage 2 item 2.7 — Error states)
Date: 2026-08-24

Overall result: FAIL

One defect: a widget test that cannot fail if the behaviour it names regresses
(`error_notice_test.dart:120–129`). Everything else — analyzer, suite, all 35
criteria, the dead-code fence, the token trap, the inspection-only fence — holds.
Route to Dev Agent.

## Manual verification required

[2.7-AC10] — Render `DestructiveActionPair` in a scratch harness (ships unwired; no
real caller exists) — expect the destructive action to read as the loud one
(`errorStrong` fill, white label) and the safe action as plain quiet ink (`ink08`),
both at least 44px tall and comfortably tappable.

[2.7-AC26] — Render `FailedItem` wrapping a 64px `GameCard` in a scratch harness,
then again inside a dense grid — expect the badge in the top-right corner, the same
slot `LibraryTick` occupies (`game_card.dart:97`), and the dimmed item still findable
without reading any text. Also render an item that is **both** in-library and failed
and confirm the indigo tick and the red badge do not overlap illegibly — the two
share the identical `Positioned(top: 8, right: 8)` slot, so on a real card they will
sit on top of each other. This is the one manual check that could turn into a design
question rather than a sign-off.

[2.7-AC29] — Open game detail for any game — expect the "Screenshots" heading to
still render (now heading an empty section) and nothing else on the screen to have
changed. Heading confirmed present in source at `game_detail_screen.dart:64`.

[2.7-AC13]/[2.7-AC15]/[2.7-AC17] visual — Render both `ErrorNotice` variants at 390px
in a scratch harness — expect the strip to read as a tinted band with a legible
hairline and a comfortable close target, and the toast to stay on **one line** with an
ellipsis when given long copy. Token identity is test-covered; legibility is not.

[2.7-AC21] visual — Render `FailedItem` over real cover artwork — expect the artwork
itself dimmed (not just its text) and the hairline **not** dimmed with it.

All five need a scratch harness or the first real caller: the module ships unwired
per [2.7-AC32], so no shipped screen renders any of it. Deferred to the Stage 2
manual backlog per the standing decision.

## Static analysis
Status: PASS
Errors: NONE

`flutter analyze` — 33 issues (0 errors, 2 warnings, 31 info). Matches the recorded
baseline exactly. Zero issues attributed to any allowlisted file. The 2 warnings are
the pre-existing `_TaskReminder` pair in `task_detail_screen.dart:201,204`, a file
this run did not touch. No `build_runner` / `intl_utils` step was required or run —
no annotated source, no `.arb` edit, no route change in the diff.

## Test results
Status: PASS
Tests run: 353  |  Passed: 343  |  Failed: 10

Testing mode: **smoke**. Full suite run; result `+343 -10`, against a baseline of
`+325 -10`. All 10 failures verified by name as the pre-existing set, unchanged in
identity and count:

- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

No regression. The 18 new passing tests (16 widget + 2 token) account for the delta.

## Scope check (git, not `diff-summary.md`)

`git diff --name-status e0b2111..7d69ba4` — 12 source/test paths, every one on the
allowlist; plus the six run-folder artifacts, which are pipeline documents, not
source. `git status --short` is clean — no uncommitted change. No file appears in git
that `diff-summary.md` failed to mention, with the one exception already surfaced and
accepted at the Phase 4B gate (the `dart format` `Icon` reflow, below).

`orchestrator-state.md ## Deviation approvals` reads `NONE`. The one deviation
`diff-summary.md` records has no matching approval line there, but it was reviewed and
explicitly accepted in `## Code review outcomes` — treated as approved, not as an open
deviation, per the run's own record.

## Acceptance criteria

[2.7-AC1]: PASS — `app_color_tokens.dart` gains `surfaceToast` in all four required
places: constructor (`:26`), field declaration in the Surfaces group directly after
`surfaceTabChrome` (`:63`), `dark` at `Color(0xFF2E3236)` (`:112`), `copyWith`
(`:180`, `:216`), `lerp` (`:263`). No doc comment.

[2.7-AC2]: PASS — the diff adds a line beside `surfaceTabChrome` in each of those
places and changes none of them; `surfaceTabChrome` keeps its name and `0xFF2E3236`.
No tab-bar file is in the diff (`bottom_tab_bar.dart` and `theme_data_dark.dart` both
absent from `git show --name-only`).

[2.7-AC3]: PASS — and the token trap is cleared. `app_tokens_test.dart:52–54` asserts
`colors.surfaceToast == Color(0xFF2E3236)`; `:56–61` independently asserts
`colors.surfaceTabChrome == Color(0xFF2E3236)`. Two separate `test()` blocks, each
naming its own token, neither comparing the two to each other. The "three distinct
raised surfaces" `Set` at `:38–50` is byte-for-byte unchanged and still contains only
`surfaceRaised`, `surfaceIndigoPanel`, `surfaceTabChrome` — `surfaceToast` was added
only to the `_allColors` helper (`:500`), exactly as prescribed.

[2.7-AC4]: PASS — `git diff --name-status` shows no other file under
`lib/config/theme/`; `app_type_tokens.dart`, `app_radius_tokens.dart`,
`app_status_tokens.dart` and the theme wiring are all absent from the diff.

[2.7-AC5]: PASS — `destructive_action_pair.dart:38` fills the destructive button with
`colors.errorStrong`, `:30` fills the safe one with `colors.ink08`. Asserted by
`destructive_action_pair_test.dart:36` ('fills the destructive action with the
errorStrong token') and `:48` ('keeps the safe action off the error ramp and off
green'), both naming `AppColorTokens.dark.<token>`.

[2.7-AC6]: PASS — no `green` token appears in the module (grep over
`lib/widgets/error_states/`). Both fills and both label colours are passed explicitly
at `destructive_action_pair.dart:30–31,38–39`, so `primary_button.dart:29`'s
`?? tokens.color.green` default never resolves. Asserted at
`destructive_action_pair_test.dart:57–69`. The residual green is `ButtonPressScale`'s
app-wide focus ring, drawn by another component — the tension `tdd.md` recorded and
the Phase 3 gate accepted.

[2.7-AC7]: PASS — `destructive_action_pair.dart:6–12`, all four parameters `required`
with no default; no `String` literal anywhere in the file.

[2.7-AC8]: PASS — `destructive_action_pair_test.dart:72` and `:92`; each asserts its
own counter is 1 and the other is 0.

[2.7-AC9]: PASS (inspection, no test — correct) — `destructive_action_pair.dart:6–17`
exposes exactly `destructiveLabel`, `safeLabel`, `onDestructive`, `onSafe`. No
outline/variant parameter, no enum, no named constructor. No test names this criterion.

[2.7-AC10]: MANUAL — see above. Code side is right: `primary_button.dart:25` sets
`BoxConstraints(minHeight: 44)` and both actions inherit it; the destructive fill is
`errorStrong` and the safe fill is the neutral `ink08`.

[2.7-AC11]: PASS (inspection, no test — correct) — the API-surface check, done directly
on the source. `error_notice.dart:7–16`: the constructor takes `required this.variant`,
`required this.message`, `required this.onDismiss` and nothing else; the field is
`final ErrorNoticeVariant variant` — non-nullable, no default, no `?`. `build`
(`:19–27`) is a two-arm exhaustive `switch` returning `_ErrorStrip` **or**
`_ErrorToast`, never a composition of both. There is no `child`, `content`, `visible`,
`showToast`, `padding` or any other parameter through which a caller could get both
surfaces — the absence is confirmed against the full parameter list, not inferred.
`ErrorNoticeVariant` (`enum/error_notice_variant.dart:1`) has exactly two values.
"Both at once" is unrepresentable.

[2.7-AC12]: PASS — `error_notice_test.dart:40` (strip present via `errorTint`
`DecoratedBox`, `ErrorDot` absent) and `:58` (toast present via a `ColoredBox` in
`surfaceToast`, no `Icon` descendant). One test per variant, each asserting presence
and absence.

[2.7-AC13]: PASS — `error_notice.dart:42–44` (`errorTint` fill, `errorLine` border) and
`:55` (`errorInk` message). Asserted at `error_notice_test.dart:84–101`, all three
naming their token.

[2.7-AC14]: PASS (behaviour) — `error_notice.dart:6` `ErrorNotice extends
StatelessWidget` and `:30` `_ErrorStrip extends StatelessWidget`; neither holds a
`_dismissed` flag or any field beyond its inputs, so the "no stored dismissal state"
guarantee is a property of the type. The dismiss affordance is
`error_notice.dart:59–74` and `error_notice_test.dart:103` proves the callback fires
exactly once and the notice leaves the tree. **However** the test written for the
re-show half of this criterion does not protect it — see Architectural compliance. The
criterion is met; its guard is not.

[2.7-AC15]: PASS — `error_notice.dart:94` fills the toast with
`tokens.color.surfaceToast`; asserted by token name at `error_notice_test.dart:63–73`.

[2.7-AC16]: PASS — `error_notice.dart:100` renders `const ErrorDot(size: 8)` with no
glyph, so `error_dot.dart:20–22` gives it a `null` child and no `Icon` is built. The
toast branch contains no icon widget. Asserted at `error_notice_test.dart:74–80`
(`find.byType(Icon)` scoped under `ErrorNotice`, `findsNothing`) and the dot's `error`
fill at `:131–144`.

[2.7-AC17]: PASS — `error_notice.dart:107–108`, `maxLines: 1` and
`TextOverflow.ellipsis`. Asserted at `error_notice_test.dart:146–153` on the `Text`
widget's properties, not on any rendered width or height.

[2.7-AC18]: PASS (inspection, no test — correct) — grep for `Duration`, `Timer`,
`seconds`, `milliseconds` over `error_notice.dart` returns nothing. Neither
`ErrorNotice` nor `_ErrorToast` mints a display duration or holds a timer. No test
names this criterion.

[2.7-AC19]: PASS — `error_notice.dart:10` `required this.message`, no default. The one
string either variant owns is the dismiss affordance's accessibility label, taken from
`MaterialLocalizations.of(context).closeButtonTooltip` (`:62`). No English literal, no
`.arb` edit in the diff.

[2.7-AC20]: PASS (inspection, no test — correct) — the same parameter-list check as
[2.7-AC11]. Neither variant takes a `child`, `content` or `visible`; neither wraps or
replaces page content; `_ErrorStrip` and `_ErrorToast` are leaf surfaces sized to their
own content. Nothing in the API can remove what renders underneath. No test names this
criterion.

[2.7-AC21]: PASS — `failed_item.dart:27` `Opacity(opacity: 0.55, child: child)`, an
opacity and not a recolour; `:21–26` a foreground-positioned `DecoratedBox` with an
`errorLine` `Border.all` **outside** the `Opacity`, so the hairline is not itself
dimmed; `:29–37` the overlaid corner badge.

[2.7-AC22]: PASS — `failed_item_test.dart:34` ('dims the wrapped child to 55 percent')
and `:49` ('draws the surrounding hairline in the errorLine token', naming
`AppColorTokens.dark.errorLine`). Neither asserts a width, size or offset.

[2.7-AC23]: PASS — `failed_item.dart` has no `Text` and no badge-label parameter
(`:6–13` is `semanticsLabel` + `child` only); the badge is an `ErrorDot` with an
`IconData` glyph, which is a mark, not a word. Asserted at `failed_item_test.dart:95`
with a non-`Text` child (`Icon(Icons.videogame_asset)`), so the assertion means
something — the trap `tdd.md` flagged is handled.

[2.7-AC24]: PASS — `failed_item.dart:32–36` wraps the badge in
`Semantics(container: true, label: semanticsLabel)`; the label is caller-supplied, not
hardcoded. Asserted at `failed_item_test.dart:82` via `find.bySemanticsLabel`.

[2.7-AC25]: PASS — `error_dot.dart:19` fills with `colors.error` (never `errorStrong`,
never magenta); asserted at `failed_item_test.dart:67–80` naming
`AppColorTokens.dark.error`. `ErrorDot` takes no colour parameter, so the toast dot and
the item badge cannot drift.

[2.7-AC26]: MANUAL — see above. `failed_item.dart:29–31` is `Positioned(top: 8,
right: 8)`, character-identical to `game_card.dart:97`'s `LibraryTick` slot (verified
by reading both).

[2.7-AC27]: PASS (inspection, no test — correct) — `failed_item.dart:6–13` exposes
`semanticsLabel` and `child` only. No `isFailed`, no pass-through mode, no branch that
renders the child untouched. No test names this criterion.

[2.7-AC28]: PASS — `git show --name-status 7d69ba4` reports
`D lib/features/game_detail/presentation/screens/detail_screenshot_section.dart` — a
true deletion, not an emptied or stubbed file. `game_detail_screen.dart` loses exactly
the blank line, the `/// TODO: fetch screenshots - from game detail` comment and the
`// DetailScreenshotsSection(id: gameExtra!.$1);` line (former 71–73). A repo-wide grep
for `DetailScreenshotsSection` and `detail_screenshot_section` over `lib/` and `test/`
returns nothing — no dangling reference and no import to tidy.

[2.7-AC29]: MANUAL — see above. `game_detail_screen.dart:64` still renders
`S.current.screenshots` inside its `Padding`; the diff removes no live widget.

[2.7-AC30]: PASS — the dead-code fence held, verified against git and grep rather than
against `diff-summary.md`'s claim. `git diff --name-status e0b2111..7d69ba4` lists
exactly four `lib/` paths: `app_color_tokens.dart`, `game_detail_screen.dart`, the one
deletion, and the five new module files. Absent from the diff entirely:
**`lib/widgets/game_screenshot.dart`** (still on disk, last touched by commit `42343e6`
long before this run, and still live — `image_page_view.dart:32` constructs
`GameScreenshot(imageUrl: ..., borderRadius: 0)` inside its `PageView.builder`),
`GameScreenshotCubit` and its state/DI registration, `game_screenshot_entity.dart`,
`screenshot.dart`, `screenshot_response_model.dart`, `auto_route_config.dart` (so
`ImageRouteView`'s registration is intact), `error_retry_widget.dart` and
`default_snackbar.dart`. Nothing was "tidied".

[2.7-AC31]: PASS — re-run independently: 33 issues, 0 errors / 2 warnings / 31 info,
identical to baseline. Zero issues attributed to an allowlisted file; the deletion
orphaned no import and produced no new unused-element hint.

[2.7-AC32]: PASS (inspection, no test — correct) — grep for `ErrorNotice`,
`DestructiveActionPair`, `FailedItem`, `ErrorDot` and `error_states` across `lib/`,
excluding the module folder itself, returns **no match**. No existing screen, widget,
cubit or route references anything built here. `games_screen.dart`,
`task_detail_screen.dart`, `detail_top_header.dart` and `detail_mid_section.dart` are
all absent from the diff. The run ships genuinely unwired. No test names this criterion.

[2.7-AC33]: PASS — grep for `Colors.`, an eight-digit hex literal, `withOpacity` and
`fontSize` over `lib/widgets/error_states/` returns nothing. Every colour in all five
files resolves through `context.tokens.color` (`error_dot.dart:12`,
`error_notice.dart:38,89`, `failed_item.dart:17`, `destructive_action_pair.dart:21`).
Theme access is `context.tokens` throughout, never `Theme.of(context)`.

[2.7-AC34]: PASS (inspection, no test — correct) — every string in the module renders
through `tokens.typography.meta.style` (`error_notice.dart:54,104`) or through
`PrimaryButton`, which uses the same step (`primary_button.dart:33`). No `fontSize`
anywhere in the module; no type token added. No test names this criterion.

[2.7-AC35]: PASS — repo-wide grep for `matchesGoldenFile` over `lib/` and `test/`
returns nothing. Across the three new test files, no assertion measures a dimension,
gap, radius, offset or position; every colour assertion is written as
`AppColorTokens.dark.<token>`, never a raw `Color(0x…)`. The two numeric assertions
present — `opacity.opacity == 0.55` and `maxLines == 1` — are documented contracts
([2.7-AC21], [2.7-AC17]), not measurements.

### Inspection-only fence

The ten criteria marked "never a widget test" — [2.7-AC9], [2.7-AC10], [2.7-AC11],
[2.7-AC18], [2.7-AC20], [2.7-AC26], [2.7-AC27], [2.7-AC29], [2.7-AC32], [2.7-AC34] —
received **no test**. Checked by reading all three new test files end to end: 16 tests
total, each mapping to a tested criterion. No test asserts a constructor parameter
list, a hit-target height, a corner position, a duration, a font size, or the absence
of a wiring reference. The fence holds in both directions.

## Architectural compliance
Status: FAIL

FAILs:

1. **`flutter-widget-test` — a test that cannot fail if its behaviour regresses.**
   `error_notice_test.dart:120–129`, `'shows the strip again when rebuilt with the
   same inputs after a dismissal'`. It pumps `buildSubject(...)`, taps close, pumps the
   identical widget again, and asserts:

   ```dart
   expect(find.byType(ErrorNotice), findsOneWidget);
   ```

   `buildSubject` unconditionally places an `ErrorNotice` in the tree, so that finder
   matches by construction and the assertion is a tautology. Two consequences:
   - The `onDismiss` passed by `buildSubject` defaults to `() {}` (`:34`), so nothing
     is ever removed and "after a dismissal" is not actually established.
   - If `ErrorNotice` were changed into a `StatefulWidget` holding a `_dismissed` flag
     that permanently suppressed the strip — precisely the failure case [2.7-AC14]
     names — the `ErrorNotice` element would still be in the tree and this test would
     still pass.

   That is the skill's review checklist item "Removing the behaviour would make the
   test fail", and it does not. It is also "Assert outcomes, not structure": the test
   asserts the presence of a component type rather than the visible strip. A finder on
   what the strip actually shows (its `errorTint` surface, or the message text) would
   make the test mean what its name says. `[2.7-AC14]`'s implementation is correct
   today; it is simply unguarded.

WARNINGs:

1. **Redundant assertion.** `error_notice_test.dart:53` and `:96` both assert
   `decoration.color == AppColorTokens.dark.errorTint` on the same finder, in two
   different tests. The skill's "reject redundant setup and assertions" applies; the
   variant test at `:40` only needs the presence/absence pair, since `:84` owns the
   token assertion.

2. **Unscoped finders.** `tdd.md`'s finder discipline and `task-brief.md`'s constraint
   both say every finder is `find.descendant`-scoped under the component. Three are
   not: `find.byType(ErrorDot)` (`error_notice_test.dart:54`), `find.text(...)`
   (`:99`, `:149`) and `find.byIcon(Icons.close)` (`:112`, `:123`). All four are
   unambiguous in a bare `MaterialApp` harness so none is currently wrong — but they
   are the exact shape of the item 2.6 bug the discipline was written to prevent.
   Harmless today, noted rather than failed.

3. **Test file length.** `error_notice_test.dart` runs 7 tests / 195 lines against the
   1–2 test reference files the skill names. Six of the seven map to a distinct
   criterion, which is the "reason" the skill allows; the seventh is the FAIL above.

4. **`flutter-widgets` catalogue and "one file per widget family".** The new module is
   not added to the skill's catalogue, and the folder groups four widget families. Both
   are deliberate: `tdd.md` argues the module-folder case against the four shipped
   precedents (`game_card/`, `bottom_tab_bar/`, `completion_ring/`, `countdown/`), each
   family still gets exactly one file, and editing the skill file is outside the
   allowlist by an explicit gate decision. Recorded as the fifth instance of the known
   contradiction, not as a defect of this run.

Against `tdd.md` specifically: class names, file paths, the `enum/` subfolder, the
module's "no internal files" rule (the only private classes are `_ErrorStrip` and
`_ErrorToast` nested inside `error_notice.dart`, and no test names or imports either —
verified by reading all three test files' imports, which reach only
`error_notice.dart`, `error_dot.dart`, `enum/error_notice_variant.dart`,
`failed_item.dart`, `destructive_action_pair.dart` and `primary_button.dart`), no new
package, no state layer, no code generation — all as designed. Zero comments across all
five module files, per `flutter-widgets`' absolute no-comments rule. Every dimension the
module writes is even (8, 10, 12, 14, 16, 20, 44). Imports are SDK → package →
alphabetised in every file. `Expanded` used over `Flexible` in both `Row`s.

### Previously accepted, restated not re-raised

- **The finder deviation.** `tdd.md`'s prescribed
  `find.descendant(of: ErrorNotice, matching: find.byType(ColoredBox))` is genuinely
  not single-match in the toast variant — the toast's own `ErrorDot` renders a second
  `ColoredBox` (`error_dot.dart:18`). Dev's replacement at
  `error_notice_test.dart:63–73` is verified: `find.byWidgetPredicate` matching
  `widget is ColoredBox && widget.color == AppColorTokens.dark.surfaceToast`, still
  scoped by `find.descendant` under `ErrorNotice`, asserted `findsOneWidget` — so it is
  single-match by assertion, not by luck. It names the token, uses no `.first` and no
  `Key`. Correctly resolved.
- **The second `game_detail_screen.dart` hunk.** `git show` confirms it: lines 38–44,
  an `Icon(Icons.star, color: Colors.amber)` reflowed from four lines to one.
  Semantically identical, `dart format` output, accepted at the Phase 4B gate.

## Escalation required

`error_notice_test.dart:120–129` asserts nothing → route to: **Dev Agent**

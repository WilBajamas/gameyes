# QA Report
Source: `tech-ac.md` (week 2 Stage 2 item 2.7 — Error states)
Date: 2026-08-24
QA cycle: 2 (cycle 1 = FAIL, routed to Dev)

Overall result: PASS — pending manual checks

Cycle 1's single defect is closed. `error_notice_test.dart`'s re-show test now
drives a real dismissal and asserts the strip's own message content, so
`[2.7-AC14]` is guarded as well as implemented. No source file changed between
cycles, both baselines are unmoved, and the fix introduced no new violation.
Five manual checks stand, deferred to the Stage 2 backlog.

## Manual verification required

Five, all carried forward unchanged from cycle 1. Every one needs a scratch
harness or the first real caller: the module ships unwired per `[2.7-AC32]`, so
no shipped screen renders any of it. Deferred until Stage 2's eight items are
done — listed, not attempted.

[2.7-AC10] — Render `DestructiveActionPair` in a scratch harness — expect the
destructive action to read as the loud one (`errorStrong` fill, white label) and
the safe action as plain quiet ink (`ink08`), both at least 44px tall and
comfortably tappable.

[2.7-AC26] — Render `FailedItem` wrapping a 64px `GameCard`, then again inside a
dense grid — expect the badge in the top-right corner, the same slot `LibraryTick`
occupies, and the dimmed item still findable without reading any text. **Then
render an item that is both in-library and failed.** `failed_item.dart:29–31` and
`game_card.dart:97` are the character-identical `Positioned(top: 8, right: 8)`, so
the red badge and the indigo tick will stack on a real card. That is a gap in
§3.4 — the spec asks for the same slot and never says what happens when both
marks apply — not a defect in this implementation. It needs a design answer, and
the run does not fail on it.

[2.7-AC29] — Open game detail for any game — expect the "Screenshots" heading to
still render (now heading an empty section) and nothing else changed.
Heading present at `game_detail_screen.dart:64`.

[2.7-AC13]/[2.7-AC15]/[2.7-AC17] visual — Render both `ErrorNotice` variants at
390px — expect the strip to read as a tinted band with a legible hairline and a
comfortable close target, and the toast to stay on one line with an ellipsis on
long copy. Token identity is test-covered; legibility is not.

[2.7-AC21] visual — Render `FailedItem` over real cover artwork — expect the
artwork itself dimmed (not just its text) and the hairline **not** dimmed with it.

## Static analysis
Status: PASS
Errors: NONE

`flutter analyze` re-run this cycle — 33 issues (0 errors, 2 warnings, 31 info),
matching the recorded baseline exactly. Zero issues attributed to any allowlisted
file. The 2 warnings are the pre-existing `_TaskReminder` pair
(`task_detail_screen.dart:201`, `:204` — `unused_element`,
`unused_element_parameter`), in a file this run never touched. No `build_runner`
or `intl_utils` step required: no annotated source, no `.arb` edit, no route
change in the diff.

## Test results
Status: PASS
Tests run: 353  |  Passed: 343  |  Failed: 10

Testing mode: **smoke**. Full suite re-run this cycle — `+343 -10`. The pass count
is **unmoved from cycle 1**, so the rewrite replaced one test in place: nothing was
split, added or dropped to reach green. `error_notice_test.dart` still holds 7
tests, all passing, verified by name in the run output.

The 10 failures are the pre-existing set, verified by test name, unchanged in
identity and count:

- `test/repository/tracker/tracker_repository_test.dart` — 4 (`getSavedGames`
  ×2, `listenToSavedGames` ×2)
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

No regression.

## Scope check (git, not `diff-summary.md`)

`git diff --name-status e0b2111..HEAD` — 12 source/test paths, every one on the
allowlist, plus the nine run-folder artifacts, which are pipeline documents.
`git status --short` is clean; no uncommitted change.

The cycle-1 fix is `9f7e6f8`, which touches exactly two paths:
`test/widget/components/error_notice_test.dart` and `diff-summary.md`. `dec6c24`
and `ef4c6db` are run-folder documents only. **No source file was touched between
cycles** — confirmed against git, not against `diff-summary.md`'s account of
itself. Nothing appears in git that `diff-summary.md` failed to mention.

`orchestrator-state.md ## Deviation approvals` still reads `NONE`. The two items
that would otherwise be open deviations — the `find.byWidgetPredicate` finder
substitution and the `dart format` `Icon` reflow in `game_detail_screen.dart` —
are both recorded as reviewed and accepted under `## Code review outcomes`.
Treated as approved, per the run's own record, not as open.

## Acceptance criteria

All 35 PASS or MANUAL; none FAIL or PARTIAL. Cycle 1 verified 34 of them against
the source and the git diff; no source file has changed since, so those findings
stand as written and are summarised rather than re-derived here. `[2.7-AC14]` is
re-verified in full below because its guard is what changed.

[2.7-AC14]: **PASS — now guarded.** Implementation unchanged and correct:
`error_notice.dart:6` `ErrorNotice extends StatelessWidget`, `:30` `_ErrorStrip
extends StatelessWidget`, neither holding a `_dismissed` flag or any field beyond
its inputs, so "stores no dismissal state" is a property of the type. The dismiss
half is `error_notice_test.dart:103` ('calls onDismiss once and leaves the tree
when the strip is dismissed'). The re-show half is now
`error_notice_test.dart:120–152` ('shows the strip content again when rebuilt with
the same inputs after a dismissal'), which passes a real `onDismiss` incrementing
a counter, taps `Icons.close`, asserts `dismissCount == 1` so the dismissal is
established rather than assumed, rebuilds with identical inputs, and asserts:

```dart
expect(
  find.descendant(
    of: find.byType(ErrorNotice),
    matching: find.text('Something failed'),
  ),
  findsOneWidget,
);
```

That names what the strip draws, not that the component type exists. The
criterion's own failure case — a `_dismissed` flag suppressing the strip
permanently — leaves the `ErrorNotice` element in the tree but removes its
message, so the assertion fails. Falsifiability was proved empirically by the
orchestrator before this cycle (regression injected: original test passed 7/7,
replacement failed; both files restored, baseline re-verified) and is not
re-derived here.

[2.7-AC1] through [2.7-AC13]: PASS — as cycle 1. Token added in all five places
with `surfaceTabChrome` untouched and the "three distinct raised surfaces" `Set`
byte-for-byte unchanged (`app_tokens_test.dart:38–61`, the token trap cleared by
two independent `test()` blocks); no other foundations file in the diff;
`DestructiveActionPair`'s `errorStrong`/`ink08` fills, green-free labels, all-
required string-free API and per-callback assertions; `ErrorNotice`'s two-arm
exhaustive switch with a required non-nullable `variant` and no
`child`/`content`/`visible` parameter, making "both surfaces at once"
unrepresentable; per-variant presence/absence; strip
`errorTint`/`errorLine`/`errorInk`.

[2.7-AC15] through [2.7-AC28], [2.7-AC30] through [2.7-AC35]: PASS — as cycle 1.
`surfaceToast` toast fill, iconless toast, `maxLines: 1` + ellipsis, no
`Duration`/`Timer`, caller-supplied message with the close label from
`MaterialLocalizations.closeButtonTooltip`, `Opacity(0.55)` with the hairline
drawn outside it, wordless badge with caller-supplied semantics label, `error`
(not `errorStrong`) dot fill, `detail_screenshot_section.dart` deleted in full
with no dangling reference, the dead-code fence held (`game_screenshot.dart`,
`GameScreenshotCubit`, the screenshot models/entity and `auto_route_config.dart`
all absent from the diff), analyzer clean against baseline, module unwired across
`lib/`, every colour through `context.tokens.color` with no `Colors.`/hex/
`withOpacity`/`fontSize`, one type step, no golden and no dimension assertion.

[2.7-AC10], [2.7-AC26], [2.7-AC29]: MANUAL — see above.

### Inspection-only fence — re-checked, still holds

The ten criteria marked "never a widget test" ([2.7-AC9], [2.7-AC10], [2.7-AC11],
[2.7-AC18], [2.7-AC20], [2.7-AC26], [2.7-AC27], [2.7-AC29], [2.7-AC32],
[2.7-AC34]) still have no test. Re-checked against the rewritten file rather than
assumed: the fix renamed and rewrote one test in place and added none, so the
count is still 16 across the three files, and the replacement asserts message
content — not a constructor parameter list, a hit-target height, a corner
position, a duration, a font size, or the absence of a wiring reference. The fence
holds in both directions.

## Architectural compliance
Status: PASS

FAILs: NONE. Cycle 1's single FAIL is closed.

The rewritten test checked independently against `flutter-widget-test`'s review
checklist:

- **Behaviour-named.** 'shows the strip content again when rebuilt with the same
  inputs after a dismissal' — `shows <outcome> when <condition>`, and the name now
  matches what the assertion actually proves.
- **Removing the behaviour would make the test fail.** Yes — proved by injection,
  not by argument.
- **Asserts an outcome, not structure.** `find.text` on the message the component
  draws, not `find.byType` on a component the harness placed.
- **Single-match finders.** Both are: the `find.descendant` pair is asserted
  `findsOneWidget`, and `find.byIcon(Icons.close)` is unambiguous in this harness.
  No `.first`, no `Key`, no `ColoredBox` finder — so the standing trap (the
  toast's `ErrorDot` renders a second `ColoredBox` under `ErrorNotice`) is not
  touched by this test at all.
- **No dimension, gap, radius, offset or position assertion. Not a golden.**
- **Imports.** Unchanged by the fix; the file reaches only `error_notice.dart`,
  `error_dot.dart` and `enum/error_notice_variant.dart` — the module's public
  entry points. Neither `_ErrorStrip` nor `_ErrorToast` is named or imported
  anywhere.
- **No pre-resolved theme or token set in setup.** There is no `setUpAll` in the
  file; the real theme goes into the pumped widget via `buildSubject`'s
  `buildDarkTheme()`, and this test inspects no token value at all.
- **Setup proportional.** No completer, no fake image bytes, no arbitrary delay,
  no zone, no manually invoked builder. The mid-test `dismissCount == 1` overlaps
  the `:103` dismiss test's assertion but is load-bearing here — it is what makes
  "after a dismissal" real rather than assumed — so it is not the redundancy the
  skill rejects.

WARNINGs (all four carried from cycle 1, none newly introduced):

1. **Redundant assertion.** `error_notice_test.dart:53` and `:96` both assert
   `decoration.color == AppColorTokens.dark.errorTint` on the same finder in two
   different tests. The variant test at `:40` only needs its presence/absence
   pair; `:84` owns the token assertion.

2. **Unscoped finders.** `tdd.md`'s finder discipline asks every finder to be
   `find.descendant`-scoped under the component. Three are not:
   `find.byType(ErrorDot)` (`:54`), `find.text(...)` (`:99`, `:172`) and
   `find.byIcon(Icons.close)` (`:112`, `:132`). All unambiguous in a bare
   `MaterialApp` harness, so none is wrong today — but this is the shape of the
   item 2.6 bug the discipline exists to prevent. The fix notably did **not**
   spread this: its own new assertion is properly scoped.

3. **Test file length.** Now 7 tests / 217 lines (was 195), against the 1–2 test
   reference files the skill names. The growth is the counter, the real
   `onDismiss` and the scoped finder — the cost of making the test falsifiable,
   which the skill values above brevity. Six of seven map to a distinct criterion;
   the seventh is the re-show guard.

4. **`flutter-widgets` catalogue and "one file per widget family".** The module is
   not added to the skill's catalogue, and the folder groups four widget families.
   Both deliberate: `tdd.md` argues the module-folder case against four shipped
   precedents (`game_card/`, `bottom_tab_bar/`, `completion_ring/`, `countdown/`),
   each family still gets exactly one file, and editing the skill file is outside
   the allowlist by an explicit gate decision. Fifth instance of the known
   contradiction, not a defect of this run.

Against `tdd.md`: class names, file paths, the `enum/` subfolder, the module's
"no internal files" rule, no new package, no state layer, no code generation — all
as designed, unchanged since cycle 1 since no source file moved. Zero comments
across all five module files. Every dimension the module writes is even. Imports
SDK → package → alphabetised. `Expanded` over `Flexible` in both `Row`s.

### Previously accepted, restated not re-raised

- **The finder deviation.** `tdd.md`'s prescribed
  `find.descendant(of: ErrorNotice, matching: find.byType(ColoredBox))` is not
  single-match in the toast variant — the toast's own `ErrorDot` renders a second
  `ColoredBox` (`error_dot.dart:18`). Dev's `find.byWidgetPredicate` on
  `ColoredBox.color == AppColorTokens.dark.surfaceToast`, still `find.descendant`-
  scoped and asserted `findsOneWidget`, is single-match by assertion rather than
  by luck. Correctly resolved.
- **The second `game_detail_screen.dart` hunk.** An `Icon(Icons.star, color:
  Colors.amber)` reflowed from four lines to one by `dart format`; semantically
  identical, accepted at the Phase 4B gate.

## Escalation required

NONE.

`escalation.md` in this run folder is cycle 1's and is now **stale** — its single
issue is closed. It is the orchestrator's to retire; QA does not delete it.

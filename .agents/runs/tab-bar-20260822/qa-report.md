# QA Report
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar
Date: 2026-08-23
Commit verified: `eaae36e` (code on disk at HEAD `3944118`; `eaae36e..HEAD` touches
run artifacts only, no `lib/` or `test/` change)

Overall result: PASS — pending manual checks

## Manual verification required

Migrate all of these to `.agents/manual-check-backlog.md`.

**A. Carried from the four widget tests removed at Phase 4B** — these four have no
automated guard at all now, by explicit human decision.

MC-1 [2.4-C12 / removed test `reports the destination reached by keyboard traversal
when activated`] — HIGHEST PRIORITY. Open Home on a device or emulator with a
hardware/Bluetooth keyboard (or a desktop/web build). Tab forward from the body into
the bar — expect focus to land on Featured, then Games, Tracker, Browse, Settings in
that visual order and on nothing else inside the bar, then leave the bar. With Tracker
focused, press Enter and then Space — expect each to switch the app to the Tracker tab
with no pointer involved. This is exactly the defect that made `ButtonPressScale`
unusable here (its `FocusableActionDetector` registers no `ActivateIntent`); `InkWell`
is what supplies activation now and nothing automated proves it.

MC-2 [2.4-C15 / removed test `tints the selected destination and cap indigo and the
rest ink55`] — HIGHEST PRIORITY. Open Home on any tab — expect the SELECTED
destination's glyph and label to be indigo (`accentIndigo` `#5865F2`) and the other
four to be 55% white (`ink55`). This run corrects a live shipped inversion (the old
`CustomNavigationDestination` painted unselected in `colorScheme.primary` indigo and
selected in `Colors.grey[100]`); check every one of the five tabs in turn, because
nothing automated proves the correction holds.

MC-3 [2.4-C14 / removed test `fills the bar with the surfaceTabChrome token`] — Open
Home on any tab — expect the bar's fill to be the onyx `surfaceTabChrome` `#2E3236`,
visibly one lightness step off the canvas, with NO top border, hairline, shadow or
Material elevation tint anywhere on its surface. The lightness step is the entire
separation mechanism, so if the bar reads as the same colour as the canvas it has
regressed.

MC-4 [2.4-C22 / removed test `settles a selection change with no running animation
under reduced motion`] — Turn on the OS reduce-motion setting (iOS Settings >
Accessibility > Motion > Reduce Motion; Android Settings > Accessibility > Remove
animations), open Home and tap between tabs — expect the colour change and the cap to
snap instantly with no visible fade or crossfade. Then turn reduce-motion off and
repeat — expect a short 140ms ease.

**B. Criterion lines that were always manual (pixel appearance / feel).**

MC-5 [2.4-C12] — With a destination focused from the keyboard, expect a solid 2px
green outline drawn at a 2px offset inside the cell, not clipped by the bar's top or
side edges, and expect the row NOT to shift or reflow at the moment focus arrives or
leaves (border and padding are reserved permanently in both states).

MC-6 [2.4-C13] — Press and hold a destination — expect it to scale down to 0.97 with
no colour change, and expect NO ink ripple, splash, hover fill or press highlight at
any point during or after the press. A press with no visible response at all also
fails this criterion.

MC-7 [2.4-C16] — Open Home — expect an 18 wide x 3 tall fully-rounded indigo cap
directly ABOVE the selected destination's glyph and above no other. Tap through all
five tabs watching the glyph and label baselines — expect zero vertical shift or row
jump as the cap moves, because all five reserve the same space at all times.

MC-8 [2.4-C17] — Open Home — expect labels at 10px weight 500 in sentence case
("Featured", not "FEATURED"), identical size, weight and font family on the selected
and unselected destinations, with only the colour differing.

MC-9 [2.4-C18] — Open Home — expect all five glyphs drawn outline-only at 20px with a
2px stroke. No filled glyph anywhere in the bar. Confirm each destination still reads
as the same concept it did before this item (featured / gamepad / numbered list /
search / settings).

MC-10 [2.4-C19] — Open Home on a device with a home indicator or gesture bar (iPhone
with a notch/Dynamic Island, or an Android gesture-nav device) — expect the labels to
clear the indicator with no overlap and no dead empty band under them. Then check a
device or emulator reporting a zero bottom inset — expect the bar not to sit flush to
the screen edge (22 fallback).

MC-11 [2.4-C20] — Open Home — expect the five destinations to be exactly equal fifths
of the bar's width. Tap in the gap between two labels and near the top and bottom
edges of a destination's slot — expect every tap inside a fifth to activate that
destination, with no dead zone between cells, and the tappable area to be at least 44
in both dimensions at default text scale.

MC-12 [2.4-C21] — Switch the device to `zh` and raise the OS text size to maximum —
expect each over-long label to stay on ONE line and truncate with an ellipsis, expect
the glyphs to stay put, the bar's height not to grow, and no one destination to
squeeze its neighbours.

MC-13 [2.4-C22] — Tap between tabs at normal motion settings — expect only the
destination colours and the cap to animate, over roughly 140ms with the standard
ease. Expect NO indicator sliding horizontally across the bar and no animation of the
bar's height, position or background.

**C. Deliberate behaviour changes worth eyeballing once on device.**

MC-14 [2.4-C5 — the removed scroll-hide behaviour] — Scroll each of the five tabs'
content up and down hard, including a fast fling — expect the bar to stay fully
visible and identical at all times, never hiding, shrinking, fading or clipping. This
is a deliberate, visible change to a shipped screen (the bar used to collapse its
height to 0 on scroll-down), so it should be seen once rather than only inferred.

MC-15 [2.4-C6 — ships with no dedicated widget test, approved at the gate] — Open
each of the five tabs in turn — expect the same five routes with the same content as
before, each still scrolling exactly as it did, and expect the selected destination to
track the active tab in both directions (tap the bar, and navigate a tab via any other
route change).

## Static analysis
Status: PASS
Errors: NONE

33 issues (0 errors, 2 warnings, 31 info) — matches the recorded post-implementation
baseline of 33 exactly.
- The 2 warnings are the pre-existing `_TaskReminder` pair at
  `lib/features/tracker/presentation/screens/task_detail_screen.dart:201` and `:204`,
  untouched by this run.
- The one net-new info against the Phase 0 baseline of 32 is
  `lib/widgets/bottom_tab_bar/bottom_tab_bar.dart:22` `avoid_redundant_argument_values`
  on the explicit `elevation: 0`. Recorded in `orchestrator-state.md` as an explicit
  human decision to KEEP. Not a defect and not drift.
- No issue is attributable to any other allowlisted file.

No code generation step applies: this item adds no annotated source, no
`freezed`/`json_serializable` model, no injectable registration, no mock and no `.arb`
edit, so `build_runner` was correctly not run and nothing is stale.

## Test results
Status: PASS
Tests run: 322  |  Passed: 312  |  Failed: 10

`+312 -10`, matching the revision's reported result. Testing mode is `smoke`.

The allowlisted test file `test/widget/components/bottom_tab_bar_test.dart` runs 8
tests, all passing (verified in isolation).

The 10 failures are exactly the recorded pre-existing set, none in scope:
- `test/repository/tracker/tracker_repository_test.dart` — 4
- `test/cubit/game_detail/game_detail_cubit_test.dart` — 3
- `test/cubit/games/games_bloc_test.dart` — 3

No new failure.

## Scope check
Status: PASS

`git diff --name-only e881cb5..eaae36e` matches the allowlist exactly — the six
created module files, `home_screen.dart`, the two deletions,
`.claude/skills/flutter-widgets/SKILL.md` and the one test file, plus this run's own
`.agents/runs/tab-bar-20260822/` artifacts. Nothing outside it. `git status` is clean;
no uncommitted change.

Both deleted files are genuinely gone from disk, and no `.dart` file anywhere still
references `scrolled_navigation_bar.dart`, `navigation_destination.dart`,
`ScrolledNavigationBar` or `CustomNavigationDestination` — the only surviving mentions
are in pipeline prose (`task-brief.md`, `tdd.md`, `code-plan.md`, `diff-summary.md`,
`orchestrator-state.md`, `.agents/week-2-task-briefs.md`).

`.claude/skills/flutter-widgets/SKILL.md`: the diff is catalogue table rows only — the
`NavigationDestination` and `ScrolledNavigationBar` rows removed, the `BottomTabBar`
row added verbatim from `code-plan.md ## Approved feedback delta` item 4. No rule
text, no prose section, nothing outside the table.

## Acceptance criteria

2.4-C1: PASS — `enum/bottom_tab_bar_destination.dart:4-21` declares the five in order
featured/games/tracker/browse/settings with the unchanged `S.current.*` labels;
`bottom_tab_bar.dart:33` iterates `.values` in declaration order. Glyph concepts are
preserved against the deleted code (`featured_play_list`→`_outlined`,
`gamepad`→`_outlined`, `format_list_numbered_rtl_rounded`→`format_list_numbered_rtl`,
`search`→`_outlined`, `settings`→`_outlined`). Routes untouched —
`home_screen.dart:16-22` still lists the same five. Test: `shows every destination
label and glyph whichever destination is selected`.

2.4-C2: PASS — `bottom_tab_bar.dart:38` passes `destination.index`;
`bottom_tab_bar_cell.dart:42` `InkWell.onTap`. Test: `reports the tapped destination
index once per tap` asserts `[1, 1, 1]` for a label tap, a glyph tap and a tap in the
cell's padded corner.

2.4-C3: PASS — `bottom_tab_bar.dart:37` `selected: destination.index == selectedIndex`
is the only selection source; the cell's `State` holds `_pressed`/`_focused` only
(`bottom_tab_bar_cell.dart:24-25`), no selection. Test: `moves the selected state to
the destination the caller supplies` — a tap alone leaves the selected node where it
was; a rebuild with a new index moves it.

2.4-C4: PASS — the same `==` comparison makes exactly one destination selected for any
`int`, and never zero for a valid index. Confirmed at runtime: the merged semantics
node for Featured carries `isSelected` and Games carries `hasSelectedState` without
it. Re-tapping the active destination reports its index again via the same unguarded
`onTap`.

2.4-C5: PASS — no file in `lib/widgets/bottom_tab_bar/` imports `service_locator.dart`
or `ScrollNotifier`, and `BottomTabBar`'s constructor
(`bottom_tab_bar.dart:7-11`) exposes only `selectedIndex` and `onDestinationSelected`
— no scroll, visibility, collapse or duration parameter, and no `AnimatedContainer`
over its own height. Test: `keeps all five destinations while the body scrolls with no
scroll state` pumps with nothing registered in `getIt` and drags a `ListView` both
ways.
Note carried forward from `tdd.md`: that test stops discriminating once FOLLOW-UP-1
deletes `ScrollNotifier` — revisit or retire it in that change.

2.4-C6: PASS — `home_screen.dart:25-28` hands the bar `selectedIndex` and
`onDestinationSelected` and nothing else. The `NotificationListener` /
`ScrollNotifier` write at `home_screen.dart:29-43` is deliberately retained per C6's
own "deliberately NOT required here" clause and FOLLOW-UP-1. No dedicated widget test,
per the deviation approved at the gate; see MC-15.

2.4-C7: PASS — `bottom_tab_bar_cell_content.dart:34-39` renders the `Text`
unconditionally, with no selection branch. Test: `shows every destination label and
glyph whichever destination is selected` finds all five labels with index 0 selected
and again with index 4.

2.4-C8: PASS — `bottom_tab_bar_cell.dart:33` `Semantics(selected: widget.selected)`.
Test: `moves the selected state to the destination the caller supplies` asserts
`isSemantics(isSelected: true/false)` before and after a caller-driven index change.

2.4-C9: PASS — `bottom_tab_bar_cell.dart:34-37` uses
`MaterialLocalizations.of(context).tabLabel(tabIndex: index + 1, tabCount:
BottomTabBarDestination.values.length)`. Not hand-rolled, not string-interpolated,
1-based, count derived from the enum. Test: `announces the destination name once with
its localized tab position`. Observed node label: `"Tab 1 of 5\nFeatured"`.

2.4-C10: PASS — `bottom_tab_bar_cell_content.dart:33` constructs
`Icon(destination.icon, size: 20, color: color)` with NO `semanticLabel`;
`bottom_tab_bar_cell.dart:40` sets `excludeFromSemantics: true` on the `Tooltip`;
`bottom_tab_bar_cell.dart:31` `MergeSemantics` collapses the cell to one focusable
node. Test asserts the destination name occurs exactly once in the merged label.
Confirmed at runtime: one merge-boundary node per destination, label `"Tab 2 of
5\nGames"`, actions `[focus, tap]` — the glyph surfaces no node of its own.

2.4-C11: PASS — `bottom_tab_bar_cell.dart:38-40` `Tooltip(message:
widget.destination.label)`; `InkWell` declares `onTap` only, no `onLongPress`, so a
long press cannot report an index. Test: `shows the destination label as a tooltip on
long press without selecting` asserts the tooltip is found and the callback count is
0.

2.4-C12: MANUAL — see MC-1 (traversal order and keyboard activation) and MC-5 (the
focus indicator). Code is right by inspection: exactly one focusable node per cell
(the `InkWell`, which registers `ActivateIntent`), reached in `Row` order, and
`bottom_tab_bar_focus_ring.dart:18-26` draws a solid 2px `tokens.color.green` border
with permanent 2px padding in both states. But the only automated coverage of order
and activation was removed at Phase 4B, so this is now manual-only.

2.4-C13: MANUAL — see MC-6. Code is right by inspection:
`bottom_tab_bar_cell.dart:49-55` `AnimatedScale(scale: _pressed ? 0.97 : 1)` at the
resolved state-change duration, fed by `onHighlightChanged`; ink suppressed at
`:45-46` via `NoSplash.splashFactory` and a transparent `overlayColor`. The press
treatment replaces the ripple rather than removing it.

2.4-C14: MANUAL — see MC-3. Code is right by inspection: `bottom_tab_bar.dart:20-23`
`Material(color: tokens.color.surfaceTabChrome, elevation: 0, surfaceTintColor:
Colors.transparent)` with no border, `BoxShadow` or `Divider` anywhere in the module.
The widget test that asserted the fill was removed at Phase 4B.

2.4-C15: MANUAL — see MC-2. Code is right by inspection:
`bottom_tab_bar_cell_content.dart:22-24` tweens to `tokens.color.accentIndigo` when
selected and `tokens.color.ink55` otherwise, and `:33` and `:38` apply that one colour
to both the glyph and the label, so they cannot disagree. The widget test that proved
the inversion correction was removed at Phase 4B.

2.4-C16: MANUAL — see MC-7. Code is right by inspection: `BottomTabBarCap` is an
unconditional child of the column (`bottom_tab_bar_cell_content.dart:32`), not a
branch, so all five reserve the space at all times; `bottom_tab_bar_cap.dart:14-20`
fixes 18 x 3 with `tokens.radius.full` and swaps only the colour between
`accentIndigo` and `Colors.transparent`. It is the column's first child, above the
glyph. The 3px is the logged, approved exception to the even-number convention. The
colour half was covered by a test removed at Phase 4B.

2.4-C17: PASS (token) / MANUAL for rendered size and weight — see MC-8.
`bottom_tab_bar_cell_content.dart:19` reads `tokens.typography.tabLabel` and `:35`/`:38`
apply `tabLabel.format(...)` and `tabLabel.style.copyWith(color: color)` — the style is
identical in both states with only the colour copied over, so nothing can bold or
restyle on selection. The "not uppercased" half is genuinely proven: the passing test
finds `find.text(destination.label)` against the raw label, which would fail if
`format` uppercased it.

2.4-C18: PASS (identity and colour-driven) / MANUAL for outline drawing, 20px and 2px
stroke — see MC-9. Each glyph takes its colour from the tween
(`bottom_tab_bar_cell_content.dart:33 color: color`) and hardcodes none; the enum names
outline variants and the concepts match the deleted code one-for-one. Test: `shows
every destination label and glyph whichever destination is selected` finds each by
`destination.icon`.

2.4-C19: PASS (consumption and both inset states) / MANUAL for home-indicator
clearance — see MC-10. `bottom_tab_bar.dart:24-30`: `SafeArea(top: false, left: false,
right: false, minimum: EdgeInsets.only(bottom: 22))` leaves `bottom` at its default
`true`, which in the SDK both applies `math.max(padding.bottom, minimum.bottom)` AND
wraps the child in `MediaQuery.removePadding(removeBottom: true)` — so the inset is
reserved and consumed exactly once, and nothing else in the module or in
`home_screen.dart` re-applies it. Top padding 8, horizontal 6 at `:30`. Test:
`consumes the bottom safe-area inset so its content sees none` pumps a 40 bottom inset
and asserts a descendant reads `padding.bottom == 0`, then re-pumps at zero inset.

2.4-C20: MANUAL — see MC-11, as the criterion's own Verification line directs. Built
as specified: `bottom_tab_bar.dart:34` wraps every cell in `Expanded` (equal fifths, no
dead gaps), and `bottom_tab_bar_cell.dart:47-48` puts a
`ConstrainedBox(minHeight: 44)` INSIDE the `InkWell`, so the hit region is the whole
fifth including its padding rather than the glyph and label bounds.

2.4-C21: PASS (no overflow, all five present) / MANUAL for the ellipsis and glyph
stability — see MC-12. `bottom_tab_bar_cell_content.dart:36-37` sets `maxLines: 1` and
`overflow: TextOverflow.ellipsis`, inside an `Expanded` slot whose width does not
depend on the label. Test: `renders every destination without overflow in zh at a
raised text scale` at `textScaleFactor: 2` in `zh`.

2.4-C22: MANUAL — see MC-4 and MC-13. Code is right by inspection: all three
animations run at `tokens.motion.resolve(context, tokens.motion.stateChange)` with
`tokens.motion.standard` (`bottom_tab_bar_cap.dart:16-17`,
`bottom_tab_bar_cell_content.dart:25-26`, `bottom_tab_bar_cell.dart:51-55`), and
`resolve` is the reduced-motion switch. Only colours and the cap animate on a
selection change — nothing animates the bar's height, position or background, and
there is no sliding indicator anywhere in the module. The reduced-motion test was
removed at Phase 4B.

## Architectural compliance
Status: PASS

Verified against `tdd.md`, `code-plan.md ## Approved feedback delta`, the
`flutter-widgets` skill and the `flutter-widget-test` skill (both read in full).

Class names, file paths and the module shape match the approved delta exactly:
`BottomTabBar`, `BottomTabBarCell`, `BottomTabBarFocusRing`,
`BottomTabBarCellContent`, `BottomTabBarCap`, `BottomTabBarDestination`, at the six
specified paths with the enum under `enum/`. Siblings are imported by package path,
never relatively. No barrel file. No new package — `flutter/material.dart` plus the
theme extension only.

**Composition order in `BottomTabBarCell` verified independently, outside in**
(`bottom_tab_bar_cell.dart:31-62`): `MergeSemantics` (31) → `Semantics(selected:,
label: MaterialLocalizations.tabLabel)` (32-37) → `Tooltip(excludeFromSemantics: true)`
(38-40) → `InkWell(NoSplash + transparent overlay)` (41-46) → `ConstrainedBox(minHeight:
44)` (47-48) → `AnimatedScale` (49-55) → `BottomTabBarFocusRing` (56) →
`BottomTabBarCellContent` (58). Identical to the approved skeleton, with no layer
reordered, dropped or inserted. Confirmed behaviourally as well as structurally: the
live semantics tree yields one merge-boundary node per destination with
`[focus, tap]`, `isSelected` on the active one, and label `"Tab N of 5\n<Name>"`.

The Material machinery that had to survive is all present and none of it is
hand-rolled: `MaterialLocalizations.tabLabel`, `Semantics(selected:)`, `Tooltip`, and
the `InkWell` kept for gesture, hit region, focus traversal and keyboard activation
with only its painting suppressed. The glyph carries no `semanticLabel`.

Comments: NONE in any of the six module files, and none in `home_screen.dart` after
its edit — checked line by line. Every colour, duration, curve and radius comes from
`context.tokens`; no `Theme.of(context)`, no literal hex, no literal `Duration`, no
literal radius, no hardcoded user-facing string. `Expanded` is used as mandated, not
`spaceEvenly`. The focus ring is a solid `Border`.

The seven items recorded as deliberate human decisions (scroll-hide removed;
`ScrollNotifier` and its ecosystem left orphaned in place; `home_screen.dart`'s
`NotificationListener` retained; both old widgets deleted rather than `@Deprecated`;
the 3px cap exception; `elevation: 0` kept; the four tests removed at Phase 4B) were
each confirmed present as decided and are NOT reported as defects.

Widget tests checked individually against the `flutter-widget-test` review checklist:
all 8 are named as behaviour statements, comment-free, proportionally set up, drive
the public UI, and assert observable outcomes (visible labels and icons, semantics
selected state and label, tooltip presence, callback values, a consumed MediaQuery
inset). No dimension, gap, radius, offset or position assertion; no colour assertion
of any kind now; no golden test; no completer, fake image bytes, manual builder
invocation, arbitrary delay or swallowed error. The 8-test file is longer than
`stat_pill_test.dart`, with a reason recorded and approved in `task-brief.md ##
Testing mode`.

FAILs: NONE

WARNINGs:
1. **The test file reaches into the module's internals.**
   `test/widget/components/bottom_tab_bar_test.dart:7-8` imports
   `bottom_tab_bar_cell.dart` and `enum/bottom_tab_bar_destination.dart`, and four
   tests locate destinations with `find.byType(BottomTabBarCell)`. Read literally this
   is against `task-brief.md ## Constraints` ("Only `bottom_tab_bar.dart` is imported
   from outside the folder") and against the catalogue row's "not imported from
   outside the folder", and the finder couples those tests to the four-way class split
   the Phase 3 delta introduced — merging the cell back would break them without any
   behaviour changing.
   Graded a WARNING, not a FAIL: the constraint's stated purpose is that no production
   caller depends on the internals, and none does; the assertions themselves are
   behavioural throughout; and `BottomTabBarCell` is a first-class design element
   named in `tdd.md` and the approved delta, not incidental hierarchy.
   Recorded because a cheap non-coupling alternative exists and I verified it works:
   `tester.getSemantics(find.text(destination.label))` returns exactly the same merged
   cell node (`SemanticsNode(merge boundary, actions: [focus, tap], flags:
   [isSelected, ...], label: "Tab 1 of 5\nFeatured")`), so both imports and every
   `byType` finder could be dropped with no loss of coverage. Worth a cleanup in a
   later run if the human agrees; not worth failing this one.
2. **Two criteria now rest entirely on a manual check that used to have a test.**
   C15 (the colour inversion this run exists to correct) and C12 (keyboard
   activation, the very defect that ruled out reusing `ButtonPressScale`) have no
   automated regression guard after the approved Phase 4B trim. This is the human's
   decision and not a defect; it is re-stated here only so MC-1 and MC-2 are not
   treated as routine appearance checks. They are the two highest-value items in the
   backlog.

## Escalation required
NONE

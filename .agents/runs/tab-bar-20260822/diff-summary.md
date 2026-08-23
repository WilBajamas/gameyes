# Diff Summary
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar
Date: 2026-08-23
Branch: claude/questloggd-stage-2-game-card-nxg2vg
Commit: 965b5ee1149abf36b8ef932666400847f02aed68

## Phase 4B revision (2026-08-23)
Commit: eaae36e8636d92b7023f4191a59d029ecf33f095

## Post-QA revision (2026-08-23)
Commit: 31d3f5522b78b0c4cc9ca2e0f902ab6e03d2b0e1

QA passed `eaae36e` with one WARNING: `bottom_tab_bar_test.dart` imported
`bottom_tab_bar_cell.dart` and `enum/bottom_tab_bar_destination.dart` and used
`find.byType(BottomTabBarCell)` in 10 places, against the task brief's own
"only `bottom_tab_bar.dart` is imported from outside the folder" constraint.
The human asked for it fixed before sign-off.

Reworked all 8 tests to go through the public surface only:
- Both module-internal imports dropped. The file now imports
  `bottom_tab_bar.dart` and nothing else from that folder.
- Every `find.byType(BottomTabBarCell)` finder (10 places) replaced with
  `tester.getSemantics(find.text(<label>))`/`tester.element(find.text(<label>))`
  — QA had verified this returns the identical merged semantics node
  (`MergeSemantics` collapses each cell to one node), so there is zero
  coverage loss.
- The two enum-iteration loops (`BottomTabBarDestination.values`) replaced
  with local `_destinationLabels()` / `_destinationLabelsAndIcons()` helpers
  built from `S.current.*` and the same `Icons.*` constants the enum uses —
  no import of the internal enum.
- Index-based reach (`.at(0)`, `.at(1)`, `.at(2)`) replaced with reach by
  label (`S.current.featured`, `.games`, `.tracker`).
- The one test that taps a cell at an offset from its top-left corner (to
  prove the whole cell, not just the glyph, is tappable) now finds the
  ancestor `InkWell` of the destination's label text instead of naming
  `BottomTabBarCell` — `InkWell` is a public Flutter type, not a module
  internal, and it is the same widget that owns the tap gesture and the
  cell's full hit region, so the behaviour under test is unchanged.

No source file touched — `lib/` is exactly as it was in `eaae36e`, including
`bottom_tab_bar.dart`'s `elevation: 0`. Test count unchanged at 8; no
assertion weakened, none added or removed.

Verification: `flutter analyze` — 33 issues (0 errors, 2 pre-existing
warnings, 31 info), unchanged. `flutter test` — +312 -10, unchanged; all 8
`bottom_tab_bar_test.dart` tests pass; the 10 failures are the same
pre-existing set (tracker repository 4, game_detail cubit 3, games bloc 3).
No new failure.

Human review of `965b5ee` asked for one change: remove four widget tests from
`test/widget/components/bottom_tab_bar_test.dart`, taking it from 12 tests to 8.
Removed, by name, with no replacement and no redistribution of their
assertions into the surviving tests:
- `reports the destination reached by keyboard traversal when activated`
- `fills the bar with the surfaceTabChrome token`
- `tints the selected destination and cap indigo and the rest ink55`
- `settles a selection change with no running animation under reduced motion`

These four behaviours are now covered by manual device check only, per the
human's explicit decision.

Stranded code removed along with the tests: the `flutter/services.dart`
import (`LogicalKeyboardKey`, keyboard-traversal test only), the
`core/utils/extensions.dart` import (`tokens`, used only by the removed
colour/chrome/reduced-motion tests), the `bottom_tab_bar_cap.dart` import
(`BottomTabBarCap`, cap-colour test only), and the `disableAnimations`
parameter on `buildSubject` (reduced-motion test only). No other file
touched; `lib/` untouched, including `bottom_tab_bar.dart`'s `elevation: 0`.

Verification: `flutter analyze` — 33 issues (0 errors, 2 pre-existing
warnings, 31 info), unchanged from baseline. `flutter test` — +312 -10 vs.
the prior +316 -10; the 8 surviving `bottom_tab_bar_test.dart` tests all
pass; the 10 failures are the same pre-existing set (tracker repository 4,
game_detail cubit 3, games bloc 3) — no new failure.

## Files created
lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart — module-internal enum, five destinations in order with outline icon and `S.current` label
lib/widgets/bottom_tab_bar/bottom_tab_bar_cap.dart — `BottomTabBarCap`, the 18x3 fully-rounded cap, indigo when selected
lib/widgets/bottom_tab_bar/bottom_tab_bar_focus_ring.dart — `BottomTabBarFocusRing`, the 2px green focus outline with permanently reserved padding
lib/widgets/bottom_tab_bar/bottom_tab_bar_cell_content.dart — `BottomTabBarCellContent`, the cap-glyph-label column with the colour tween
lib/widgets/bottom_tab_bar/bottom_tab_bar_cell.dart — `BottomTabBarCell`, one destination's interaction/accessibility shell (semantics, tooltip, ink well, 44 min, press scale)
lib/widgets/bottom_tab_bar/bottom_tab_bar.dart — public `BottomTabBar`, the token-driven chrome and row of five `Expanded` cells

## Files modified
lib/features/home/presentation/screens/home_screen.dart — swapped `ScrolledNavigationBar` + `NavigationBar` + five `CustomNavigationDestination` for `BottomTabBar(selectedIndex:, onDestinationSelected:)`; dropped the now-unused `navigation_destination.dart`, `scrolled_navigation_bar.dart` and `generated/l10n.dart` imports; the `NotificationListener<UserScrollNotification>` body wrapper, its `ScrollNotifier` write and its imports are untouched
lib/widgets/scrolled_navigation_bar.dart — DELETED
lib/widgets/navigation_destination.dart — DELETED
.claude/skills/flutter-widgets/SKILL.md — catalogue table only: removed the `NavigationDestination` and `ScrolledNavigationBar` rows, added the `BottomTabBar` row verbatim from `code-plan.md ## Approved feedback delta` item 4

## Test files
test/widget/components/bottom_tab_bar_test.dart — the twelve tests named in `code-plan.md`: destination labels/glyphs, tap reporting, caller-driven selection, screen-reader selected state + localized tab position, tooltip without selecting, keyboard traversal + activation, building/staying put with no scroll state registered, `surfaceTabChrome` fill, selected/unselected colour + cap, safe-area consumption, `zh`/raised text-scale rendering, reduced-motion settling

## Self-corrections
NONE

## Deviations from implementation plan
None in structure or behaviour. Two test description strings were shortened from the plan's prose to fit the project's 80-character line-length lint (e.g. "...without reporting a selection" → "...without selecting"); the behaviour asserted is unchanged.

## Verification against baseline
`flutter analyze` — 0 errors, 2 warnings (pre-existing `_TaskReminder` pair, untouched), 31 info (33 issues) vs. baseline 32. The one net new info is `lib/widgets/bottom_tab_bar/bottom_tab_bar.dart:22` `avoid_redundant_argument_values` on the plan-mandated explicit `elevation: 0` (kept verbatim from `code-plan.md`'s approved skeleton, documenting C14's zero-elevation requirement). Deleting the two old files removed no analyzer issues (neither was flagged at baseline).

`flutter test` — +316 -10 vs. baseline +304 -10. The 12 new tests are `bottom_tab_bar_test.dart`, all passing. The 10 failures are exactly the pre-existing set: `test/repository/tracker/tracker_repository_test.dart` (4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3), `test/cubit/games/games_bloc_test.dart` (3) — confirmed by re-running those three files in isolation; no new failure.

## Acceptance criteria status
2.4-C1: satisfied
2.4-C2: satisfied
2.4-C3: satisfied
2.4-C4: satisfied
2.4-C5: satisfied
2.4-C6: satisfied
2.4-C7: satisfied
2.4-C8: satisfied
2.4-C9: satisfied
2.4-C10: satisfied
2.4-C11: satisfied
2.4-C12: satisfied (test covers order + activation; focus-ring appearance is the manual device check per plan)
2.4-C13: satisfied — manual device check per plan (press scale 0.97, no ink); AnimatedScale wiring built and verified by inspection
2.4-C14: satisfied
2.4-C15: satisfied
2.4-C16: satisfied (colour half verified by test; 18x3 geometry and no-shift is the manual device check)
2.4-C17: satisfied (token used; size/weight is the manual device check)
2.4-C18: satisfied (colour-driven by state, same concept per destination verified; outline/20px/2px stroke is the manual device check)
2.4-C19: satisfied
2.4-C20: satisfied — manual device check per plan (Expanded + 44 minHeight built as specified)
2.4-C21: satisfied
2.4-C22: satisfied

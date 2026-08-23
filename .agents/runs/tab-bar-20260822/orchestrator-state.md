# Orchestrator State
Feature: Week 2 Stage 2 item 2.4 — Tab bar
Run ID: tab-bar-20260822
Run folder: .agents/runs/tab-bar-20260822/
Started: 2026-08-22
Current phase: COMPLETE
Result: PASS — pending manual checks
Completed: 2026-08-22
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 30 info (32 issues) — captured 2026-08-22. **Post-implementation it is 33**, by human decision: the explicit `elevation: 0` on `Material` in `bottom_tab_bar.dart:22` raises one `avoid_redundant_argument_values` info. Kept deliberately (it is redundant — `Material` defaults to 0, and `surfaceTintColor: Colors.transparent` is what suppresses the M3 tint). Later runs inherit 33 as the baseline; this is not drift.
Test baseline: +304 -10 — captured 2026-08-22
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/questloggd-stage-2-game-card-nxg2vg
Base branch: develop
Base SHA: e881cb5
Dev commit: 31d3f55 (post-QA test-decoupling revision of eaae36e, itself a revision of 965b5ee)
Last updated: 2026-08-22

Note: items 2.1, 2.2 and 2.3 are all merged to `develop` at `e881cb5`, and the
session branch was restarted from `develop` at that SHA — so branch and `develop`
are identical at Phase 0. The analyzer baseline is 32, not the 33 that earlier
runs recorded: item 2.3 removed a deprecated-API usage along with the old inline
countdown builders. Verified by the orchestrator post-merge, not inherited.

Caller survey done at Phase 0: `ScrolledNavigationBar` and `navigation_destination.dart`
have exactly ONE caller between them — `home_screen.dart:30`. The checklist's
"single caller (home screen's shell)" claim is accurate here, unlike item 2.1's
caller list, which named two features that never referenced the component at all.

## Escalation history
2026-08-22 Phase 1 — BA Agent — CRITICAL: `ScrolledNavigationBar` hides on scroll (an `AnimatedContainer` collapsing height to 0, driven by the `getIt` `ScrollNotifier` singleton). Live on the shipped Home shell for all five tabs. Neither §3.2 nor home §6 decides whether that behaviour survives the rework, and it is a scope decision rather than a style one — the notifier has three writers (`home_screen.dart:61`, `browse_screen.dart:19`, `settings_screen.dart:26`) plus a DI registration and a test registration, all outside this component. Verified by the orchestrator. — Resolved: human chose to DROP the scroll-hide behaviour; the bar becomes static chrome per §3.2 and home §6's "fixed to the bottom of the frame". This is a deliberate, visible behaviour change on a shipped screen, not an oversight. The orphaned `ScrollNotifier` singleton, its DI registration, the three writer sites (`home_screen.dart:61`, `browse_screen.dart:19`, `settings_screen.dart:26`) and `settings_screen_test.dart`'s registration are deliberately left in place as a logged follow-up rather than widening a chrome item into four unrelated files — same call item 2.1 made about `PlatformRowList`.

## Deviation approvals
2026-08-22 Design approved at Phase 3 after one revision round. Human-directed: `_TabDestinationCell` split into four classes (it was carrying semantics, tooltip, ink, press+focus state, focus ring, colour tween and the content column), and the component moved from a flat file to the `lib/widgets/bottom_tab_bar/` module folder matching `game_card/`, `completion_ring/` and `countdown/`. Note the enum is INTERNAL here — the caller passes an `int` — unlike the other three modules where it is public API; that inconsistency is the human's explicit call for shape consistency, not an accident.
2026-08-22 `Expanded` kept over `MainAxisAlignment.spaceEvenly` — settled by the orchestrator after the human queried it. `Expanded` is what delivers equal-width tap targets with no dead gaps between cells, the 44px minimum without extra per-cell constraints, stable layout under `zh` and text scaling, and even cap spacing; Material's own `NavigationBar` uses it internally. Recorded as a named constraint in `task-brief.md` so it is not "simplified" later.
2026-08-22 `.claude/skills/flutter-widgets/SKILL.md` added to the allowlist (catalogue rows only) — orchestrator's call. This run deletes two widgets the catalogue lists; items 2.1–2.3 all updated it in-run, so this restores consistency rather than setting a precedent.
2026-08-22 Both old files DELETED rather than `@Deprecated`, against the usual reuse-before-rebuild convention — keeping `ScrolledNavigationBar` alive would leave the codebase's only remaining reader of `ScrollNotifier` in the tree, cutting against C5 and blurring what FOLLOW-UP-1 owns. Approved at the gate.
2026-08-22 C6 ships with no dedicated widget test — after the rewire the bar's constructor exposes only index and callback, so passing scroll state is not expressible and the analyzer enforces it. A real test would mean standing up `AutoTabsRouter`, DI and BLoCs for all five tab screens to assert one wiring line. Approved at the gate.

## Code review outcomes
2026-08-22 965b5ee — Sent back to Dev at Phase 4B: remove four widget tests, taking the file from 12 to 8. Human-directed trim, not a Dev error.
Removed: 'reports the destination reached by keyboard traversal when activated' (C12), 'fills the bar with the surfaceTabChrome token' (C14), 'tints the selected destination and cap indigo and the rest ink55' (C15), 'settles a selection change with no running animation under reduced motion'.
FLAGGED TO THE HUMAN before the removal, and accepted by them — two of the four carry more than their names suggest, same shape as item 2.2 where one removed colour test silently took three criteria with it:
- The keyboard-traversal test was the ONLY automated coverage of keyboard activation, which is precisely the defect that shaped this design: `ButtonPressScale` was rejected for reuse because its `FocusableActionDetector` registers no `ActivateIntent`. After removal, the bug the design was built to avoid has no regression guard.
- The colour test was the ONLY automated proof that the pre-existing colour INVERSION is fixed (`CustomNavigationDestination` shipped unselected in `colorScheme.primary` indigo and selected in `Colors.grey[100]`). This run corrects a live bug; after removal nothing automated proves the correction holds.
Both are carried into the manual-check backlog instead.
2026-08-22 eaae36e — Revision reviewed and approved by human at Phase 4B; released to QA. Orchestrator re-verified: 8 tests remain, `lib/` untouched, tests +312 -10, analyzer 33. Dev also cleaned up what the removals stranded (three imports and a `buildSubject` parameter).
2026-08-22 `elevation: 0` KEPT by explicit human decision after the orchestrator recommended dropping it. It is a genuinely redundant argument and raises the analyzer baseline from 32 to 33 — accepted knowingly, not overlooked. Do not "fix" it in a later sweep without asking.

## Post-QA note
`qa-report.md` was written against `eaae36e` and returned PASS — pending manual
checks, with one WARNING: the test file imported two module-internal files and used
`find.byType(BottomTabBarCell)` in 10 places, against `task-brief.md`'s own
"only `bottom_tab_bar.dart` is imported from outside the folder" constraint. The
human chose to fix it before sign-off rather than log it.

Dev commit `31d3f55` reworked all 8 tests onto the public surface only. Verified by
the orchestrator rather than by a second QA cycle, since the change is test-only and
alters no assertion: one module import remains (`bottom_tab_bar.dart`), zero
references to `BottomTabBarCell`/`BottomTabBarDestination`, test count still 8,
`lib/` untouched, analyzer 33, tests +312 -10. QA cycles used stays 0 — this was a
human-directed cleanup of a WARNING, not remediation of a FAIL.

Dev solved the one case the orchestrator had pre-authorised an exception for: the
whole-cell-tappable test now finds the ancestor `InkWell` (a public Flutter type)
rather than naming the internal cell, so all 10 finders converted with no carve-out.

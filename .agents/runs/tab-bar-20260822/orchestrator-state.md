# Orchestrator State
Feature: Week 2 Stage 2 item 2.4 — Tab bar
Run ID: tab-bar-20260822
Run folder: .agents/runs/tab-bar-20260822/
Started: 2026-08-22
Current phase: DEV
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 30 info (32 issues) — captured 2026-08-22
Test baseline: +304 -10 — captured 2026-08-22
Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)
Branch: claude/questloggd-stage-2-game-card-nxg2vg
Base branch: develop
Base SHA: e881cb5
Dev commit: NONE
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
NONE

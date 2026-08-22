# Orchestrator State
Feature: Week 2 Stage 2 item 2.4 — Tab bar
Run ID: tab-bar-20260822
Run folder: .agents/runs/tab-bar-20260822/
Started: 2026-08-22
Current phase: HUMAN_GATE
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
NONE

## Code review outcomes
NONE

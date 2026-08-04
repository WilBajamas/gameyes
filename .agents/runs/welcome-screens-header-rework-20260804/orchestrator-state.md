# Orchestrator State
Feature: Welcome screens header rework (item 6.1) — flat PNG header art replacing composed widgets
Run ID: welcome-screens-header-rework-20260804
Run folder: .agents/runs/welcome-screens-header-rework-20260804/
Started: 2026-08-04
Current phase: COMPLETE
Completed: 2026-08-04
Result: PASS — pending manual checks
QA cycles used: 0
Analyzer baseline: 0 errors, 2 warnings, 36 info — captured 2026-08-04T18:59:00+08:00
Test baseline: +142 -13 — captured 2026-08-04T19:02:00+08:00
Pre-existing test failures: test/api/games/games_test.dart, test/api/game_detail/game_detail_test.dart, test/cubit/games/games_bloc_test.dart (x3), test/cubit/game_detail/game_detail_cubit_test.dart (x3), test/repository/tracker/tracker_repository_test.dart (x2), test/widget/onboarding/welcome_screen_test.dart (x2 — NEW, not in the historically documented 11; see notes), test/widget_test.dart
Branch: feature/welcome-screens-header-rework
Base branch: develop
Base SHA: 9c31eec8d502c0b347a2a4ab3fe4564fcf4da854
Dev commit: 5bd84e8abb593208be32f2d50debdeee516b3d9a
Last updated: 2026-08-04T20:16:34+08:00

## Notes
Pre-run cleanup: committed CLAUDE.md and macos/Flutter/GeneratedPluginRegistrant.swift
as 9c31eec on develop (unrelated pre-existing dirt, human-approved) to get a clean
tree before branching. The three new header assets
(assets/images/welcome-1-header.png, welcome-2-header-bg.png, welcome-2-header.png)
were left uncommitted deliberately at branch-creation time — they are this run's own
input, human-approved as an exception to the clean-tree rule.

BA input is `source-request.md` in this run folder, not a fresh translation from
scratch — it explicitly supersedes criteria [W1-6.13], [W1-6.14], [W1-6.16]-[W1-6.23]
from `.agents/runs/welcome-screens-20260802/tech-ac.md`, which remains the source for
every other still-valid criterion.

## Escalation history
NONE

## Deviation approvals
[2026-08-04T20:15:00+08:00] WelcomeAssetConstants moved out of welcome_hero.dart into a new file, lib/features/onboarding/const.dart (feature-root constants file, not part of the original allowlist) — Approved by human, applied directly by human at Phase 4B, not by the Dev Agent. Docs updated: flutter-arch.md now documents a feature-root const.dart as a standing pattern.
[2026-08-04T20:15:00+08:00] Doc comments trimmed on WelcomeHero and its fields (removed dartdoc that restated field names) — Approved by human, applied directly by human at Phase 4B, not by the Dev Agent. Docs updated: project-conventions.md and execution.md now give this exact pattern as a worked bad/good example.

## Code review outcomes
[2026-08-04T20:15:00+08:00] Reviewed and approved by human, with the two deviations above applied directly by the human rather than through a Dev Agent revise round.

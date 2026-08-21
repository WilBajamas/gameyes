# Diff Summary
Source: Week 2 task briefs items 1.8, 1.9 (combined run)
Date: 2026-08-20
Branch: claude/questloggd-stage-2-resume-ikpjd6
Commit: cf6d4d81d0845453c183b67d623b0193de308df6

## Phase 4B revision round 1
Human asked for four changes, made as a new commit on top of `cf6d4d8`:
1. `lib/widgets/action_row.dart` — removed the comments.
2. `test/widget/components/action_row_test.dart` — removed the three exact-dimension/layout tests above `'calls onPressed once per tap when enabled'` (dimensions, radius/fill, mark+label sizing); also dropped the now-unused `AppTokens` import. 7 tests → 4.
3. `lib/widgets/progress_dots.dart` — removed the comments.
4. `test/widget/components/progress_dots_test.dart` — removed the four exact-dimension/layout tests (active-dot position/size, sizing, gap, content-hugging width). `AppTokens` import still used by the remaining colour test, kept. 8 tests → 4.

No coverage re-added elsewhere — per `flutter-widget-test`, this is a deliberate drop of exact-dimension/layout assertions, not a gap.

`flutter analyze`: 0 errors, 2 warnings, 31 info — same as baseline.
`flutter test`: +267 -10 (down from +274 -10, as expected: 7 tests removed). Same 10 pre-existing failures, no new failures.

Revision commit: PLACEHOLDER_SHA

## Files created
lib/widgets/progress_dots.dart — `ProgressDots` + file-private `_Dot`; caller supplies `count` and `activeIndex`, renders `count` dots (22x5 ink pill active, 5x5 ink12 rest) 6px apart, `Row(mainAxisSize: min)`.
lib/widgets/action_row.dart — `ActionRow`, the promoted full-width 52px `sm`-radius row with a 20px leading mark, centred label (pinned `ink70`, ellipsised in a `Flexible`), and an optional 16px busy indicator.
test/widget/components/progress_dots_test.dart — dot count, active-dot position/size/colour, inactive size/colour, 6px gap with no leading/trailing gap, content-hugging width, no text/tap handler, debug assertion on an out-of-range index.
test/widget/components/action_row_test.dart — 52px height/full width, `sm` radius + caller fill, 20px mark + centred label, tap-when-enabled/no-tap-when-disabled, busy indicator presence, ellipsis in a narrow parent.

## Files modified
lib/features/onboarding/presentation/widgets/welcome_container.dart — replaced the inline two-`Container` dot `Row` with `ProgressDots(count: 2, activeIndex: isFirstStep ? 0 : 1)`; nothing else touched.
lib/features/auth/presentation/screens/auth_screen.dart — dropped the `provider_action_button.dart` part and the now-unused `button_press_scale.dart` import, added the `action_row.dart` import, swapped both call sites to `ActionRow` (`assetPath:` → `markAsset:`), arguments and order unchanged.
lib/features/auth/presentation/widgets/provider_action_button.dart — deleted; both callers migrated to `ActionRow` in this run.
.claude/skills/flutter-widgets/SKILL.md — appended `ProgressDots` and `ActionRow` rows to the reusable-widget catalogue; no existing row touched.

## Test files
test/widget/components/progress_dots_test.dart — 8 tests, all passing.
test/widget/components/action_row_test.dart — 7 tests, all passing.
test/widget/onboarding/welcome_screen_test.dart — untouched, still passes (the `_countDots` helper still works because `_Dot` renders as `Container`).
test/widget/auth/auth_screen_test.dart — untouched, still passes.

## Self-corrections
NONE

## Deviations from implementation plan
NONE — plan followed exactly, matching the Phase 3 gate's approved design (ink70 label colour, `Flexible` around the label, `_SignOutButton` left out of scope).

## Verification against baseline
`flutter analyze`: 0 errors, 2 warnings, 31 info — identical to the recorded baseline, no new issues.
`flutter test`: +274 -10 (baseline +259 -10, plus 15 new smoke tests from this run, all passing). The 10 failures are exactly the three recorded pre-existing files (`test/repository/tracker/tracker_repository_test.dart` (4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3), `test/cubit/games/games_bloc_test.dart` (3)) — no new failure.

## Acceptance criteria status
1.8-AC1: satisfied
1.8-AC2: satisfied
1.8-AC3: satisfied
1.8-AC4: satisfied
1.8-AC5: satisfied
1.8-AC6: satisfied
1.8-AC7: satisfied
1.8-AC8: satisfied
1.8-AC9: satisfied
1.8-AC10: satisfied
1.8-AC11: satisfied
1.8-AC12: satisfied
1.9-AC1: satisfied
1.9-AC2: satisfied
1.9-AC3: satisfied
1.9-AC4: satisfied
1.9-AC5: satisfied — label pinned at `ink70` per the Phase 3 gate's confirmed correction, not the criterion's literal "ink"
1.9-AC6: satisfied
1.9-AC7: satisfied
1.9-AC8: satisfied
1.9-AC9: satisfied
1.9-AC10: satisfied
1.9-AC11: satisfied
1.9-AC12: satisfied
ALL-AC1: satisfied
ALL-AC2: satisfied
ALL-AC3: satisfied
ALL-AC4: satisfied
ALL-AC5: satisfied
ALL-AC6: satisfied
ALL-AC7: satisfied
ALL-AC8: satisfied

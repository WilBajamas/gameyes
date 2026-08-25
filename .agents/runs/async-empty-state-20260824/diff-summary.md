# Diff Summary
Source: `tech-ac.md` (run `async-empty-state-20260824`), AC-01–AC-28
Date: 2026-08-25
Branch: claude/async-states-empty-state-guasva
Commit: 61991141ffd10c01a0ddcdb20744bdda13599dfb

## Files created
lib/widgets/empty_state_card.dart — shared stateless empty-state card: `ClipRRect`+`ColoredBox` on `surfaceRaised` at `radius.lg`, optional glyph, caps headline, one supporting line, one required `PrimaryButton` action.

## Files modified
lib/l10n/intl_en.arb — added 11 new keys, dropped trailing arrow from `mark_something_playing`.
lib/l10n/intl_zh.arb — same 11 keys with Chinese values, dropped the same arrow.
lib/generated/l10n.dart, lib/generated/intl/messages_en.dart, lib/generated/intl/messages_zh.dart — regenerated via `intl_utils:generate` from the two `.arb` sources above.
lib/features/games/presentation/screens/games_screen.dart — `GamesStatus.empty` branch now renders `EmptyStateCard` (re-dispatching `GamesFetched`); failed branches untouched, `ErrorRetryWidget` still referenced exactly twice.
lib/features/featured/presentation/widgets/library_stats.dart — empty now-playing branch renders `EmptyStateCard`; `_DashedBorderPainter` class deleted.
lib/features/featured/presentation/widgets/critics_grid.dart — empty grid branch renders `EmptyStateCard`, action `onSkipPressed`.
lib/features/featured/presentation/widgets/countdown_releases.dart — empty weekly-releases branch renders `EmptyStateCard`, action switches to the Browse tab via `AutoTabsRouter.of(context).setActiveIndex(3)`.
lib/features/featured/presentation/screens/featured_screen.dart — silent countdown-section branch renders `EmptyStateCard` in place of `SizedBox.shrink()`, same action as above.
.claude/skills/flutter-widgets/SKILL.md — empty-state note now names `EmptyStateCard`; added its catalogue row beside `HairlineGroup`; dropped the `text: S.current.no_results_found` sample from the "Error + retry" section.

## Test files
test/widget/components/empty_state_card_test.dart — content (headline caps, supporting line, action label), the action callback firing once per tap, the optional glyph being absent when not supplied, and the card fill naming the `surfaceRaised` token.

## Self-corrections
File: test/widget/components/empty_state_card_test.dart — Error: two new `avoid_redundant_argument_values` info issues from passing `headline`/`glyph` arguments that matched `buildSubject`'s own defaults — Fix: dropped the redundant named arguments — Attempts: 1

## Deviations from implementation plan
None. `tdd.md`'s `ColoredBox` finder resolved as claimed on the first run (single match, no fallback to `byWidgetPredicate` needed). Localisation regenerated via `dart pub global activate intl_utils` then `dart pub global run intl_utils:generate`, per the generation checkpoint.

## Verification against baseline
`flutter analyze`: 0 errors, 2 warnings, 28 info (30 total) — better than the recorded baseline (0 errors, 2 warnings, 31 info / 33 total); no new issue in any file this run touches.
`flutter test`: +347 -10, matching the task brief's expected `+347` (343 baseline + 4 new tests). The 10 failures are exactly the recorded pre-existing ones: `tracker_repository_test.dart` (4), `game_detail_cubit_test.dart` (3), `games_bloc_test.dart` (3) — none new.
Falsifiability check on `empty_state_card_test.dart`: temporarily broke the fill colour and the action callback wiring in `empty_state_card.dart`, confirmed the corresponding tests failed, then reverted both — file now matches `code-plan.md` exactly.

## Acceptance criteria status
AC-01: satisfied
AC-02: satisfied
AC-03: satisfied
AC-04: satisfied
AC-05: satisfied
AC-06: satisfied
AC-07: satisfied
AC-08: satisfied
AC-09: satisfied
AC-10: satisfied
AC-11: satisfied
AC-12: satisfied
AC-13: satisfied
AC-14: satisfied
AC-15: satisfied
AC-16: satisfied
AC-17: satisfied
AC-18: satisfied
AC-19: satisfied
AC-20: satisfied
AC-21: satisfied
AC-22: satisfied
AC-23: satisfied
AC-24: satisfied
AC-25: satisfied
AC-26: satisfied
AC-27: satisfied
AC-28: satisfied

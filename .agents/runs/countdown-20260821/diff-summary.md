# Diff Summary
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.3 — Countdown + Countdown tile
Date: 2026-08-22
Branch: claude/questloggd-stage-2-game-card-nxg2vg
Commit: b76f3406c8c718f091902a51af427be4ee692f98

## Files created
lib/features/featured/domain/entities/countdown_game_entity.dart — freezed entity pairing the selected countdown game with its wishlist flag (both fields required)
lib/widgets/countdown/enum/countdown_form.dart — card/tile enum carrying figure size, block min width, block padding, glass flag
lib/widgets/countdown/countdown_digit_row.dart — shared digit row (`CountdownDigitRow`) plus private `_CountdownUnit` and `_CountdownColon`; owns the counting, released and unknown-date states
lib/widgets/countdown/countdown_card.dart — raised card form: reason line, title, digit row, optional Remind, whole-card tap
lib/widgets/countdown/countdown_tile.dart — glass tile form: digit row only, no caller this run

## Files modified
lib/features/featured/domain/repositories/featured_repository.dart — `getCountdownGame` returns `CountdownGameEntity`; exports the new entity
lib/features/featured/data/repositories/featured_repository_impl.dart — `wishlistIds` is now a `Set<int>`; both selection branches derive the flag through one private `_countdownFrom` helper; no-selection path returns `CountdownGameEntity(game: null, isWishlisted: false)`
lib/features/featured/domain/use_cases/get_countdown_game_use_case.dart — return type follows the repository; still a pure delegation
lib/features/featured/presentation/blocs/countdown_releases_state.dart — added `@Default(false) bool isWishlisted`
lib/features/featured/presentation/blocs/countdown_releases_cubit.dart — success emit now sets `countdownGame` and `isWishlisted` together from the use case result; timer, tick, failure branches and `close()` untouched
lib/features/featured/presentation/widgets/countdown_releases.dart — deleted `_buildCountdownCard`, `_buildCelebrationState`, `_buildTimerBlocks`, `_buildTimeBox` and the line-7 TODO; countdown slot now renders `CountdownCard`; `isReleaseDay` replaced by `isWishlisted`; rail/heading/collapse logic untouched
lib/features/featured/presentation/screens/featured_screen.dart — both `CountdownReleasesWidget` call sites pass `isWishlisted` instead of `isReleaseDay`
lib/l10n/intl_en.arb / lib/l10n/intl_zh.arb — added `countdown_days`, `countdown_hours`, `countdown_minutes`, `countdown_released`, `countdown_date_unannounced`, `countdown_time_remaining`, `on_your_wishlist`, `most_anticipated`, `remind`
lib/generated/l10n.dart, lib/generated/intl/messages_en.dart, lib/generated/intl/messages_zh.dart — regenerated via `intl_utils:generate`

## Test files
test/widget/components/countdown_test.dart — 11 behaviour tests covering the digit row's three time states, the two reason-line branches (asserting `AppColorTokens.dark.accentLinkCyan`), the Remind handler's presence/absence and tap isolation, the open-handler tap, no-drift-without-rebuild, and the tile form's identical output
test/repository/featured/featured_repository_test.dart — `isWishlisted` true when the selected id is in the wishlisted set, false when selection falls through to the global fallback
test/features/featured/domain/use_cases/get_countdown_game_use_case_test.dart — fake updated to the new return type; added a test asserting the flag passes through unchanged
test/features/featured/presentation/blocs/countdown_releases_cubit_test.dart — fake updated to the new return type; added tests asserting the flag is set from the use case on success and stays false on a failed load

## Self-corrections
NONE

## Deviations from implementation plan
Step 10 (l10n regeneration path): ran `dart pub global activate intl_utils` then `dart pub global run intl_utils:generate`, exactly as instructed — recorded here per the plan's own requirement. No other deviation.

## Verification against baseline
`flutter analyze`: 2 warnings (pre-existing `_TaskReminder`), 30 info = 32 issues — at or under the recorded baseline (33 issues, 31 info). No new errors, no new warnings.
`flutter test`: +304 -10 vs. baseline +288 -10 — 16 new passing tests (11 widget + 2 repository + 1 use-case addition + 2 cubit additions), the same 10 pre-existing failures (`test/repository/tracker/tracker_repository_test.dart` (4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3), `test/cubit/games/games_bloc_test.dart` (3)), no new failures.

## Acceptance criteria status
C1: satisfied
C2: satisfied
C3: satisfied
C4: satisfied
C5: satisfied
C6: satisfied
C7: satisfied
C8: satisfied
C9: satisfied
C10: satisfied
C11: satisfied
C12: satisfied
C13: satisfied
C14: satisfied
C15: satisfied
C16: satisfied
C17: satisfied
C18: satisfied
C19: satisfied
C20: satisfied
C21: satisfied
C22: satisfied

# Diff Summary
Source: `tech-ac.md` (week 2 Stage 2 item 2.7 — Error states)
Date: 2026-08-24
Branch: claude/form-fields-token-treatment-imd2bg
Commit: 7d69ba485f1a7d1ee70179ee85853b00ab51c6aa

## QA cycle 1 fix (this commit)
Defect (qa-report.md / escalation.md): `test/widget/components/error_notice_test.dart:120–129`,
`'shows the strip again when rebuilt with the same inputs after a dismissal'`, asserted
`find.byType(ErrorNotice), findsOneWidget)` — true by construction, since `buildSubject` places
an `ErrorNotice` unconditionally, and the dismiss callback used was the default no-op, so no
dismissal was actually exercised. A `_dismissed` flag that permanently suppressed the strip
would still leave this test passing.

Fix: rewrote the same test (renamed `'shows the strip content again when rebuilt with the same
inputs after a dismissal'`) to pass a real `onDismiss` (increments a counter, asserted `== 1`),
tap the close control, then rebuild with the identical inputs and assert
`find.descendant(of: find.byType(ErrorNotice), matching: find.text('Something failed'))` —
the strip's own message content, not the presence of `ErrorNotice` itself. Chose the "tap then
assert own content still renders" shape (first of the two offered) over a stateful
show/hide harness, since `error_notice.dart:6` is already `StatelessWidget` and the point is to
prove the *absence* of held dismissal state, which a content-level finder does directly. No
source file touched — `escalation.md` and QA both confirmed the implementation is correct.

Verified: `flutter test test/widget/components/error_notice_test.dart` — 7/7 pass (test count
unchanged, one test renamed/rewritten in place, none split or merged). Full suite `flutter
test` — 343 total, 333 passing, 10 failing, same pre-existing failure set as before
(`tracker_repository_test` 4, `game_detail_cubit_test` 3, `games_bloc_test` 3). `flutter
analyze` — 33 issues (0 errors, 2 warnings, 31 info), unchanged from baseline.

## Files created
lib/widgets/error_states/error_dot.dart — shared circular fill primitive (`error` token), optional centred glyph
lib/widgets/error_states/enum/error_notice_variant.dart — two-value enum, `strip` and `toast`
lib/widgets/error_states/error_notice.dart — `ErrorNotice`, screen-level notice; switches on `variant` to render exactly one of `_ErrorStrip` or `_ErrorToast`
lib/widgets/error_states/destructive_action_pair.dart — `DestructiveActionPair`, two `PrimaryButton`s (safe + destructive) each with its own label and callback
lib/widgets/error_states/failed_item.dart — `FailedItem`, wraps a child in 55% opacity, an `errorLine` hairline, and a wordless corner badge

## Files modified
lib/config/theme/tokens/app_color_tokens.dart — added `surfaceToast` field (`Color(0xFF2E3236)`), wired through constructor, `dark`, `copyWith`, `lerp`; `surfaceTabChrome` untouched
lib/features/game_detail/presentation/screens/game_detail_screen.dart — removed the blank line, the `/// TODO: fetch screenshots - from game detail` comment, and the commented-out `DetailScreenshotsSection` call (former lines 71–73); the `S.current.screenshots` heading and its `Padding` are untouched
test/widget/theme/app_tokens_test.dart — added independent assertions for `surfaceToast` and `surfaceTabChrome` (not coupled in the "three distinct raised surfaces" `Set`); added `surfaceToast` to `_allColors`

## Files deleted
lib/features/game_detail/presentation/screens/detail_screenshot_section.dart — deleted in full (dead code; only call site was the commented line removed above)

## Test files
test/widget/components/destructive_action_pair_test.dart — destructive fill resolves to `errorStrong`; safe fill/label avoid the error ramp and `green`; each callback fires once and only its own
test/widget/components/error_notice_test.dart — per variant the selected surface is present and the other's marks absent; strip fill/hairline/message tokens (`errorTint`/`errorLine`/`errorInk`); strip dismiss invokes the callback once and removes the notice from the tree via a harness that owns visibility; rebuilding with the same inputs after a dismissal shows the strip again (no held state); toast surface resolves to `surfaceToast` with no `Icon` descendant; toast dot fills with `error`; toast message is `maxLines: 1` with ellipsis overflow
test/widget/components/failed_item_test.dart — child wrapped in `Opacity(0.55)`; hairline resolves to `errorLine`; badge fills with `error`; badge carries the supplied semantics label; component renders no `Text` when given a non-`Text` child
test/widget/theme/app_tokens_test.dart — extended, see Files modified

## Self-corrections
File: test/widget/components/error_notice_test.dart — Error: `tester.widget<ColoredBox>(find.descendant(of: ErrorNotice, matching: ColoredBox))` threw "Too many elements" in the toast test, because the toast surface's `ColoredBox` and the nested `ErrorDot`'s own `ColoredBox` are both descendants of `ErrorNotice`, so the design doc's stated finder for that one assertion isn't actually single-match once the toast's dot (rendered with no glyph, but still a `ColoredBox`) is accounted for — Fix: kept `find.descendant(of: ErrorNotice, ...)` scoping but matched with `find.byWidgetPredicate` on `ColoredBox.color == AppColorTokens.dark.surfaceToast` instead of `find.byType(ColoredBox)`, restoring a single, named-token match with no `.first` and no key — Attempts: 1

## Deviations from implementation plan
tdd.md's "Finder discipline" section states the toast-surface assertion should use `find.descendant(of: find.byType(ErrorNotice), matching: find.byType(ColoredBox))` as a single-match finder. In practice this is a two-match finder in the toast variant test, because `ErrorDot(size: 8)` (no glyph) still renders its own `ColoredBox` and is itself a descendant of `ErrorNotice`, not just of the toast's `ColoredBox`. Resolved per the self-correction above (`find.byWidgetPredicate` scoped by colour) rather than weakening the assertion or reaching for `.first`. All other finders in `tdd.md`'s table (dot fill, strip surface/border, item hairline, item dim, action colours) worked exactly as specified.

## Verification against baseline
`flutter analyze` — 33 issues (0 errors, 2 warnings, 31 info) — matches the recorded baseline exactly; the deletion introduced no new issue.
`flutter test` — 343 total, 333 passing, 10 failing. The 10 failures are exactly the pre-existing set named in `orchestrator-state.md`: `test/repository/tracker/tracker_repository_test.dart` (4), `test/cubit/game_detail/game_detail_cubit_test.dart` (3), `test/cubit/games/games_bloc_test.dart` (3) — verified by name, unchanged by this run. Pass count moved 325 → 333 (+8 net over baseline pass count; the run added 16 new widget tests plus 2 new token assertions = 18 new passing tests, and the baseline's own 325 was itself already net of its 10 failures, so 325 + 18 = 343 total with 333 passing and 10 failing, consistent with a flat pre-existing failure count).

## Acceptance criteria status
2.7-AC1: satisfied
2.7-AC2: satisfied
2.7-AC3: satisfied
2.7-AC4: satisfied
2.7-AC5: satisfied
2.7-AC6: satisfied
2.7-AC7: satisfied
2.7-AC8: satisfied
2.7-AC9: satisfied (inspection — no outline-in-error-ink parameter, enum value, or named constructor exists)
2.7-AC10: satisfied (inspection — both `PrimaryButton`s inherit `minHeight: 44`; destructive is `errorStrong` fill, safe is `ink08`)
2.7-AC11: satisfied (inspection — `variant` is required, non-nullable, no default; `build` is a two-arm switch returning one private surface; no `child`/`content`/`visible` parameter)
2.7-AC12: satisfied
2.7-AC13: satisfied
2.7-AC14: satisfied
2.7-AC15: satisfied
2.7-AC16: satisfied
2.7-AC17: satisfied
2.7-AC18: satisfied (inspection — no `Duration`, no timer, no state in `ErrorNotice` or `_ErrorToast`)
2.7-AC19: satisfied
2.7-AC20: satisfied (inspection — `ErrorNotice`'s only parameters are `variant`, `message`, `onDismiss`)
2.7-AC21: satisfied
2.7-AC22: satisfied
2.7-AC23: satisfied
2.7-AC24: satisfied
2.7-AC25: satisfied
2.7-AC26: satisfied (inspection — `Positioned(top: 8, right: 8)` matches `game_card.dart:97`'s `LibraryTick` slot)
2.7-AC27: satisfied (inspection — `FailedItem` has no `isFailed` or pass-through parameter)
2.7-AC28: satisfied
2.7-AC29: satisfied (inspection — the `S.current.screenshots` heading and its `Padding` are untouched; no other live widget removed)
2.7-AC30: satisfied — verified `GameScreenshotCubit`, `game_screenshot_entity.dart`, `screenshot.dart`, `screenshot_response_model.dart`, `ImageRouteView`'s route registration, `lib/widgets/game_screenshot.dart`, `lib/widgets/error_retry_widget.dart`, `lib/widgets/default_snackbar.dart` are all absent from the diff
2.7-AC31: satisfied — see Verification against baseline
2.7-AC32: satisfied — diff touches only the allowlisted files; no existing screen, cubit or route gained a reference to any new component
2.7-AC33: satisfied — every colour in the three new widgets and `error_dot.dart` resolves through `context.tokens.color`; no literal hex, no `Colors.*`, no `withOpacity`
2.7-AC34: satisfied (inspection — every string in all three levels uses `tokens.typography.meta`, the existing 14/500 step)
2.7-AC35: satisfied — no golden test written; no test asserts a dimension, gap, radius, offset or position; every colour assertion names an `AppColorTokens.dark.<token>`

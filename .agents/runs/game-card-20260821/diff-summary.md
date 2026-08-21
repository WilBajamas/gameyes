# Diff Summary
Source: `.agents/runs/game-card-20260821/tech-ac.md` — week 2 Stage 2 item 2.1, Game card
Date: 2026-08-21
Branch: claude/questloggd-stage-2-game-card-nxg2vg
Commit: 26b5951843162462cb2498d5bd9d5646819475e6

## Files created
lib/widgets/game_card/game_card.dart — `GameCard`, module entry point; private `_CardCover`, `_CoverArt`, `_MissingArt`
lib/widgets/game_card/game_card_size.dart — `GameCardSize` enum (xs/sm/md) and `coverAspectRatio`
lib/widgets/game_card/game_card_footer.dart — `GameCardFooter`, per-size footer switch
lib/widgets/game_card/game_card_small_footer.dart — `GameCardSmallFooter`
lib/widgets/game_card/game_card_medium_footer.dart — `GameCardMediumFooter`
lib/widgets/game_card/game_card_placeholder_bar.dart — `GameCardPlaceholderBar`, shared by both footers
lib/widgets/library_tick.dart — `LibraryTick`, app-wide 20px indigo tick, no parameters
lib/widgets/critic_badge.dart — `CriticBadge`, app-wide green score pill, `score` only parameter

## Files modified
lib/core/res/const.dart — added `GamesGridConstants` (gutter, column count, column-width derivation)
lib/features/games/presentation/screens/games_screen.dart — `GamesSliverGrid` rewired to `GameCard` at `md`, derived `mainAxisExtent` via `SliverLayoutBuilder` instead of `childAspectRatio`
lib/widgets/game_item_grid_loading_shimmer.dart — rewired to dataless `GameCard` at `md`, same derived cell geometry as the live grid
lib/widgets/game_item_loading_shimmer.dart — rewired to dataless `GameCard` at `sm` in a height-bounded horizontal list
lib/widgets/game_item.dart — added `@Deprecated` pointing at `GameCard`; body unchanged
lib/l10n/intl_en.arb / lib/l10n/intl_zh.arb — added `add_to_library` key
lib/generated/l10n.dart, lib/generated/intl/messages_en.dart, lib/generated/intl/messages_zh.dart — regenerated via `dart pub global run intl_utils:generate`
.claude/skills/flutter-widgets/SKILL.md — catalogue rows only: added `GameCard`, `LibraryTick`, `CriticBadge`; marked `GameItem` deprecated; re-described both shimmer rows

## Test files
test/mocks/game_mock.dart — added `mockGameEntity` getter (`GameEntity` with cover, two platforms, one release date) for widget tests to `copyWith` from
test/widget/components/game_card_test.dart — 10 tests: missing-art fallback, overlay presence/absence together, size anatomies (xs/sm/md), add-vs-tap isolation, tap invocation, exact hero tag string, no-hero for dataless cards
test/widget/components/critic_badge_test.dart — 2 tests: rounded whole-number score, sanctioned green token
test/widget/games/games_screen_test.dart — 3 tests: card-per-game with no status/tick, no overflow at narrow/wide surfaces, unchanged `GameDetailRoute` payload on tap
test/widget/components/game_card_shimmers_test.dart — 2 tests: both shimmers render their cells without throwing
Generated: test/widget/games/games_screen_test.mocks.dart (`@GenerateMocks([GamesBloc, StackRouter])`)

## Self-corrections
File: test/widget/components/game_card_test.dart — Error: `md`-size card overflowed a RenderFlex when pumped directly in an unbounded `Scaffold` body (800×600 test surface gives it unbounded width, so the 3:4 cover derives a height taller than the surface) — Fix: wrapped the pumped card in a `SizedBox(width: size.width)` in the test harness so it gets the same bounded width a real caller (grid cell, shimmer list) always supplies — Attempts: 1
File: test/mocks/game_mock.dart — Error: `avoid_redundant_argument_values` info on `DateTime(2025, 1, 1)` (day 1 is `DateTime`'s default) — Fix: `DateTime(2025)` — Attempts: 1
File: test/widget/games/games_screen_test.dart — Error: `route.args` is nullable on `PageRouteInfo`, `unchecked_use_of_nullable_value` — Fix: `route.args!.gameExtra` — Attempts: 1
File: test/widget/games/games_screen_test.dart — Error: `MissingDummyValueError: GamesState` from Mockito when stubbing `bloc.state` — Fix: `provideDummy<GamesState>(const GamesState())` in `setUpAll` — Attempts: 1
File: test/widget/games/games_screen_test.dart — Error: first test found only 2 of 5 `GameCard`s — the grid's `SliverGrid.builder` only builds cards inside the default 800×600 test viewport, and the `md` cell is tall enough that only the first row is visible — Fix: set `tester.view.physicalSize` to a tall surface for that one test so all 5 build — Attempts: 1

## Deviations from implementation plan
None — all 19 steps were followed as written, including the D1–D4 delta (multi-file module, `LibraryTick`/`CriticBadge` promoted to `lib/widgets/`, the 10-test card file, and the six-row catalogue edit). L10n was regenerated via the CLI (`dart pub global run intl_utils:generate`), the sanctioned path, not left for a human IDE pass.

Step 13's `color.green` search found a third hit beyond `critic_badge.dart` and the theme's focus ring (`button_press_scale.dart`): `lib/widgets/primary_button.dart:29` also defaults to `tokens.color.green`. This is pre-existing code outside this run's allowlist — not introduced by this change — so it is not fixed here; flagging it for the human/QA as a candidate follow-up rather than treating it as an in-scope defect.

## Verification against baseline
`flutter analyze`: 0 errors, 2 warnings, 31 info — identical to the recorded baseline (`0 errors, 2 warnings, 31 info`). No new diagnostic anywhere, including no `deprecated_member_use` for `GameItem` (confirms R7 — no remaining callers).
`flutter test`: 284 total, 274 passing, 10 failing. The 10 failures are exactly the recorded pre-existing set (`test/repository/tracker/tracker_repository_test.dart` ×4, `test/cubit/game_detail/game_detail_cubit_test.dart` ×3, `test/cubit/games/games_bloc_test.dart` ×3) — unchanged from baseline. 284 = 267 baseline total + 17 new tests added by this run, all passing.

## Acceptance criteria status
2.1-C1: satisfied — three sizes, one anatomy; widths verified by construction, manual device check owed for the three widths themselves
2.1-C2: satisfied as designed — wash only, no desaturation filter, per the resolved OQ-1 human decision; the spec's desaturation clause ships deliberately unmet
2.1-C3: satisfied
2.1-C4: satisfied
2.1-C5: satisfied
2.1-C6: satisfied
2.1-C7: satisfied
2.1-C8: satisfied
2.1-C9: satisfied
2.1-C10: satisfied
2.1-C11: satisfied
2.1-C12: satisfied — not test-verified per the D3 test-plan trim (`sm`/`md` long-title and over-cap platform list are QA's manual device check)
2.1-C13: satisfied — "no callback, no ripple when none supplied" half is untested per D3 (InkWell's own behaviour, not this widget's)
2.1-C14: satisfied
2.1-C15: satisfied
2.1-R1: satisfied
2.1-R2: satisfied
2.1-R3: satisfied
2.1-R4: not test-verified — manual device check per plan, C14 is the automated part of the contract
2.1-R5: satisfied
2.1-R6: satisfied
2.1-R7: satisfied — repo search confirms no remaining `GameItem` references outside its own file
2.1-R8: satisfied

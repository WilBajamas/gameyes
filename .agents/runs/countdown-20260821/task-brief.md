# Task Brief
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.3 — Countdown + Countdown tile
Date: 2026-08-21

## Context

Ship the countdown as a two-form component-library module, rewire `featured`'s countdown
section onto it, and thread a genuine wishlist boolean from the repository to the card so
the reason line stops asserting a wishlist entry the user may not have.

## Testing mode

`smoke` — Rule applied: UI-focused change with one boolean threaded through existing
paths. Justification: no `coverage` trigger fires — this is not auth or authorisation,
not payments, not persistence or offline sync, and the new widgets are not a shared
utility with three or more consumers (the card has one caller, the tile none). The data
change adds no read, no write and no storage. Concretely, smoke here means: one widget
test file for the module, one small repository test protecting the flag's truth
condition, and in-place updates to the two existing unit tests the signature change
breaks. No golden tests, ever.

Per `flutter-widget-test`, which widgets get a dedicated test file:
- `CountdownCard` and `CountdownTile` — **yes**, one shared file
  (`test/widget/components/countdown_test.dart`, the `stat_pill_test.dart` precedent of
  two forms in one file). They own three time states, two reason-line branches, two
  handlers and a snapshot contract — all observable, all regressable.
- `CountdownDigitRow`, `_CountdownUnit`, `CountdownForm` — **no**. Module-internal;
  every behaviour they own is exercised through the two public widgets, and testing them
  directly would pin implementation structure.
- `CountdownReleasesWidget` / `FeaturedScreen` — **no**. No new behaviour of their own;
  the rewire forwards state into a tested component, and the section has no test today.
  C17/C18 are QA's manual check.

Test plan for `countdown_test.dart` — eleven tests, derived from behaviour clusters, not
one per criterion:
1. three zero-padded groups, `DAYS`/`HRS`/`MIN` labels and two colons for a supplied duration
2. released label and no digits when the duration has run out
3. the caller's release-date text when no duration is given
4. the unannounced-date label when neither duration nor date is given
5. the cyan wishlist reason line when the game is wishlisted
6. the neutral reason line, and no cyan, when it is not
7. no Remind action when no handler is supplied
8. the open handler fires once on a card tap
9. a Remind tap fires the Remind handler and does not open the game
10. digits unchanged after time elapses without a rebuild (also proves no pending timer)
11. the tile form renders the same three groups and two colons

Eleven is one above the repo's current largest component file, which is proportionate for
a component with three time states, two reason branches, two handlers and two forms —
and the number was reached by cutting, not by enumerating criteria. Assert no dimension,
gap, radius, offset or position; the only colour assertions are 5 and 6, and both must
name the token (`accentLinkCyan`) because the cyan carries the wishlist meaning.

## File allowlist

### CREATE NEW
lib/features/featured/domain/entities/countdown_game_entity.dart — freezed entity pairing the selected countdown game with its wishlist flag
lib/widgets/countdown/enum/countdown_form.dart — the card/tile axis: figure size, block min width, block padding, glass flag
lib/widgets/countdown/countdown_digit_row.dart — the shared digit row and its private unit block; owns the counting, released and unknown-date states
lib/widgets/countdown/countdown_card.dart — raised card form: reason line, title, digit row, optional Remind, whole-card tap
lib/widgets/countdown/countdown_tile.dart — glass hero form: the digit row only

### MODIFY EXISTING
lib/features/featured/domain/repositories/featured_repository.dart — `getCountdownGame` returns `CountdownGameEntity`; export the new entity
lib/features/featured/data/repositories/featured_repository_impl.dart — `getCountdownGame` only: wishlist ids to a `Set`, flag derived in one private helper used by both branches
lib/features/featured/domain/use_cases/get_countdown_game_use_case.dart — return type follows the repository; still a pure delegation
lib/features/featured/presentation/blocs/countdown_releases_state.dart — add `@Default(false) bool isWishlisted`
lib/features/featured/presentation/blocs/countdown_releases_cubit.dart — success emit sets game and flag together; timer, tick, failure branches and `close()` untouched
lib/features/featured/presentation/widgets/countdown_releases.dart — render `CountdownCard`, delete the four inline builders and the TODO, swap `isReleaseDay` for `isWishlisted`
lib/features/featured/presentation/screens/featured_screen.dart — pass `isWishlisted` at both call sites, drop `isReleaseDay`
lib/l10n/intl_en.arb — new countdown keys
lib/l10n/intl_zh.arb — the same keys, translated

### TEST FILES
test/widget/components/countdown_test.dart — the eleven behaviours above
test/repository/featured/featured_repository_test.dart — flag true when the selected game's id is in the wishlisted set, false when selection fell through to the global fallback
test/features/featured/domain/use_cases/get_countdown_game_use_case_test.dart — update the fake to the new return type; assert the flag passes through unchanged
test/features/featured/presentation/blocs/countdown_releases_cubit_test.dart — update the fake; assert the flag is set from the use case on success, defaults false, and is not raised on the failure path

## Implementation plan

Step 1: Create `lib/features/featured/domain/entities/countdown_game_entity.dart` — freezed, `required GameEntity? game`, `required bool isWishlisted`.
Step 2: Add `@Default(false) bool isWishlisted` to `countdown_releases_state.dart`.
Step 3: Run `dart run build_runner build --delete-conflicting-outputs`.
Step 4: Change `getCountdownGame`'s return type in `featured_repository.dart` and export the new entity there.
Step 5: Update `getCountdownGame` in `featured_repository_impl.dart` — `wishlistIds` to a `Set<int>`, add the private `_countdownFrom(game, wishlistIds)` helper, return it from both the wishlist branch and the fallback branch, return `const CountdownGameEntity(game: null, isWishlisted: false)` when nothing is selected, leave the `catch` branch and both queries alone.
Step 6: Update `get_countdown_game_use_case.dart`'s return type; body stays a single delegation.
Step 7: Update `countdown_releases_cubit.dart`'s success branch so one `copyWith` sets `countdownGame` and `isWishlisted` together. Do not touch `_startTimer`, `_updateCountdown`, `_getReleaseDate`, the failure branches or `close()`.
Step 8: Add the new keys to `lib/l10n/intl_en.arb`: `countdown_days`, `countdown_hours`, `countdown_minutes`, `countdown_time_remaining` (three placeholders), `countdown_released`, `countdown_date_unannounced`, `on_your_wishlist`, `most_anticipated`, `remind`. Values per `code-plan.md`. No emoji, no exclamation mark, caps labels carry no terminal period.
Step 9: Add the same keys to `lib/l10n/intl_zh.arb` with translations matching the file's existing register.
Step 10: Run `dart pub global activate intl_utils` then `dart pub global run intl_utils:generate` to regenerate `S`. Never run `flutter gen-l10n`. Record which path was taken under `diff-summary.md ## Deviations from implementation plan`.
Step 11: Create `lib/widgets/countdown/enum/countdown_form.dart`.
Step 12: Create `lib/widgets/countdown/countdown_digit_row.dart` with its private unit block.
Step 13: Create `lib/widgets/countdown/countdown_card.dart`.
Step 14: Create `lib/widgets/countdown/countdown_tile.dart`.
Step 15: Rework `lib/features/featured/presentation/widgets/countdown_releases.dart` — delete `_buildCountdownCard`, `_buildCelebrationState`, `_buildTimerBlocks`, `_buildTimeBox` and the line-7 TODO, render `CountdownCard`, replace the `isReleaseDay` field with `isWishlisted`, leave `_buildReleasesList` and the headings as they are.
Step 16: Update both `CountdownReleasesWidget` call sites in `featured_screen.dart`.
Step 17: Update `test/features/featured/domain/use_cases/get_countdown_game_use_case_test.dart`.
Step 18: Update `test/features/featured/presentation/blocs/countdown_releases_cubit_test.dart`.
Step 19: Create `test/repository/featured/featured_repository_test.dart` with `@GenerateMocks([FeaturedLocalDatasource, FeaturedApiService])`.
Step 20: Run `dart run build_runner build --delete-conflicting-outputs` to generate the new mocks.
Step 21: Create `test/widget/components/countdown_test.dart`.
Step 22 (final): Run `flutter analyze` and `flutter test`. Compare against `orchestrator-state.md`, quoted verbatim: `Analyzer baseline: 0 errors, 2 warnings, 31 info (33 issues) — captured 2026-08-21` and `Test baseline: +288 -10 — captured 2026-08-21`, with `Pre-existing test failures: test/repository/tracker/tracker_repository_test.dart (4), test/cubit/game_detail/game_detail_cubit_test.dart (3), test/cubit/games/games_bloc_test.dart (3)`. Only a new, in-scope regression is yours to fix.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: C1–C22

## Constraints

- **Widget files carry no comments at all** — not a header, not a `///`, not a note above
  a token lookup. The file being reworked has them today; that is the old convention.
- Every class in `lib/widgets/countdown/` is a `StatelessWidget`. No `Timer`, `Ticker`,
  `AnimationController` or implicitly-animated widget anywhere in the module — that is
  what makes C3 provable. Do not reuse `ButtonPressScale`; use
  `GestureDetector(behavior: HitTestBehavior.opaque)` for both taps.
- Colours, radii, type: `context.tokens` only, never `Theme.of(context)`, never a raw
  Material colour, never an inline hex. Do not add a field to `AppColorTokens` or
  `AppTypeTokens` — use `copyWith` on the existing token where a step differs.
- All user-facing strings via `S.current.[key]`, added to both `.arb` files.
- Dimensions are even numbers. §3.2's `5px` block padding rounds to `6`.
- Outlines are solid; the module draws no border at all. Icons are outline-only
  (Material's `*_outline` / `*_border` set), never filled.
- A reusable widget adds no spacing around itself and takes no padding parameter;
  interior padding of a surface it draws is fine.
- Prefer `Expanded` over `Flexible`, except the digit row, which hugs its content with
  `MainAxisSize.min` — the sanctioned exception, already flagged in `tdd.md`.
- `getOutThisWeekUseCase`, the 60-second tick interval, `_updateCountdown`'s two-field
  `copyWith` calls, the failure branches and `close()`'s cancellation must come out of
  this run byte-identical.
- Test conventions: `@GenerateMocks` before `void main()`, `provideDummy<Result<T>>` in
  `setUp` for every `Future<Result<T>>` mock, `GetIt.instance.reset()` in `tearDown`.
  Widget tests assert no dimension, gap, radius, offset or position, and any colour
  assertion names its token. Never `matchesGoldenFile`.
- Do not relocate the two existing `test/features/featured/**` unit tests.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist —
escalate instead.

# Task Brief
Source: `.agents/runs/game-card-20260821/tech-ac.md` — week 2 Stage 2 item 2.1, Game card
Date: 2026-08-21
Revised: 2026-08-21 at the Phase 3 gate — see `code-plan.md ## Approved feedback delta`
(D1 card module folder, D2 promoted overlays, D3 trimmed test plan, D4 allowlist).

## Context

Build the spec's one-anatomy, three-size game card and move the games grid and both
game shimmers onto it, so a single card anatomy survives this week instead of two.

## Testing mode

`smoke` — Rule applied: UI-only with no new logic, isolated with no shared dependencies.
Justification: no auth, payment, persistence or sync is touched; nothing below the
presentation layer changes. Tests exist to protect conditional content, interaction, the
hero-tag string and the grid's navigation payload — not appearance.

**Dedicated test files, decided per widget against the `flutter-widget-test` skill:**

- `GameCard` — **yes**, 10 tests. It owns conditional content (three overlays, two footer
  shapes, the missing-art fallback), two interactions, and one explicit public contract,
  the hero tag. Ten, not one per `Verify:` line: independent presence/absence conditions
  are asserted together in one pump each, since they fail on the same regressions with a
  fraction of the setup. The exact list is in the delta (D3) and in `code-plan.md`. Two of
  them are non-negotiable and must be written as specified — the exact hero-tag string
  (C14) and the dataless-card-registers-no-`Hero` case (C15). Those are the silent-failure
  paths and the reason the file exists.
- `CriticBadge` — **yes**, 2 tests. It owns a user-visible transformation (a fractional
  score rendered as a whole number) and the run's one permitted colour assertion: the
  sanctioned green, named by token, protecting "the badge is one colour" against a
  re-invented score ramp.
- `LibraryTick` — **no**. Zero parameters, no conditional content, no interaction. A
  passive fixed glyph does not earn a file; its only meaningful behaviour (present when
  and only when the caller says in-library) is the card's and is asserted in the card's
  file.
- `GameCardFooter`, `GameCardSmallFooter`, `GameCardMediumFooter`,
  `GameCardPlaceholderBar` — **no**. Public only because the module spans files; they are
  internal composition with no caller outside `lib/widgets/game_card/`, and every
  behaviour they carry is asserted through `GameCard`.
- `GamesSliverGrid` — **yes**. State-driven content plus navigation with a payload that
  nothing else protects (R1, R2, R3). Three tests.
- `GameItemGridLoadingShimmer` and `GameItemLoadingShimmer` — **one shared file, one test
  each** (R5, R6). Individually each is a passive wrapper that would not earn a file;
  together they are the only place the dataless card is rendered many-at-once, which is
  the failure R5 and R6 name.
- `GameItem` — **no**. Behaviour unchanged, being retired, and it has never had a test.

**Run total: 17 tests across 4 files.** A file that grows past its stated count is a
signal to cut, not to keep going.

**Not tested, verified on device instead** (hand to QA, do not write a test for either):
- C12 — a long title and an over-cap platform list produce no overflow stripe at each
  size that has a footer. `md` is already exercised in real cell geometry by the grid
  test's narrow and wide surfaces; `sm` only ever renders dataless today.
- Everything already marked `manual device check` in `tech-ac.md` — C1's three widths,
  C2's cover treatment, R2's grid appearance, R4's hero transition, R5's skeleton shape.

**Binding test rules for every file above** (`flutter-widget-test`, revised four times —
read it in full, do not pattern-match off older test files in this repo, including
`cover_tile_test.dart`, whose first test predates the current rule):
- No assertion on a dimension, gap, radius, offset or position — ever, including the
  numbers named in C1, C2 and R2.
- No golden test, no `matchesGoldenFile`.
- Exactly one colour assertion is permitted in the whole run — the critic badge's green —
  and it lives in `critic_badge_test.dart`, the file of the widget that owns the colour,
  and must name the token (`AppColorTokens`/`context.tokens.color.green`), never a hex
  literal.
- No fake image bytes, no `Completer`, no manual invocation of `imageBuilder` /
  `errorWidget`, no zones, no arbitrary delays. `PlatformRowList` uses a bare
  `Image.network`: assert the row's presence and its inputs, never a loaded image.
- Do not pre-resolve the theme or tokens in `setUpAll` (handover gotcha #10); pass
  `buildDarkTheme()` into the pumped widget as `context_chip_test.dart` does.

## File allowlist

### CREATE NEW

The card is a multi-file module in its own folder. Only `GameCard` and `GameCardSize` are
public surface — nothing outside `lib/widgets/game_card/` imports the other four classes.

`lib/widgets/game_card/game_card.dart` — `GameCard`, plus its still-file-private
`_CardCover`, `_CoverArt` and `_MissingArt`.
`lib/widgets/game_card/game_card_size.dart` — `GameCardSize` and `coverAspectRatio`.
`lib/widgets/game_card/game_card_footer.dart` — `GameCardFooter`, the per-size switch.
`lib/widgets/game_card/game_card_small_footer.dart` — `GameCardSmallFooter`.
`lib/widgets/game_card/game_card_medium_footer.dart` — `GameCardMediumFooter`.
`lib/widgets/game_card/game_card_placeholder_bar.dart` — `GameCardPlaceholderBar`, shared
by both footers.
`lib/widgets/library_tick.dart` — `LibraryTick`, app-wide, no parameters.
`lib/widgets/critic_badge.dart` — `CriticBadge`, app-wide, `score` its only parameter.

### MODIFY EXISTING
`lib/core/res/const.dart` — add `GamesGridConstants` (gutter, column count, and the
column-width derivation shared by the games grid and the grid shimmer).
`lib/features/games/presentation/screens/games_screen.dart` — `GamesSliverGrid` renders
`GameCard` at `md`; delegate drops `childAspectRatio` for a derived `mainAxisExtent`.
`lib/widgets/game_item_grid_loading_shimmer.dart` — dataless `GameCard` at `md`, same
derived cell geometry as the live grid.
`lib/widgets/game_item_loading_shimmer.dart` — dataless `GameCard` at `sm` in a
height-bounded horizontal list.
`lib/widgets/game_item.dart` — add `@Deprecated` naming `GameCard` at its new path;
change nothing else.
`lib/l10n/intl_en.arb` — add `add_to_library`.
`lib/l10n/intl_zh.arb` — add `add_to_library`.
`.claude/skills/flutter-widgets/SKILL.md` — catalogue table rows only: add `GameCard` at
its new path, add `LibraryTick`, add `CriticBadge`, mark `GameItem` deprecated,
re-describe the two shimmer rows. Do not edit any rule text in that file.

### TEST FILES
`test/mocks/game_mock.dart` — add a `GameEntity` getter for widget tests to `copyWith`
from; do not change the existing `Game` DTO getters.
`test/widget/components/game_card_test.dart` — 10 tests: the card's conditional content,
its two interactions, and the exact hero tag string.
`test/widget/components/critic_badge_test.dart` — 2 tests: the rounded score, and the
sanctioned green named by token.
`test/widget/games/games_screen_test.dart` — 3 tests: a card per game with no status chip
and no library tick, no overflow at a narrow and a wide surface, and the unchanged
`GameDetailRoute` payload on tap.
`test/widget/components/game_card_shimmers_test.dart` — 2 tests: each shimmer renders its
cells without throwing.

No test file for `LibraryTick` or for any of the four footer-module classes — see the
per-widget decisions above.

Generated outputs are implicit for the allowlisted sources above: `lib/generated/l10n.dart`
and `lib/generated/intl/messages_*.dart` for the `.arb` edits, and
`test/widget/games/games_screen_test.mocks.dart` for `@GenerateMocks`.

## Implementation plan

Step 1: `lib/core/res/const.dart` — add `GamesGridConstants` with the gutter, the column
count, and the column-width derivation.

Step 2: `lib/l10n/intl_en.arb` — add `add_to_library`.

Step 3: `lib/l10n/intl_zh.arb` — add the same key with its Chinese value.

Generation checkpoint: `dart pub global activate intl_utils` then
`dart pub global run intl_utils:generate` (never `flutter gen-l10n`); record which path
was taken in `diff-summary.md ## Deviations`.

Step 4: `lib/widgets/library_tick.dart` — `LibraryTick`, no parameters.

Step 5: `lib/widgets/critic_badge.dart` — `CriticBadge`, `score` its only parameter, green
from the token. No colour, threshold, variant or ramp parameter — the missing knobs are
the point.

Step 6: `lib/widgets/game_card/game_card_size.dart` — `coverAspectRatio` and the
`GameCardSize` enum (widths, footer heights, `fillsParent`, `hasFooter`, `cellHeightFor`).

Step 7: `lib/widgets/game_card/` — the four footer-module files in one step
(`game_card_footer.dart`, `game_card_small_footer.dart`, `game_card_medium_footer.dart`,
`game_card_placeholder_bar.dart`). Deliberately one step, not four: they are a single
extraction and the tree does not compile until all four exist.

Step 8: `lib/widgets/game_card/game_card.dart` — `GameCard` and its private cover
children, composing `GameCardFooter`, `LibraryTick` and `CriticBadge`. No comments in this
file, none.

Step 9: `lib/features/games/presentation/screens/games_screen.dart` — rewire
`GamesSliverGrid` to `GameCard` at `md` and to the derived `mainAxisExtent`; keep the push
payload byte-for-byte.

Step 10: `lib/widgets/game_item_grid_loading_shimmer.dart` — rewire to the dataless card
and the same derived cell height.

Step 11: `lib/widgets/game_item_loading_shimmer.dart` — rewire to the dataless card at
`sm` inside a height-bounded list.

Step 12: `lib/widgets/game_item.dart` — add the `@Deprecated` annotation.

Step 13: Two repository searches over `lib/`. `GameItem` — the only hits are inside
`game_item.dart` itself (R7); a hit anywhere else means a caller was missed, so fix it
inside the allowlist or escalate. `color.green` — the only hits are the theme's focus ring
and `critic_badge.dart`; a third hit is green leaking out of its sanctioned exception and
is a defect, not a style choice.

Step 14: `.claude/skills/flutter-widgets/SKILL.md` — the six catalogue row edits.

Step 15: `test/mocks/game_mock.dart` — add the `GameEntity` getter.

Step 16: `test/widget/components/game_card_test.dart` — the 10 tests, in the order listed
in `code-plan.md`'s delta.

Step 17: `test/widget/components/critic_badge_test.dart` — the 2 tests.

Step 18: `test/widget/games/games_screen_test.dart`, with `@GenerateMocks` for the bloc
and `StackRouter` (follow `test/widget/settings/settings_screen_test.dart`'s
`StackRouterScope` harness; `mockExistingGamesState` already exists in `test/mocks/`).

Generation checkpoint: `dart run build_runner build --delete-conflicting-outputs` for
the new `*.mocks.dart`.

Step 19: `test/widget/components/game_card_shimmers_test.dart`.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`, quoted verbatim — `Analyzer baseline: 0 errors, 2 warnings,
31 info — captured 2026-08-21` and `Test baseline: +257 -10 — captured 2026-08-21`, with
pre-existing failures in `test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3) and
`test/cubit/games/games_bloc_test.dart` (3). Those ten stay red and are not yours. Only
a new, in-scope failure is yours to fix or escalate.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: 2.1-C1 … 2.1-C15, 2.1-R1 … 2.1-R8

## Constraints

- **Widgets carry no comments at all.** Not a header, not a `///`, not a note above a
  `Stack` or a token lookup (`flutter-widgets`, `execution.md`). If a line needs
  explaining, rename it or split the widget. This covers all eight new widget files.
- No `Widget`-returning function or getter — every extracted piece is a widget class,
  private with a leading underscore when file-local.
- One class per file inside `lib/widgets/game_card/`, each file named the snake_case of
  its class. No barrel file, no `export`: a caller needing both the card and the enum
  imports `game_card/game_card.dart` and `game_card/game_card_size.dart`.
- Nothing outside `lib/widgets/game_card/` imports `GameCardFooter`,
  `GameCardSmallFooter`, `GameCardMediumFooter` or `GameCardPlaceholderBar`. They are
  public only because the module spans files.
- `CriticBadge` takes `score` and nothing else. No colour, fill, threshold, variant or
  size parameter, and no score ramp — it is one colour, always. Its green is one of §2
  rule 1's two sanctioned exceptions; do not read `color.green` anywhere else in this run.
- Every dimension the card writes is an even number. Values derived at runtime
  (`width × 4 / 3`, a text line height) are not "written" and are exempt.
- No spacing of its own: the card, the tick and the badge each render flush inside the
  bounds their parent gives them, with no outer padding or margin and no padding
  parameter. Interior structure of the card's own footer is its anatomy and is fine.
- Outlines are solid strokes; the missing-art hairline is a plain `Border`.
- All colours, radii and text styles come from `context.tokens`; no literal hex, no
  `Colors.*`, no `Theme.of(context)` (use `context.themeData` where a theme is needed).
- Every user-facing string is `S.current.[key]`.
- Network images go through `DefaultCachedNetworkImage`, never `Image.network`. The one
  bare `Image.network` in scope belongs to `PlatformRowList` and must be left alone.
- Navigation is `context.router`, never `Navigator.push/pop`.
- Import order: dart, then package (flutter → third-party → project), then relative
  (only `part` / `generated/l10n.dart`), alphabetised within each group.
- Test folders are layer-based (`test/widget/[feature]/`), never mirrored from `lib/`.
  Shared mock data lives in `test/mocks/` and is never defined inline in a test file.
- The hero tag string is a breaking-change surface: `'${ConfigConstants.heroTag}/${game.id}/$fromScreen'`,
  matching `detail_top_header.dart:171`. Do not reformat it, do not extract it into a
  helper that changes it, do not drop a segment.
- Do not touch `critics_grid.dart`, `saved_game_item.dart`, `cover_tile.dart`,
  `status_chip.dart`, `placeholder_slot.dart` or `platform_row_list.dart`.

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make tests
pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist —
escalate instead.

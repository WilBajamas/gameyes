# Task Brief
Source: `.agents/runs/game-card-20260821/tech-ac.md` — week 2 Stage 2 item 2.1, Game card
Date: 2026-08-21

## Context

Build the spec's one-anatomy, three-size game card and move the games grid and both
game shimmers onto it, so a single card anatomy survives this week instead of two.

## Testing mode

`smoke` — Rule applied: UI-only with no new logic, isolated with no shared dependencies.
Justification: no auth, payment, persistence or sync is touched; nothing below the
presentation layer changes. Tests exist to protect conditional content, interaction, the
hero-tag string and the grid's navigation payload — not appearance.

**Dedicated test files, decided per widget against the `flutter-widget-test` skill:**

- `GameCard` — **yes**. It owns conditional content (three overlays, two footer shapes,
  the missing-art fallback), two interactions, and one explicit public contract, the
  hero tag. One test per criterion carrying a widget-test `Verify:` line
  (C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15) and none beyond that. It
  will be longer than `context_chip_test.dart` because the component genuinely owns more
  behaviour, but every test must still be a single pump, a single action or condition,
  and a presence/absence or callback assertion.
- `GamesSliverGrid` — **yes**. State-driven content plus navigation with a payload that
  nothing else protects (R1, R2, R3). Three tests.
- `GameItemGridLoadingShimmer` and `GameItemLoadingShimmer` — **one shared file, one
  test each** (R5, R6). Individually each is a passive wrapper that would not earn a
  file; together they are the only place the dataless card is rendered many-at-once,
  which is the failure R5 and R6 name.
- `GameItem` — **no**. Behaviour unchanged, being retired, and it has never had a test.

**Binding test rules for every file above** (`flutter-widget-test`, revised four times —
read it in full, do not pattern-match off older test files in this repo, including
`cover_tile_test.dart`, whose first test predates the current rule):
- No assertion on a dimension, gap, radius, offset or position — ever, including the
  numbers named in C1, C2 and R2.
- No golden test, no `matchesGoldenFile`.
- Exactly one colour assertion is permitted in the whole run — the critic badge's green
  in C6 — and it must name the token (`AppColorTokens`/`context.tokens.color.green`),
  never a hex literal.
- No fake image bytes, no `Completer`, no manual invocation of `imageBuilder` /
  `errorWidget`, no zones, no arbitrary delays. `PlatformRowList` uses a bare
  `Image.network`: assert the row's presence and its inputs, never a loaded image.
- Do not pre-resolve the theme or tokens in `setUpAll` (handover gotcha #10); pass
  `buildDarkTheme()` into the pumped widget as `context_chip_test.dart` does.

## File allowlist

### CREATE NEW
`lib/widgets/game_card.dart` — `GameCardSize` enum and the `GameCard` widget, with its
file-private cover, overlay, footer and placeholder children.

### MODIFY EXISTING
`lib/core/res/const.dart` — add `GamesGridConstants` (gutter, column count, and the
column-width derivation shared by the games grid and the grid shimmer).
`lib/features/games/presentation/screens/games_screen.dart` — `GamesSliverGrid` renders
`GameCard` at `md`; delegate drops `childAspectRatio` for a derived `mainAxisExtent`.
`lib/widgets/game_item_grid_loading_shimmer.dart` — dataless `GameCard` at `md`, same
derived cell geometry as the live grid.
`lib/widgets/game_item_loading_shimmer.dart` — dataless `GameCard` at `sm` in a
height-bounded horizontal list.
`lib/widgets/game_item.dart` — add `@Deprecated` naming `GameCard`; change nothing else.
`lib/l10n/intl_en.arb` — add `add_to_library`.
`lib/l10n/intl_zh.arb` — add `add_to_library`.
`.claude/skills/flutter-widgets/SKILL.md` — catalogue table rows only (add `GameCard`,
mark `GameItem` deprecated, re-describe the two shimmer rows). Do not edit any rule text
in that file.

### TEST FILES
`test/mocks/game_mock.dart` — add a `GameEntity` getter for widget tests to `copyWith`
from; do not change the existing `Game` DTO getters.
`test/widget/components/game_card_test.dart` — the card's conditional content, its two
interactions, and the exact hero tag string.
`test/widget/games/games_screen_test.dart` — a card per game with no status chip and no
library tick, no overflow at a narrow and a wide surface, and the unchanged
`GameDetailRoute` payload on tap.
`test/widget/components/game_card_shimmers_test.dart` — each shimmer renders its cells
without throwing.

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

Step 4: `lib/widgets/game_card.dart` — create `GameCardSize` (widths, footer heights,
`fillsParent`, `cellHeightFor`) and `GameCard` with its private children. No comments in
this file, none.

Step 5: `lib/features/games/presentation/screens/games_screen.dart` — rewire
`GamesSliverGrid` to `GameCard` at `md` and to the derived `mainAxisExtent`; keep the
push payload byte-for-byte.

Step 6: `lib/widgets/game_item_grid_loading_shimmer.dart` — rewire to the dataless card
and the same derived cell height.

Step 7: `lib/widgets/game_item_loading_shimmer.dart` — rewire to the dataless card at
`sm` inside a height-bounded list.

Step 8: `lib/widgets/game_item.dart` — add the `@Deprecated` annotation.

Step 9: Search `lib/` for `GameItem` and confirm the only hits are inside
`game_item.dart` itself (R7). A hit anywhere else means a caller was missed — fix it
inside the allowlist or escalate.

Step 10: `.claude/skills/flutter-widgets/SKILL.md` — the three catalogue row edits.

Step 11: `test/mocks/game_mock.dart` — add the `GameEntity` getter.

Step 12: `test/widget/components/game_card_test.dart`.

Step 13: `test/widget/games/games_screen_test.dart`, with `@GenerateMocks` for the bloc
and `StackRouter` (follow `test/widget/settings/settings_screen_test.dart`'s
`StackRouterScope` harness; `mockExistingGamesState` already exists in `test/mocks/`).

Generation checkpoint: `dart run build_runner build --delete-conflicting-outputs` for
the new `*.mocks.dart`.

Step 14: `test/widget/components/game_card_shimmers_test.dart`.

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
  explaining, rename it or split the widget.
- No `Widget`-returning function or getter — every extracted piece is a widget class,
  private with a leading underscore when file-local.
- Every dimension the card writes is an even number. Values derived at runtime
  (`width × 4 / 3`, a text line height) are not "written" and are exempt.
- No spacing of its own: the card renders flush inside the bounds its parent gives it,
  with no outer padding or margin and no padding parameter. Interior structure of the
  card's own footer is its anatomy and is fine.
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

# Task Brief
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile"
Date: 2026-08-12

## Context

Ship the app-wide cover-tile primitive — four fixed sizes, one anatomy — so item 2.1's
game card and every later cover surface stop redrawing their own.

## Testing mode

`coverage` — Rule applied: shared utility used by 3+ features — Justification:
`DefaultCachedNetworkImage` is modified in this run and has six call sites across
`features/featured`, `widgets/game_item.dart` and `widgets/saved_game_item.dart`;
[1.3-AC15] makes their unchanged rendering an acceptance criterion, so the defaults
get a regression test alongside [1.3-AC20]'s enumerated cover-tile cases.

## File allowlist

### CREATE NEW
`lib/widgets/cover_tile.dart` — `CoverTileSize` enum, `CoverTile`, and its private
artwork, fallback and loading widgets.

### MODIFY EXISTING
`lib/widgets/default_cached_network_image.dart` — add three optional builder
parameters, each defaulting to today's exact behaviour.
`.claude/skills/flutter-widgets/SKILL.md` — add the `CoverTile` catalogue row; note
the new optional overrides on the existing `DefaultCachedNetworkImage` row.

### TEST FILES
`test/widget/components/cover_tile_test.dart` — sizes, radii, wash, colour filter,
chip slot, fallback, loading, no spacing of its own.
`test/widget/components/default_cached_network_image_test.dart` — the untouched
default placeholder and error rendering ([1.3-AC15]).

## Implementation plan

Step 1: Modify `lib/widgets/default_cached_network_image.dart` — add optional
`imageBuilder`, `placeholder` and `errorWidget` parameters typed with
`cached_network_image`'s own builder typedefs. Pass `imageBuilder` straight through;
give `placeholder` and `errorWidget` `??` fallbacks to the existing spinner and
`Icons.error` widgets. Change nothing else — `fit: BoxFit.cover`, the `imageUrl ?? ''`
handling and the `const` constructor all stay.

Step 2: Create `lib/widgets/cover_tile.dart` with the `CoverTileSize` enum — four
values carrying `width`/`height`, plus an `isMini` getter so the three permitted mini
branches read from one definition.

Step 3: In the same file, add `CoverTile` — `SizedBox` at the enum's dimensions,
`ClipRRect` at `radius.mini` for mini and `radius.lg` otherwise, and a `Stack` holding
the artwork-or-fallback branch and the optional chip. Null or empty `imageUrl` goes
straight to the fallback without a network call. Include the `static const ColorFilter`
for the artwork treatment.

Step 4: In the same file, add the three private branch widgets — `_CoverArtwork`
(the filtered image under the flat `coverWash`), `_CoverFallback` (onyx fill, hairline
border at the tile's radius, centred outline gamepad glyph, glyph omitted at mini) and
`_CoverLoading` (`Skeletonizer` over a box at the tile's size and radius).

Step 5: Create `test/widget/components/cover_tile_test.dart`.

Step 6: Create `test/widget/components/default_cached_network_image_test.dart`.

Step 7: Update `.claude/skills/flutter-widgets/SKILL.md`'s reusable-widget catalogue.

No `build_runner` step is needed: nothing in the allowlist is annotated and no test
uses `@GenerateMocks`. No `.arb` edit either — the widget renders no text.

Final step: run `flutter analyze` and `flutter test` and compare against
`orchestrator-state.md`'s recorded baselines — `Analyzer baseline: 0 errors, 2
warnings, 32 info` and `Test baseline: +241 -11`, with pre-existing failures in
`test/repository/tracker/tracker_repository_test.dart` (4),
`test/cubit/game_detail/game_detail_cubit_test.dart` (3),
`test/cubit/games/games_bloc_test.dart` (3) and `test/widget_test.dart` (1). Only a
new, in-scope regression against those numbers is yours to fix.

## Acceptance criteria source

Canonical: `tech-ac.md ## Technical acceptance criteria`
IDs in scope: [1.3-AC1] – [1.3-AC21]

## Constraints

- **No spacing of its own.** No outer padding, margin or spacer, and no `EdgeInsets`,
  `padding` or gap constructor parameter. The chip's 8px inset is inside the tile's own
  bounds and is fine (`flutter-widgets`, [1.3-AC17]).
- **Tokens only, via `context.tokens`.** Never `Theme.of(context)`, never a `Color(0x…)`
  or `Colors.*` literal, never a hardcoded radius. The only literal numbers permitted in
  the widget are the four dimension pairs, the 8px chip inset, and the artwork colour
  matrix (`dart-style.md`, [1.3-AC18]).
- **No new package** — `cached_network_image` and `skeletonizer` are both already in
  `pubspec.yaml`. Escalate rather than adding one.
- **`DefaultCachedNetworkImage` is additive-only.** Every new parameter optional,
  defaults identical to today, no call site edited, nothing deprecated ([1.3-AC15]).
- **No golden tests, no `matchesGoldenFile`**, whatever the criteria say about
  appearance (`execution.md`, `testing-conventions.md`).
- Widget tests live in `test/widget/components/`, matching `zone_label_test.dart` and
  `status_chip_test.dart`; follow their `MaterialApp` + `buildDarkTheme()` harness and
  the `'should [behaviour] when [condition]'` naming.
- Tests must not call `pumpAndSettle()` around the loading state — `Skeletonizer`
  animates forever and will time out. Use `pump()`.
- Tests must not hit the network. Drive the loaded and failed branches by invoking the
  builders off the pumped `DefaultCachedNetworkImage` instance rather than waiting on a
  real request, and do not add a network-mocking package.
- Dart style: 80-char lines, single quotes, trailing commas, `const` wherever the
  linter allows, no `default:` on an enum switch, no bare top-level constants.
- Private helper widgets stay in `cover_tile.dart`; never a `Widget`-returning function
  or getter (`flutter-widgets`, [1.3-AC1]).
- Comments: few, plain English, only where the code isn't self-evident
  (`execution.md`).

## Self-correction budget

Max attempts per failure: 3 (see `execution.md`). Do not modify test files to make
tests pass. Do not add packages to `pubspec.yaml` or touch files outside the allowlist
— escalate instead.

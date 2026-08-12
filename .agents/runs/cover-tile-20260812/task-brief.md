# Task Brief
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile"
Date: 2026-08-12

## Revision note — 2026-08-12 (Phase 3, human override)

Corrected in place against BA's revised `tech-ac.md` of the same date. [1.3-AC7] is
reversed: loaded artwork keeps its original colours and no colour filter is applied.
Changed here — step 3 no longer declares a `ColorFilter` constant, step 4's `_CoverArtwork`
is the plain image under the wash, the colour matrix is struck from the permitted-literals
constraint and a new constraint forbids the filter outright, and the cover-tile test file's
summary line now covers the filter's absence. The allowlist, the testing mode and the step
count are otherwise unchanged; `coverWash` is still required.

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
`test/widget/components/cover_tile_test.dart` — sizes, radii, wash, the absence of any
colour filter over the artwork, chip slot, fallback, loading, no spacing of its own.
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
straight to the fallback without a network call. Declare no colour filter or colour
constant of any kind ([1.3-AC7]).

Step 4: In the same file, add the three private branch widgets — `_CoverArtwork`
(the image drawn as-is, in its source colours, under the flat `coverWash`),
`_CoverFallback` (onyx fill, hairline border at the tile's radius, centred outline
gamepad glyph, glyph omitted at mini) and `_CoverLoading` (`Skeletonizer` over a box
at the tile's size and radius).

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

- **No colour treatment on loaded artwork.** The `Image` renders in its source colours
  with nothing wrapping it — no `ColorFiltered`, no `ColorFilter.matrix`/`.mode`, no
  saturation/contrast adjustment, no blend mode, no opacity change. §3.3's
  `saturate(.5) contrast(1.05)` wording is overridden by human decision and must not be
  reintroduced from the spec ([1.3-AC7]). The `coverWash` overlay above the artwork is
  unaffected and still required ([1.3-AC8]).
- **No spacing of its own.** No outer padding, margin or spacer, and no `EdgeInsets`,
  `padding` or gap constructor parameter. The chip's 8px inset is inside the tile's own
  bounds and is fine (`flutter-widgets`, [1.3-AC17]).
- **Tokens only, via `context.tokens`.** Never `Theme.of(context)`, never a `Color(0x…)`
  or `Colors.*` literal, never a hardcoded radius. The only literal numbers permitted in
  the widget are the four dimension pairs and the 8px chip inset (`dart-style.md`,
  [1.3-AC18]).
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

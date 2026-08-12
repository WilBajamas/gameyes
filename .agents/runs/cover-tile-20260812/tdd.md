# Technical Design Document
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile"
Date: 2026-08-12

## Feature summary

One presentation-layer widget, no new state, no new data path. `CoverTile` is a
fixed-size `SizedBox` → `ClipRRect` → `Stack`: artwork branch, fallback branch, and
an optional chip slot. It reads every colour and radius from `context.tokens` and
loads remote art through the existing `DefaultCachedNetworkImage`, which gains three
optional builder slots so the tile can supply its own loaded / loading / failed
rendering without changing what its six current callers see. A closed
`CoverTileSize` enum carries the four literal dimension pairs.

## Layer map

[1.3-AC1] … [1.3-AC13]: UI
[1.3-AC14]: UI (reuses the existing `cached_network_image` path; no data-layer work)
[1.3-AC15]: UI (additive change to a shared widget)
[1.3-AC16] … [1.3-AC19]: UI
[1.3-AC20]: test
[1.3-AC21]: docs

No API, repository, use case, datasource, DTO or state work in this run.

## Data layer

None. [1.3-AC14] is satisfied by reusing `DefaultCachedNetworkImage`, which already
wraps `CachedNetworkImage` and its shared cache manager.

## Domain layer

None.

## State layer

None. The tile is display-only ([1.3-AC16]) and holds no state — a `StatelessWidget`,
not a `StatefulWidget`.

## UI layer

### Screens

None. The tile ships with no caller.

### Widgets

`CoverTile` (create) — `lib/widgets/cover_tile.dart` — stateless — consumes
`context.tokens` (`color.coverWash`, `color.canvas`, `color.hairline`, `color.ink24`,
`radius.mini`, `radius.lg`) plus `StatusChip` — no interactions.
Constructor: `imageUrl` (`String?`), `size` (`CoverTileSize`, required),
`status` (`LibraryStatus?`). No spacing parameter of any kind ([1.3-AC17]).

`CoverTileSize` (create) — same file — closed enum of four values carrying `width`
and `height` literals and an `isMini` getter. The only per-size branches are
dimensions, radius, the mini glyph omission and the mini chip omission ([1.3-AC4]).

`_CoverFallback` (create) — same file, private — onyx fill, hairline border, centred
outline gamepad glyph; glyph omitted at mini ([1.3-AC12]). Takes the tile's border
radius so the hairline follows the rounded corners rather than being clipped square
by the outer `ClipRRect`.

`_CoverLoading` (create) — same file, private — `Skeletonizer` over a box at the
tile's exact size and radius ([1.3-AC13]). No spinner.

`DefaultCachedNetworkImage` (modify) — `lib/widgets/default_cached_network_image.dart`
— gains three optional builders (`imageBuilder`, `placeholder`, `errorWidget`), each
defaulting to the exact widget it renders today.

Composition order inside the clip, bottom to top: artwork (filtered) → wash → chip.
The wash and the filter live inside the loaded-image branch only, so neither touches
the fallback or the loading block ([1.3-AC7], [1.3-AC9]).

## Reuse decisions

**`DefaultCachedNetworkImage` at `lib/widgets/default_cached_network_image.dart` —
extended, not bypassed.** This is the design question the BA flagged. Two options
were on the table: add optional parameters to the shared widget, or have `CoverTile`
compose `CachedNetworkImage` directly. Chosen: extend it, because —

1. `project-conventions.md` and the `flutter-widgets` skill both make this widget the
   app's single remote-image path. A second direct `CachedNetworkImage` call site
   inside `lib/widgets/` is the precedent the next agent copies, and [1.3-AC15]'s own
   failure case names "a parallel duplicate of the cached-image wrapper" as a reject.
2. The change is provably behaviour-preserving rather than argued to be: each new
   parameter is nullable, and the widget falls back with `??` to the literal widget it
   builds today. `imageBuilder` passes through as `null`, which is exactly what
   `CachedNetworkImage` receives now. No existing call site changes, nothing is
   deprecated, `fit: BoxFit.cover` stays the default ([1.3-AC15]).
3. The widget is genuinely three builders short of what a cover needs, which is the
   `flutter-widgets` "adjust it rather than writing a new one next to it" case.

`imageBuilder` is required, not optional convenience: [1.3-AC9] puts the wash and the
colour filter on loaded artwork only, and that branch cannot be addressed from
outside the widget. `placeholder` and `errorWidget` are required by [1.3-AC13] and
[1.3-AC12] — the current spinner and `Icons.error` are exactly what the spec forbids.

This is an API extension to a shared widget, not an architecture change: no mechanism
moves, no caller breaks, nothing new to learn about how the project works. A
regression test pins the defaults.

**`StatusChip` at `lib/widgets/status_chip.dart`** — the on-media variant is used
as-is for the chip slot ([1.3-AC10]). It adds no spacing of its own, so the tile's
8px inset is the tile's own `Positioned` and nothing double-counts.

**`Skeletonizer` (`skeletonizer`, already in `pubspec.yaml`)** — the project's
existing shimmer mechanism, per the `flutter-widgets` loading pattern. No new package.

**Tokens** — `coverWash`, `canvas`, `hairline`, `ink24`, `radius.mini`, `radius.lg`
all exist in `lib/config/theme/tokens/`. No token is added, renamed or duplicated
([1.3-AC18], and the out-of-scope list).

**No token exists for the artwork's `saturate(.5) contrast(1.05)` treatment** and new
tokens are out of scope, so the colour matrix lives as a `static const ColorFilter` on
`CoverTile` itself. This is the one place literal numbers beyond the four dimension
pairs and the chip inset appear; [1.3-AC18]'s failure cases are about colour literals
and hardcoded radii, and [1.3-AC7] mandates these exact multipliers, so this is
consistent with both. Exposing it as a `static const` also lets the widget test assert
the filter by identity instead of restating the matrix.

## Out of scope

- Any caller. The tile ships unwired; `game_item.dart` is untouched and nothing is
  marked `@Deprecated` (task brief, tech-ac `## Out of scope`).
- A fifth size, or any width/height parameter. The set is closed at the spec's four.
  Item 2.1's `xs / sm / md` card widths are that item's decision and are deliberately
  not pre-solved here ([1.3-AC2]).
- The library tick, critic badge and error badge overlays ([1.3-AC11]); tap, hero and
  press/hover treatment ([1.3-AC16]); new tokens; localisation ([1.3-AC19]).
- Golden tests, at any level of pixel detail in the criteria (`execution.md`,
  `testing-conventions.md`, [1.3-AC20]).

## Open questions

NONE

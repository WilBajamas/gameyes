# Technical Design Document
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile"
Date: 2026-08-12

## Revision note — 2026-08-12 (Phase 3, human override)

Corrected in place against BA's revised `tech-ac.md` of the same date, per the in-place
revision rule in `.agents/handover.md`. [1.3-AC7] is reversed: loaded artwork renders in
its original colours and no colour filter, colour matrix, blend mode or opacity change is
applied to it. Removed from this document: the `static const ColorFilter` reuse decision,
the filter from the composition order, and the filter from `imageBuilder`'s justification.
The `coverWash` overlay is untouched and still required — only the pixel-level filter
went. No file enters or leaves the allowlist because of this revision.

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

Composition order inside the clip, bottom to top: artwork → wash → chip. The artwork
is drawn as-is, in its source colours, with nothing wrapping it ([1.3-AC7]); the wash
lives inside the loaded-image branch only, so it never touches the fallback or the
loading block ([1.3-AC9]).

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

`imageBuilder` is required, not optional convenience: [1.3-AC9] puts the wash on
loaded artwork only, and that branch cannot be addressed from outside the widget.
`placeholder` and `errorWidget` are required by [1.3-AC13] and [1.3-AC12] — the
current spinner and `Icons.error` are exactly what the spec forbids.

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

**No colour treatment on the artwork, and therefore no colour constant to place.**
[1.3-AC7] requires loaded art to render in its source colours, so the `Image` is
composed directly with nothing wrapping it — no `ColorFiltered`, no
`ColorFilter.matrix`/`.mode`, no blend mode, no opacity. §3.3's
`saturate(.5) contrast(1.05)` wording is deliberately not implemented (tech-ac
revision note and `## Out of scope`), and must not be reintroduced from the spec.
This leaves the four dimension pairs and the 8px chip inset as the only literal
numbers in the widget ([1.3-AC18]).

## Out of scope

- Any colour filter, colour matrix, saturation/contrast adjustment or blend mode over
  loaded artwork. Not deferred — not built at all ([1.3-AC7], tech-ac `## Out of
  scope`). The `coverWash` overlay is separate and stays in ([1.3-AC8]).
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

# Technical Acceptance Criteria
Source: Week 2 task brief item 1.3 · `system-foundation-specs.md` §3.3 "Cover tile" (with §0, §1.1, §1.3, §1.4, §1.6, §1.8, §1.9, §2.2, §2.6, §3.2, §5, §6) · build conventions from the `flutter-widgets` skill "Building a new reusable widget"
Date: 2026-08-12
BA Agent version: 1.0

## Feature summary

Add one app-wide presentation primitive for game cover art: a fixed-size media tile that
crops its image to fill, halves its saturation and lifts contrast slightly, lays a flat
indigo wash over it, clips everything to the tile's radius, and optionally carries a status
chip in its bottom-left corner. One anatomy, four sizes that differ only in dimensions and
(for the smallest) radius. Missing or failed art falls back to a flat onyx block with a
hairline and a gamepad glyph rather than the error PNG used elsewhere today. Every colour
and radius it needs already exists in `lib/config/theme/tokens/` — including `coverWash`
and the `mini` radius step — so this run adds no token, and the status chip it hosts was
built in item 1.2. The tile owns no spacing outside its own box. No screen is rewired and
`DefaultCachedNetworkImage`'s behaviour for its six current callers is unchanged: the
deliverable is the component, its tests, and its catalogue entry.

## Technical acceptance criteria

[1.3-AC1] PRESENTATION: A globally reusable cover-tile widget exists under `lib/widgets/`,
named categorically for what it is, with no `default` name prefix, built from plain Flutter
widgets in the style of the existing hand-written `lib/widgets/` components, with a `const`
constructor and no new third-party package. Any private helper widget lives in the same file.
  Failure case: placed in a feature folder, `default`-prefixed, split across files with no
  second caller, or written as a Widget-returning function/getter — reject at review.

[1.3-AC2] PRESENTATION: The widget accepts exactly one of four sizes — mini, row, fan,
focal — as a closed set, and renders at these literal dimensions in logical pixels:
mini `26×34`, row `112×150`, fan `100×134`, focal `124×166`. No arbitrary width/height
parameter and no fifth size.
  Failure case: dimensions derived from an aspect ratio (none of the four is exactly 3:4),
  a caller-supplied size, or the tile stretching to its parent's width.

[1.3-AC3] PRESENTATION: The tile sizes itself in both axes and is independent of its
parent's constraints — the same size value produces the same box inside a `Row`, a `Stack`,
a scroll rail or an unbounded parent.
  Failure case: the tile filling available space, collapsing to zero, or overflowing when
  placed in an unbounded parent.

[1.3-AC4] PRESENTATION: Anatomy is identical at all four sizes — same image treatment, same
wash, same fallback, same chip slot. Only the dimensions and the corner radius change; no
size gets an extra element, a different order, or a redrawn structure.
  Failure case: a size-specific branch beyond dimensions, radius, and the two documented
  mini omissions ([1.3-AC10], [1.3-AC12]).

[1.3-AC5] PRESENTATION: The corner radius is the existing `mini` radius token (5) at the
mini size and the existing `lg` radius token (16) at the other three. Image, wash, fallback
and any overlay are clipped to that radius on all four corners.
  Failure case: a literal radius value, a square corner anywhere, or artwork/wash painting
  outside the rounded bounds.

[1.3-AC6] PRESENTATION: The image fills the tile's box and is cropped to cover it —
centred, aspect ratio preserved, never letterboxed, stretched or squashed, whatever the
source image's own dimensions.
  Failure case: bars beside or above the artwork, a distorted image, or a source image
  narrower than the tile leaving the tile's fill showing through.

[1.3-AC7] PRESENTATION: A colour treatment is applied to the artwork — saturation reduced
to 50% and contrast multiplied by 1.05 — at every size, before the wash is composited. The
treatment applies to the artwork only: it does not alter the wash, the status chip, or the
missing-art fallback.
  Failure case: unfiltered artwork, the filter applied over the chip so its dot hue shifts,
  or the filter applied at some sizes only.

[1.3-AC8] PRESENTATION: A flat indigo wash from the existing `coverWash` token
(`rgba(10,13,58,.42)`) covers the full artwork area at a single uniform opacity, above the
filtered image and below any overlay. No gradient, no scrim ramp, no per-size opacity, no
new colour value declared in the widget.
  Failure case: a `LinearGradient`/scrim of any kind, a wash covering only part of the
  tile, or a literal `Color`/`Colors.*` value in the widget file.

[1.3-AC9] PRESENTATION: The wash and the colour treatment apply to loaded artwork only.
The missing-art fallback renders its own colours untouched by either.
  Failure case: the fallback darkened by the wash or desaturated by the filter.

[1.3-AC10] PRESENTATION: An optional status chip renders in the tile's bottom-left corner,
using the existing status-chip primitive's on-media variant, inset from the tile's bottom
and left edges. When no status is supplied, nothing renders in that slot — no placeholder,
no reserved space. The chip is not offered at the mini size.
  Failure case: the chip painting outside the tile's rounded bounds, the list variant used,
  a second overlay slot added, or an empty slot changing the tile's appearance.

[1.3-AC11] PRESENTATION: The chip is the only overlay. The game card's indigo library tick,
green critic badge, and the error state's corner alert badge are not built here.
  Failure case: any additional overlay parameter or slot.

[1.3-AC12] PRESENTATION: When no image URL is available or the image fails to load, the
tile renders the same fallback in both cases, at its exact size and radius: a flat onyx
fill, a hairline outline, and a centred outline gamepad glyph from the icon set already
compiled into the app. Never the `error_404.png` asset, never a title initial, never a
broken-image or error icon. At the mini size the glyph is omitted and the fallback is the
fill plus hairline.
  Failure case: two different fallbacks for null-vs-failed, the error PNG or `Icons.error`
  rendering, a letter rendering, or the fallback box differing in size from a loaded tile.

[1.3-AC13] PRESENTATION: While the image is loading, the tile occupies its exact final box
and radius and shows a shimmer-style placeholder — never a `CircularProgressIndicator` or
any spinner. Nothing around the tile moves when the image arrives.
  Failure case: a spinner, a zero-size tile during load, or a layout shift on load
  completion.

[1.3-AC14] DATA/PRESENTATION: Remote artwork loads through the app's existing cached
network image path, so a rebuild or a second tile showing the same URL does not refetch it.
`Image.network` is not used.
  Failure case: `Image.network` in the widget, or a visible refetch on rebuild.

[1.3-AC15] PRESENTATION: `DefaultCachedNetworkImage`'s rendering for its six existing
callers is unchanged by this run — same placeholder, same error widget, same call sites. If
it is extended to serve this tile, every new input is optional and defaults to today's
behaviour; nothing is deprecated or deleted.
  Failure case: an existing caller's loading or error appearance changing, a required
  parameter added to an existing widget, or a parallel duplicate of the cached-image
  wrapper appearing beside it.

[1.3-AC16] PRESENTATION: The tile is display-only — no `onTap`, no `InkWell`, no
`GestureDetector`, no hero tag, no press or hover treatment. A caller needing a tappable or
hero-animated cover wraps it.
  Failure case: a tap callback, a ripple, a `Hero` inside the widget, or a scale/brightness
  change on press.

[1.3-AC17] PRESENTATION: The widget adds no spacing of its own outside the box it draws —
no outer padding, margin or spacer, and no `EdgeInsets`, `padding` or gap constructor
parameter reintroducing it through the API. It renders flush within the bounds its parent
gives it; separation between tiles belongs to the layout that places them, per §1.3's
"stacks use flex `gap`, never margins between siblings". The status chip's corner inset is
inside the tile's own bounds and is the widget's anatomy, not outer spacing.
  Failure case: any outer padding/margin/spacer baked in, or a spacing parameter on the
  constructor.

[1.3-AC18] PRESENTATION: All colour, radius and effect values come from the existing
tokens, read through the project's context extension — never `Theme.of(context)` directly,
never a re-declared duplicate of an existing token. The only literal numbers in the widget
are the four sizes' dimensions and the chip inset.
  Failure case: a direct `Theme.of(context)` call, a `Color(0x…)`/`Colors.*` literal, or a
  hardcoded corner radius.

[1.3-AC19] PRESENTATION: The widget renders no text and adds no localisation key. Nothing
user-facing is hardcoded because nothing user-facing is drawn.
  Failure case: a literal display string, or a `label`/`title` parameter appearing on this
  primitive.

[1.3-AC20] TESTS: Widget tests cover — each of the four sizes rendering its stated
dimensions; the mini size rendering the smaller radius and the other three the `lg` radius;
the wash rendering at `coverWash` above the artwork; the colour treatment being applied to
the artwork; a supplied status chip rendering bottom-left in the on-media variant and
nothing rendering when none is supplied; the fallback rendering for a null URL and for a
load failure, with no `error_404.png` and no title initial; the loading state rendering no
`CircularProgressIndicator`. No golden test and no `matchesGoldenFile`, whatever the
criteria above say about appearance.
  Failure case: a new test failure beyond the recorded baseline, or a golden test added.

[1.3-AC21] DOCS: The `flutter-widgets` skill's reusable-widget catalogue gains a row for
the new widget, noting it adds no spacing of its own.
  Failure case: the catalogue still omits it, so the next agent rebuilds the same thing.

## Out of scope

- Rewiring any screen or widget. The tile ships with no caller, per the task brief — the
  game card (item 2.1) is its first consumer. `lib/widgets/game_item.dart` keeps its
  `AspectRatio(4/4.8)` cover, its top-only 8px radius and its `error_404.png` fallback
  untouched, and nothing is marked `@Deprecated` in this run.
- The game card's other cover overlays — indigo library tick (top-right), green critic
  badge (top-left) — and §3.4's item-level error badge, which shares the tick's slot. All
  item 2.1 / item 2.7.
- Per-screen cover geometry that is not one of §3.3's four sizes: Home's 92px release-rail
  cover (120px tall) and 150px grid cover, Game Detail's 104×139 rail tile. Those are
  screen-doc numbers for screens not built yet; whether they become tile sizes or stay
  screen-local is those items' call.
- The hero transition for covers navigating to game detail. The tag needs the game id and
  the source screen, neither of which this primitive knows.
- Reconciling `home-screen-design-conventions.md` §3.1's gradient veil on the same
  `112×150` cover with §3.3's flat wash — see `ambiguities.md`. The flat wash is built; the
  screen doc is owed a correction when Home's hero is built, not now.
- The `game-detail-design-conventions.md` §2 open decision on the hero key-art ramp. That
  is the 88px swoop hero's three-stop ramp, a different surface from this primitive.
- New design tokens. `coverWash`, `mini`/`lg` radius, `canvas` onyx, `hairline` and the
  status-chip tokens all exist and are reused as-is.
- §1.8 press and hover states, screen-reader semantics, count/label copy, and iOS
  verification of any criterion.

## Assumptions

ASSUMPTION: The wash is flat at one uniform opacity (§2.6's "no scrim gradients", §6's
`coverWash` entry), not the gradient veil the Home screen doc describes for the same cover.
ASSUMPTION: Missing art uses §3.2's onyx fill + hairline + gamepad glyph, not §2.2's
art-surface fills — §3.2 is the cover-specific rule and the art-surface tokens do not exist
in `app_color_tokens.dart`.
ASSUMPTION: Null URL, empty URL and load failure are one fallback path, not three.
ASSUMPTION: The gamepad glyph comes from the icon set already compiled into the app; no
Lucide package is added for one glyph.
ASSUMPTION: The glyph is omitted at mini — 26×34 cannot hold a legible glyph.
ASSUMPTION: The four sizes are literal fixed dimensions, not aspect ratios; none is exactly
3:4, so a ratio would change three of the four numbers.
ASSUMPTION: The size set is closed. Item 2.1's `xs 64 / sm 132 / md 220+` widths are not in
it; extending the set is 2.1's decision.
ASSUMPTION: The status chip slot is item 1.2's on-media variant, inset 8px from the
bottom-left corner (§1.3 scale — the spec gives no inset), and is not offered at mini.
ASSUMPTION: Loading is a shimmer block at the tile's exact box, per §3.2's "never spinners";
`skeletonizer` is already a dependency and `DefaultCachedNetworkImage`'s spinner is not
reused here.
ASSUMPTION: The tile is display-only, with no tap and no hero tag — both belong to the card
that contains it.
ASSUMPTION: This run ships the component unwired. The Week 2 checklist assigns
rewiring-scope decisions to items 2.1 and 2.5 only and states 1.3 has no current caller.

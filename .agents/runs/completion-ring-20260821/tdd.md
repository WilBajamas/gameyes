# Technical Design Document
Source: `.agents/runs/completion-ring-20260821/tech-ac.md` — week 2 Stage 2 item 2.2, Completion ring
Date: 2026-08-21

## Feature summary

One new presentation-layer widget in `lib/widgets/`, display-only, with no data, domain or
state layer behind it. A fixed square box holds a custom-painted circle: an `ink12` track
with a proportional arc over it, and the truncated percentage (plus an optional caption)
centred on top. Three fixed sizes are a closed enum. The widget is pure — value in, ring
out — and ships with no caller, so nothing else in the tree changes.

## Layer map

`2.2-C1` … `2.2-C15`: UI only. No API, repository, use case, state or storage layer is
touched by any criterion.

## Data layer

None. No API contract, model or repository is required — the component receives a number
and derives nothing (`tech-ac.md ## Out of scope`).

## Domain layer

None.

## State layer

None. `CompletionRing` is a `StatelessWidget` holding no internal state (C15); the value is
a constructor parameter and a value change is a plain rebuild (no animation, per
`## Out of scope`).

## UI layer

### Screens

None. The component ships unwired by the checklist's explicit decision; no screen is added,
modified or assumed.

### Widgets

`CompletionRing` (create) — `lib/widgets/completion_ring.dart` — stateless — consumes
`value` (`double`, required, non-nullable), `size` (`CompletionRingSize`, required),
`caption` (`String?`, optional) — no interactions, no callbacks, not a hit target.

`CompletionRingSize` (create) — same file — closed enum of exactly three members carrying
the per-size numbers: `inline` (60 box, 6 stroke, no caption), `specimen` (80 box, 8
stroke), `detail` (88 box, 8 stroke). The centre-line radius is derived, not stored:
`(box - inset * 2 - stroke) / 2` with a shared inset of 2. That formula reproduces both
documented sizes exactly — 60 → r25 and 88 → r38 (`game-detail-design-conventions.md`
§"Your run", `home-screen-design-conventions.md` §3.1) — and yields r34 for the undocumented
80 under ASSUMPTION-2, so the specimen size is a consequence of the other two rather than an
invented number.

`CompletionRingPainter` (create) — same file — `CustomPainter` drawing the track circle then
the progress arc, from `-π/2` clockwise, `StrokeCap.round`, one flat colour per stroke.

## Design decisions

### 1. How the ring is painted — a `CustomPainter`, the project's first real one

Precedent check: nothing in `lib/` paints an arc. The only `CustomPainter` in the codebase is
`_DashedBorderPainter` in `lib/features/featured/presentation/widgets/library_stats.dart`,
which is the known "outlines are always solid" violation owned by item 2.8. It is not copied,
not extended and not fixed here. Two things in it are actively **not** to be imitated:

- `shouldRepaint(...) => false`. Harmless for a static dashed box, wrong for anything
  value-driven — it would freeze the arc at its first value forever. `CompletionRingPainter`
  compares every field it paints from (progress, radius, stroke, both colours).
- `Path.computeMetrics` dash extraction. Nothing in this component breaks a stroke.

`CircularProgressIndicator` was considered and rejected as the base. It is a Material
component: in Material 3 the determinate indicator owns its own track gap, cap shape,
stroke alignment and minimum size, all of which move with the Flutter version and the theme,
and its colour would sit behind `valueColor`/`ProgressIndicatorThemeData` indirection rather
than being the stated contract C8 requires. It also cannot be made to paint *nothing* at 0
(C4). The `CircularProgressIndicator` occurrences already in the codebase are inline loading
spinners and are unrelated and untouched.

The track and the arc are painted by **one** painter, not by a `BoxDecoration` circle border
plus an arc. Splitting them across two mechanisms would make the magenta close at 100 depend
on a `BoxDecoration` border stroke and a canvas stroke landing on the same centre line — a
silent half-pixel misalignment class. One painter derives both from the same rect.

Cap shape is `StrokeCap.round`: both documented sizes specify `stroke-linecap: round`. The
painter therefore returns without drawing the arc at all when the fraction is 0, so 0% reads
as an untouched track rather than a round cap dot (C4's named failure case).

### 2. Placement — one flat file, no folder

`lib/widgets/completion_ring.dart` holds the enum, the widget and the painter.

Item 2.1's `lib/widgets/game_card/` folder exists because the card is a *module*: six
classes across six files, of which four are internal-only. That shape was human-directed for
that module and does not generalise. The live precedent for a single-widget component with a
size variant is `cover_tile.dart` (`CoverTileSize` enum with four sized members, in the same
file as `CoverTile`) and `status_chip.dart` (`StatusChipVariant` in the same file). This
component is smaller than both. A folder holding one file, plus an `enum/` subfolder holding
one ten-line enum, would be cargo-culting 2.1's layout onto something that is not a module.

`CompletionRingPainter` is public rather than `_CompletionRingPainter` for one reason: C8,
C9 and C10 require the colour switch and the track colour to be asserted by token in a widget
test, and no golden test may be written. A private painter makes that untestable. It is
internal surface by convention — nothing outside `completion_ring.dart` and its test imports
it — exactly as the `game_card/` footer classes are.

### 3. The value contract — one place, four consumers

`value` is a required non-nullable `double`; there is no nullable, indeterminate or loading
input to have a contract about (C7). Everything derived from it is computed once at the top
of `build`, in three lines, and nothing recomputes it:

- `clamped` — `value.clamp(0, 100).toDouble()`. The only clamp in the component (C5).
- `percentage` — `clamped.truncate()`, an `int`. The only truncation (C6). Truncation, not
  rounding, is what makes `100%` mean exactly 100.
- `complete` — `clamped == 100`. The only comparison that selects magenta (C8).

The four consumers each read one of those three and never re-derive: the painter's fraction
is `clamped / 100`, the visible label is `'$percentage%'`, the semantics label is built from
`percentage`, and the progress colour is chosen by `complete`. Because the label, the
semantics and the colour all descend from the same clamped value, C6's "the label and the
magenta close always agree" holds by construction rather than by two rules agreeing.

No assert, no exception, no debug guard: `-5` and `140` are ordinary inputs that produce the
0 and 100 renderings (C5).

### 4. Accessibility — one announcement, not two

The number is painted *and* spoken, so the wrapper is
`Semantics(container: true, excludeSemantics: true, label: ...)` around the whole ring. Without
`excludeSemantics` a screen reader would read the centre `Text` and then the wrapper label —
"37%. 37% completed". Excluding gives one node carrying the value and its meaning (C14), and
the arc is never the only carrier (C11).

**The caption is deliberately not announced.** At 80 and 88 the caption is a sub-label under a
number whose meaning the semantics phrase already states; announcing "37% completed, done"
adds nothing. If a future caller supplies a caption carrying independent information, that is
the point to revisit this, not now.

**Copy — a deviation from ASSUMPTION-5, taken for reuse.** The existing localisation key
`completed_percentage` (`"{percentage}% completed"` / `"已完成 {percentage}%"`, already used by
`library_stats.dart`) says what ASSUMPTION-5 invented `<n>% complete` to say. Reusing it means
the ring ships with a real Chinese translation instead of a guessed one, and adds no `.arb`
keys and no localisation regeneration step to this run. The shipped announcement is therefore
`37% completed`, not `37% complete`. The semantics test asserts that exact string, so a future
copy edit to the shared key surfaces as a failing test rather than silently changing what the
ring says.

## Deviations from `tech-ac.md`

**C12's inline type step: 15 → 14.** The `flutter-widgets` convention "dimensions are even
numbers ... including a font size declared in code" binds new code and instructs rounding to
the neighbour that reads better. 14 rather than 16: the 60 ring's clear inner diameter is
44 (`60 - inset 2×2 - stroke 6×2`), and the worst-case label `100%` in Space Grotesk 700
measures roughly 42 at 16 — touching the stroke — against roughly 37 at 14. 16 buys three
pixels of figure and risks the widest label colliding with the ring at any text scale above
1.0. The other two steps are already even and are unchanged: 18 at specimen (matching the
`statFigure` token) and 22 at detail (matching the documented `68%`). QA verifies 14 at the
inline size, not 15.

All three sizes remain **fixed, not minimums**: 60/80/88 exact square boxes, a closed set of
three, no free-form diameter input. Nothing in this design puts them under the pressure that
downgraded item 2.1's `md` 220 — the widget writes `SizedBox.square` and never reads its
parent's constraints, and the largest box is 88, which fits any phone column. **No downgrade
to "design reference" is needed or accepted here.**

## Reuse decisions

- `AppColorTokens` at `lib/config/theme/tokens/app_color_tokens.dart` — `accentIndigo`,
  `accentMagenta`, `ink12`, `ink55` all exist. No new colour token, no literal hex.
- `AppTypeTokens.statFigure` at `lib/config/theme/tokens/app_type_tokens.dart` — display face
  700 in ink, already the "Stat figure" step. The three centre sizes are one
  `copyWith(fontSize:)` off that single token, so all three sizes share one face, weight,
  line height and colour: §0 principle 1, one anatomy sized rather than redrawn.
- `AppTypeTokens.microLabel` — 10/500, the caption's size. Rendered with `ink55` per C13 and
  with the caller's string as supplied (`.style`, not `.format`), so `done` stays lowercase
  as the detail panel shows it. Same use `StatPill` already makes of that token.
- `S.current.completed_percentage` — see Design decision 4.
- `context.tokens` via `ContextExtensions` — never `Theme.of(context)`.

## The white-on-media variant — cost of adding it later

Asked for explicitly, since the BA resolved the §3.1/§3.2 conflict in favour of §3.2's indigo
and put the pure-white-on-24%-white-track variant out of scope.

**It stays cheap.** The variant differs from this one in exactly two values — track colour and
arc colour — and in nothing else: same box sizes, same strokes, same inset, same geometry,
same label, same semantics, same clamping. The painter already takes `trackColor` and
`progressColor` as parameters, because it must (the arc switches colour at 100 regardless), so
the later variant is a `CompletionRingTone { standard, onMedia }` enum plus one `switch` in
the widget's colour resolution — no re-plumb of the painter, no geometry change, no change to
any existing test, and the existing tests keep protecting the default tone. Roughly an hour,
not a rewrite.

The one thing that would make it expensive is resolving the colours *inside* the painter from
`context.tokens` instead of passing them in; this design does not do that. No tone parameter
is added now — nothing calls it (`flutter-widgets`: no parameter for a case nothing calls yet).

## Out of scope

- Any caller, screen or wiring — the checklist ships this unwired; no screen integration is in
  the allowlist.
- The white-on-media variant, animation, an indeterminate mode, deriving completion from data,
  the detail panel's Completed variant, and pixel verification of the painted arc — all per
  `tech-ac.md ## Out of scope`.
- `_DashedBorderPainter`'s solid-outline violation in `library_stats.dart`. Owned by item 2.8;
  not touched, not copied.

## Open questions

NONE

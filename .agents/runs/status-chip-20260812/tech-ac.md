# Technical Acceptance Criteria
Source: Week 2 task brief item 1.2 · `system-foundation-specs.md` §3.2 "Status system" + §3.3 "Status chip" (with §1.2, §1.3, §1.4, §1.6, §4, §5, §6, §7.1) · status-hue decision from `roadmap-deferred.md` "Status chip hues — RESOLVED 2026-07-30" · build conventions from the `flutter-widgets` skill "Building a new reusable widget"
Date: 2026-08-12
BA Agent version: 1.0

## Feature summary

Add one app-wide presentation primitive for library status: a pill carrying a coloured dot,
the status label, and an optional count. Six statuses, one anatomy, two variants that differ
only in dot size and capsule fill — on-media (over cover art) and list (on an app surface).
Playing is the only filled state; the other five are tinted. Every colour, radius and text
style it needs already exists in `lib/config/theme/tokens/` — including the six-status set in
`app_status_tokens.dart` — so this run adds no token. The count is load-bearing: the chip
renders whatever count it is given, including zero, and never silently drops one. The widget
owns no spacing outside its own capsule. No screen is rewired: the deliverable is the
component, two localisation keys, its tests, and its catalogue entry.

## Technical acceptance criteria

[1.2-AC1] PRESENTATION: A globally reusable status-chip widget exists under `lib/widgets/`,
named categorically for what it is, with no `default` name prefix, built from plain Flutter
widgets in the style of the existing hand-written `lib/widgets/` components, with a `const`
constructor and no new third-party package. Any private helper widget lives in the same file.
  Failure case: placed in a feature folder, `default`-prefixed, split across files with no
  second caller, or written as a Widget-returning function/getter — reject at review.

[1.2-AC2] PRESENTATION: The widget accepts exactly one of six statuses — Playing, Backlog,
Completed, On hold, Wishlist, Dropped — as a closed set. No seventh value and no free-form
status string is accepted.
  Failure case: the API accepts a status outside the six, or a caller can pass an arbitrary
  string as the status.

[1.2-AC3] PRESENTATION: Every status renders the same anatomy in the same order inside one
capsule: dot, then label, then the count when supplied. No status gets an extra element,
a different order, or a different shape.
  Failure case: any status renders a bespoke layout, an icon, or a second dot.

[1.2-AC4] PRESENTATION: The capsule is `--radius-pill` from the existing radius token in
every variant and for every status.
  Failure case: a literal radius value, or a status/variant rendering a non-pill shape.

[1.2-AC5] PRESENTATION: Two variants exist, differing only in dot diameter and capsule fill —
on-media 6px dot, list 7px dot. Nothing else is redrawn between them: same order, same label
style, same count treatment.
  Failure case: a third variant, a variant-specific label size, or a variant that reorders or
  drops an element.

[1.2-AC6] PRESENTATION: For the five tinted statuses, the list variant's capsule fill is the
existing 8% ink token, flat, with no blur. The on-media variant's capsule fill is black at
42% opacity with the existing glass-blur effect applied behind the capsule and clipped to the
pill shape.
  Failure case: blur bleeding outside the pill's bounds, blur applied in the list variant, or
  either variant using the other's fill.

[1.2-AC7] PRESENTATION: Playing renders as the only filled status in both variants: the
capsule takes the indigo fill from the existing status tokens, and its dot and label render
in ink (white), not in the status token's `color`.
  Failure case: an indigo dot on an indigo fill (invisible), Playing rendered tinted, or a
  second status rendered filled.

[1.2-AC8] PRESENTATION: Each tinted status's dot colour comes from the existing status tokens
— Backlog 55% ink, Completed magenta, On hold violet, Wishlist link cyan, Dropped 28% ink.
The widget declares no literal colour value of its own.
  Failure case: any `Color(0x…)` or `Colors.*` literal in the widget file, or a re-declared
  duplicate of an existing token.

[1.2-AC9] PRESENTATION: The label renders through the existing `pill` type token (11px,
weight 500, `.08em` letter-spacing) and through that token's uppercase formatting, in full
ink in both treatments. The widget declares no literal font size, weight, colour or
letter-spacing.
  Failure case: a literal text style value, or the label rendering in mixed case.

[1.2-AC10] PRESENTATION: The label text is resolved from the status value through `S.current`.
No user-facing string is hardcoded in the widget, and no caller passes label copy in.
  Failure case: a literal display string in the widget, or a `label`/`text` constructor
  parameter that lets two callers name the same status differently.

[1.2-AC11] L10N: Localisation keys exist for all six status labels in both `lib/l10n/intl_en.arb`
and `lib/l10n/intl_zh.arb`. `playing`, `completed`, `onHold` and `wishlist` already exist and
are reused as-is; keys for Backlog and Dropped are added to both files.
  Failure case: a key added to one `.arb` file only, or an existing key duplicated under a new
  name. (Code using a brand-new key does not compile until the Flutter Intl regen runs — that
  is expected, not a failure.)

[1.2-AC12] PRESENTATION: The count is an optional integer. When supplied it renders inside the
same capsule, after the label, and is rendered exactly as given — including `0`. The widget
never hides itself, hides the count, or substitutes a placeholder because the count is zero.
  Failure case: a supplied count is dropped, suppressed at zero, rounded, abbreviated, or
  rendered outside the capsule.

[1.2-AC13] PRESENTATION: The count renders de-emphasised relative to the label — 55% ink on
the five tinted statuses, full ink on the filled Playing pill — and meets §5's WCAG AA floor
against its own capsule fill at 11px.
  Failure case: the count matching the label's weight/colour so the two read as one word, or
  55% ink over the indigo fill (~3.1:1, below AA).

[1.2-AC14] PRESENTATION: With no count supplied, nothing renders in the count's place — no
placeholder, no separator, no reserved width — and the capsule shrinks to fit dot + label.
  Failure case: an empty count box widens the capsule or leaves a trailing gap.

[1.2-AC15] PRESENTATION: The widget adds no spacing of its own outside the capsule it draws —
no outer padding, margin or spacer, and no `EdgeInsets`, `padding` or gap constructor
parameter reintroducing it through the API. It renders flush within the bounds its parent
gives it; separation from neighbouring content belongs to the layout that places it, per
§1.3's "stacks use flex `gap`, never margins between siblings". The capsule's own interior
padding is the widget's anatomy and is expected.
  Failure case: any outer padding/margin/spacer baked in, or a spacing parameter on the
  constructor; conversely, a capsule with no interior padding so the dot and label touch its
  edge.

[1.2-AC16] PRESENTATION: The widget sizes to its content in both axes — it does not expand to
its parent's width, and it imposes no fixed width or height. A chip placed in a `Row` or as a
`Stack` overlay occupies only the width of dot + label + count + interior padding.
  Failure case: the chip stretching across an overlay or list row, or a hardcoded width.

[1.2-AC17] PRESENTATION: The chip is display-only — no `onTap`, no `InkWell`, no
`GestureDetector`, no hit-target expansion. A caller needing a tappable status wraps it.
  Failure case: a tap callback or ripple on the chip; or the chip padded out to 44px, which
  would break [1.2-AC15].

[1.2-AC18] PRESENTATION: Given less width than it needs, the label stays on one line and
ellipsises; the dot keeps its full diameter and never deforms; the count keeps its intrinsic
width and never truncates.
  Failure case: the capsule overflows its bounds, the label wraps to a second line, or the dot
  renders as an ellipse.

[1.2-AC19] PRESENTATION: All theme values are read through the project's context extension,
never `Theme.of(context)` directly.
  Failure case: a direct `Theme.of(context)` call in the widget.

[1.2-AC20] TESTS: Widget tests cover — each of the six statuses rendering its token dot
colour; Playing rendering the indigo fill with a white dot; the five tinted statuses rendering
the 8% ink fill in the list variant; the on-media variant rendering the 42% black fill with
blur applied; the 6px/7px dot difference between variants; the label rendering uppercase from
the `pill` token; a supplied count rendering, including `0`; no count widget present when none
is supplied. No golden test and no `matchesGoldenFile`, whatever the criteria above say about
appearance.
  Failure case: a new test failure beyond the recorded baseline, or a golden test added.

[1.2-AC21] DOCS: The `flutter-widgets` skill's reusable-widget catalogue gains a row for the
new widget, noting it adds no spacing of its own.
  Failure case: the catalogue still omits it, so the next agent rebuilds the same thing.

## Out of scope

- Rewiring any screen, and any change to `lib/widgets/saved_game_status_tag.dart` or its one
  caller (`lib/features/tracker/presentation/screens/tracker_game_detail_screen.dart`, which
  hardcodes `Status.notStarted` inside a no-op `InkWell`). That widget's `Status` enum is the
  legacy tracker set, not the six spec statuses; the migration is week 3's and the game-card
  status overlay is item 2.1's. Nothing is deprecated or deleted in this run.
- The filter surface that consumes the counts. §3.2's "a filter never reads as a dead end" is
  satisfied here only to the extent that the primitive can carry a count and never drops one
  ([1.2-AC12]); no filter row, no count aggregation, no data source, no filter navigation is
  built. That surface belongs to the Library screen and item 1.5's filter/count chip.
- The hero "status pill" in `home-screen-design-conventions.md` §Now-playing and
  `game-detail-design-conventions.md` §2 — a green-dot context pill on `rgba(0,0,0,.28–.34)`,
  which is §3.3's Context chip, item 1.6. Not this component despite the shared name.
- Cover tile (item 1.3), which will host the on-media variant, and the game card (item 2.1),
  which positions it bottom-left. This run ships the chip unplaced.
- The Add-to-library sheet's status selector and any library/tracker status domain model —
  week 3.
- New design tokens. The six status tokens, `pill` type token, `pill` radius, `ink08`, `ink55`
  and the glass-blur effect all exist and are reused as-is. The one value with no token,
  black at 42%, is spec'd literally in §3.3 and is Tech Lead's call whether to add a token
  or use the literal — either way it is logged in §6's local-additions register, which
  currently omits it.
- §1.8 press and hover treatments — non-interactive chip, Android-only target.
- Count abbreviation (§4's `2.4M`), screen-reader semantics, and iOS verification of any
  criterion.

## Assumptions

ASSUMPTION: §3.2's "8% ink" and §3.3's `rgba(0,0,0,.42)` + blur are one fill per variant, not
a contradiction — 8% ink is the list variant on a solid surface, the blurred black capsule is
the on-media variant over art (§1.6, and the blur-over-media rule in
`game-detail-design-conventions.md` §2).
ASSUMPTION: Playing stays filled indigo in both variants — filled is a per-status property in
the tokens, not a per-variant one.
ASSUMPTION: The filled pill's dot is white per §7.1 ("Playing white on indigo"), not the
status token's `color`, which would be an indigo dot on indigo.
ASSUMPTION: Label colour is unspecified; full ink in both treatments is the only value
clearing AA at 11px on both fills.
ASSUMPTION: Count colour is unspecified; 55% ink tinted / full ink filled, per §3.3's
filter-chip precedent and §5's AA floor.
ASSUMPTION: Interior padding is unspecified; §1.3 scale values — `4`/`8` on-media, `4`/`12`
list, `6` gap between dot, label and count.
ASSUMPTION: The count renders verbatim including `0`, unabbreviated — zero is exactly what
stops a filter reading as a dead end, and no formatting helper exists in the repo.
ASSUMPTION: The label is resolved inside the widget from the status value; the six statuses'
copy does not vary by caller, so a label parameter would only let callers drift.
ASSUMPTION: The chip is display-only; the interactive counterpart is item 1.5.
ASSUMPTION: §7.1/§6's "open decision" on violet and cyan status hues is stale —
`roadmap-deferred.md` records it RESOLVED 2026-07-30 and the tokens already encode it.
ASSUMPTION: This run ships the component unwired; the Week 2 checklist assigns rewiring-scope
decisions to items 2.1 and 2.5 only and is silent on 1.2.

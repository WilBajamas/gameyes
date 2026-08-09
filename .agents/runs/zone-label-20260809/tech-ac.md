# Technical Acceptance Criteria
Source: Week 2 task brief item 1.1 · `system-foundation-specs.md` §3.2 "Zone label" (with §1.2, §1.3, §1.9, §2.3) · build conventions from the `flutter-widgets` skill "Building a new reusable widget"
Date: 2026-08-09
BA Agent version: 1.0

## Feature summary

Add one app-wide presentation primitive for a zone (section) heading: a caps label in
the existing `zoneLabel` type token, optionally paired with a right-aligned tappable
link in the existing `zoneLink` token, and the vertical spacing that does the zone
separation. The pattern is currently unenforced — the type tokens exist but every
screen supplies its own header markup and spacing. The widget carries no rule, divider,
border, fill or numbering; spacing alone separates zones. No screen is rewired in this
run: the deliverable is the component, its tests, and its catalogue entry.

## Technical acceptance criteria

[1.1-AC1] PRESENTATION: A globally reusable zone-label widget exists under `lib/widgets/`,
named categorically for what it is, with no `default` name prefix, built from plain
Flutter widgets in the style of the existing hand-written `lib/widgets/` components, with
a `const` constructor and no new third-party package.
  Failure case: placed in a feature folder, `default`-prefixed, or written as a
  Widget-returning function/getter — reject at review.

[1.1-AC2] PRESENTATION: The label text is a required constructor input. The widget
contains no hardcoded user-facing string; localisation stays with the caller.
  Failure case: any literal display string inside the widget — reject at review.

[1.1-AC3] PRESENTATION: The label renders through the existing `zoneLabel` type token
(12px display face, weight 700, letter-spacing 2.16, 55% ink) and through that token's
uppercase formatting, so a caller passing `now playing` renders `NOW PLAYING`. The widget
declares no literal font size, weight, colour or letter-spacing, and reads theme values
through the project's context extension rather than `Theme.of(context)`.
  Failure case: a literal text style value, a re-declared duplicate token, or the label
  rendering in the caller's original casing.

[1.1-AC4] PRESENTATION: An optional trailing link renders on the same row as the label,
aligned to the trailing edge, styled from the existing `zoneLink` token (13px, weight 500,
link cyan). It renders only when both its text and its tap callback are supplied. A tap
invokes the callback exactly once. At most one link is supported.
  Failure case: link text supplied without a callback (or the reverse) renders a link;
  a tap fires the callback zero times or more than once.

[1.1-AC5] PRESENTATION: With no link supplied, the trailing position renders nothing —
no placeholder, no reserved width, no trailing gap — and the label occupies the full row.
  Failure case: an empty trailing box shifts or shortens the label.

[1.1-AC6] PRESENTATION: The link's tap target is at least 44px high, per §1.9's hit-target
floor, without changing the link's rendered text size.
  Failure case: the tappable region is smaller than 44px high, or the link's visual size
  grows to reach it.

[1.1-AC7] PRESENTATION: The widget renders no divider, horizontal rule, border, background
fill, shadow, index or numbering in any configuration — with a link and without.
  Failure case: any `Divider`, `Border`, `BoxDecoration` fill/shadow, or ordinal prefix
  appears in the widget's subtree.

[1.1-AC8] PRESENTATION: The widget owns the zone separation itself: 40 of vertical space
above the label and 16 below it, both from the §1.3 spacing scale, so a caller dropping it
into a column between two zones needs no additional spacer.
  Failure case: the widget renders flush with zero vertical space, or a caller has to add
  a spacer to reach the spec's separation.

[1.1-AC9] PRESENTATION: The widget adds no horizontal padding of its own; it fills the
width its parent gives it so the screen's 24px gutters apply unchanged.
  Failure case: the label indents differently from the zone content beneath it.

[1.1-AC10] PRESENTATION: A label longer than the available width stays on one line and
ellipsises; the link keeps its intrinsic width, never wraps, never truncates, and never
overlaps the label.
  Failure case: the row overflows, the label wraps to a second line, or the link is clipped.

[1.1-AC11] TESTS: Widget tests cover — uppercase rendering of a lower-case input; the
rendered label style matching the `zoneLabel` token; the rendered link style matching the
`zoneLink` token; link present when text + callback are supplied and absent when either is
missing; callback fired once on tap; no divider present. No golden test and no
`matchesGoldenFile`, whatever [1.1-AC7]/[1.1-AC8] say about appearance.
  Failure case: a new test failure beyond the recorded baseline, or a golden test added.

[1.1-AC12] DOCS: The `flutter-widgets` skill's reusable-widget catalogue gains a row for
the new widget.
  Failure case: the catalogue still omits it, so the next agent rebuilds the same thing.

## Out of scope

- Rewiring any existing screen. The hand-rolled headers in
  `lib/features/featured/presentation/widgets/` (countdown, releases, critics grid) are
  18px bold section headings, not this spec's zone label; items 2.3 and 2.8 own those
  sections. Nothing is deprecated or deleted in this run.
- Any Stage 2 component that will sit under a zone label (game card, countdown, status
  chips, empty states).
- New design tokens. `zoneLabel` and `zoneLink` already exist and must be reused as-is;
  no new colour, type or spacing token is added.
- Screen-reader header semantics — not in the spec, not invented here.
- §1.8 hover and focus treatments for the link. Android-only target, no hover to verify;
  the sanctioned green focus ring is a form-field concern (item 2.5).
- A suppressed-gap variant for the first zone on a screen, a second link slot, an icon
  slot, a count slot, or a leading glyph — no current caller.
- iOS verification of any criterion.

## Assumptions

ASSUMPTION: "Large vertical gap" is unnumbered in the spec; using 40 above and 16 below,
both from §1.3's 8px scale.
ASSUMPTION: The large gap sits above the label, the small one below, because the label
belongs to the content that follows it.
ASSUMPTION: Horizontal gutters belong to the screen frame (§1.3), so the widget adds none.
ASSUMPTION: The link requires both text and callback; the spec defines no non-tappable or
disabled link form.
ASSUMPTION: One link maximum, per §3.2's singular phrasing and §2.3's `See all` / `Calendar`
examples.
ASSUMPTION: Label ellipsises, link never truncates — long-content behaviour is unspecified.
ASSUMPTION: This run ships the component unwired; the Week 2 checklist assigns
rewiring-scope decisions to items 2.1 and 2.5 only and is silent on 1.1.

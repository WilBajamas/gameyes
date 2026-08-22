# Technical Acceptance Criteria
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar; `system-foundation-specs.md` §3.2 "Tab bar" row (with §1.7, §1.8, §1.9, §2, §5, §6); `home-screen-design-conventions.md` §6
Date: 2026-08-22
BA Agent version: 1.0

## Feature summary

Rework the app's bottom tab bar from stock Material `NavigationBar` chrome to the
spec'd onyx chrome: `#2E3236` background, five equal destinations, outline glyphs at
20px, always-visible 10/500 labels, indigo for the active destination with an 18×3
indigo cap above its glyph, 55% white for the rest. Selection, tap routing, the five
destinations and the routes behind them are unchanged. The bar's scroll-hide
behaviour is removed by product decision — it becomes static chrome that is always
visible. The bar's single caller (the Home shell) is rewired in the same item to stop
handing scroll state to it. Because the component moves off stock `NavigationBar`,
everything that widget supplied for free — selection visuals, semantics, tab-position
announcement, safe-area handling, tooltip, focus traversal, press feedback — must be
re-established explicitly and is criteria-covered below rather than assumed.

## Current state the criteria correct

Recorded because two of these are easy to reintroduce or to mistake for intended:

- **The destination colours are currently inverted against spec.** The unselected
  glyph is painted `colorScheme.primary` (indigo) and the selected glyph
  `Colors.grey[100]` — the exact opposite of §3.2 and §6, which make indigo the
  *active* signal. C13 fixes this; it is a correction, not a preference.
- **The dark theme already carries every token this component needs**, unused:
  `surfaceTabChrome` `#2E3236`, `accentIndigo` `#5865F2`, `ink55`, and a `tabLabel`
  type token at 10/500 sentence case. Nothing currently wires them, and there is no
  cap element at all.
- Today's five glyphs are filled Material icons, which §1.9 forbids outright.
- The bar is currently a stateful wrapper that collapses its own height to 0 on
  scroll-down. That behaviour is being removed — see `ambiguities.md` CRITICAL-1.

## Technical acceptance criteria

Every criterion is verifiable by a widget test unless its `Verification` line says
`manual device check`. Manual lines exist because this project never asserts pixel
dimensions, offsets, radii or painted appearance in a test, and never writes a golden
test — those go to `.agents/manual-check-backlog.md` at QA.

### Structure, routing and scope

**2.4-C1** [item 2.4 / ASSUMPTION-8] PRESENTATION: The bar renders exactly five
destinations, in the order Featured · Games · Tracker · Browse · Settings, each with
its existing localized label. No destination is added, removed, reordered, relabelled
or repointed at a different route by this item.
  Failure case: a destination is missing, duplicated, out of order, or shows a label
  or route other than the one it had before this item.
  Verification: widget test.

**2.4-C2** [item 2.4] PRESENTATION: Tapping a destination reports that destination's
zero-based index to the caller exactly once per tap. Tapping the glyph, the label, or
the empty padded area of a destination all produce the same result.
  Failure case: a tap reports nothing, reports a neighbouring index, reports twice, or
  only registers on the glyph.
  Verification: widget test.

**2.4-C3** [item 2.4] PRESENTATION: Which destination is selected is determined solely
by the selected-index value the caller passes in. The component stores no selection of
its own: rebuilding it with a different index moves the selected treatment to that
destination without any tap, and a tap alone does not change the visuals until the
caller supplies a new index.
  Failure case: the component tracks selection internally, so the visuals and the
  router can disagree — a tap that the router rejects still moves the highlight, or a
  route change made elsewhere leaves the old destination highlighted.
  Verification: widget test.

**2.4-C4** [item 2.4] PRESENTATION: Exactly one destination is in the selected state at
any time. Tapping the already-selected destination reports its index again and leaves
it selected; it never toggles off, and no state leaves all five unselected.
  Failure case: two destinations show the selected treatment at once, or re-tapping the
  active destination clears the highlight and the cap.
  Verification: widget test.

**2.4-C5** [CRITICAL-1 decision / §3.2 / home §6] PRESENTATION: The bar is static
chrome. It accepts no scroll, visibility or collapse input, reads no shared scroll
state, and does not animate its own height. Scrolling any tab's content in either
direction leaves all five destinations present and rendered identically.
  Failure case: the bar hides, shrinks, fades or clips during scroll; or the component
  fails to build in an environment where no scroll state is registered, which proves it
  is still reaching for one.
  Verification: widget test — pump the bar with no scroll state registered at all, then
  drag a scrollable body up and down and assert all five destinations remain.

**2.4-C6** [item 2.4 / CRITICAL-1 decision] PRESENTATION (Home shell): The Home shell
hands the bar only its selected index and its selection callback, and nothing about
scroll. The tab bodies it hosts are otherwise unchanged — the same five routes, the
same content, no change to how any tab scrolls.
  Failure case: the shell still wraps the bar in a scroll-driven container or passes it
  scroll state; or a tab's body stops scrolling, changes height behaviour, or loses its
  route.
  Verification: widget test.
  Deliberately NOT required here: the shell's own scroll-notification listener over the
  tab bodies stays exactly where it is, still writing scroll direction to a value
  nothing now reads. Removing it, its two sibling writers in other features, the
  singleton and its registrations is `ambiguities.md` FOLLOW-UP-1 and is out of scope
  for this item. "The bar stops listening" is this run; "the screen stops notifying" is
  not.

### Accessibility and input — the stock-`NavigationBar` regression surface

**2.4-C7** [§3.2 / home §6 / ASSUMPTION-1] PRESENTATION: Every destination renders its
text label at all times, selected or unselected. Selection never hides a label and no
label is deferred to a hover, tooltip or overflow state.
  Failure case: labels appear only on the selected destination, or only on unselected
  ones, or disappear at any text scale below the truncation threshold.
  Verification: widget test — all five label strings findable with the first
  destination selected and again with the last selected.

**2.4-C8** [§5] PRESENTATION: Each destination exposes an accessibility node carrying
its selected state — `selected` is true for the active destination and false for the
other four — and that state follows the caller-supplied index.
  Failure case: a screen reader announces no selected state, announces every
  destination as selected, or keeps announcing the previous destination as selected
  after the index changes.
  Verification: widget test.

**2.4-C9** [§5] PRESENTATION: Each destination announces its position as one of five,
1-based and in visual order, using the platform's localized tab-position phrasing
("Tab 3 of 5" in English). This is behaviour stock `NavigationBar` supplied and it must
survive the rework.
  Failure case: no position is announced, the count is wrong, positions are 0-based, or
  the phrasing is hardcoded English instead of localized.
  Verification: widget test.

**2.4-C10** [§1.9 / ASSUMPTION-1] PRESENTATION: The glyph inside a destination carries
no accessibility label of its own. Each destination announces its label exactly once —
these icons are label-paired (§1.9's exception list names the hamburger and circular
icon buttons, not the tab bar), so a glyph label would make a screen reader speak the
destination name twice.
  Failure case: the announcement contains the destination name twice, or the glyph
  surfaces as a separate focusable node beside its own label.
  Verification: widget test.

**2.4-C11** [item 2.4] PRESENTATION: Long-pressing a destination surfaces that
destination's label as a tooltip and does not change the selection or report an index.
  Failure case: a long-press selects the destination, shows an empty or wrong-text
  tooltip, or throws.
  Verification: widget test.

**2.4-C12** [§1.8 / §5] PRESENTATION: Keyboard focus traversal reaches all five
destinations in visual order and no other node inside the bar, and the focused
destination can be activated from the keyboard, reporting the same index a tap would.
  Failure case: traversal skips a destination, visits them out of order, traps focus
  inside the bar, or a focused destination cannot be activated without a pointer.
  Verification: widget test for order and activation. The focus indicator itself — a 2px
  green outline at 2px offset per §1.8, not clipped by the bar's edges — is a manual
  device check.

**2.4-C13** [§1.8 / ASSUMPTION-6] PRESENTATION: Pressing a destination gives §1.8's
press treatment — scale 0.97 with no colour change — and no Material ink ripple,
splash or highlight is painted at any point in the press. The ripple is replaced, not
simply removed: a press with no feedback at all fails this criterion.
  Failure case: an expanding ink circle or a hover/press fill appears behind a
  destination; or the destination gives no visible response to a press.
  Verification: manual device check.

### Chrome, tokens and layout

**2.4-C14** [§3.2 / home §6 / §1.5] PRESENTATION: The bar's background is the
`surfaceTabChrome` token (`#2E3236`). Separation from the canvas comes from that
lightness step alone — no border, no hairline, no shadow, no elevation tint on the
bar's surface.
  Failure case: the bar paints the canvas colour and becomes invisible against it, uses
  a Material elevation overlay, or grows a top border to compensate.
  Verification: widget test asserting the bar's fill is the `surfaceTabChrome` token —
  the colour is load-bearing, it is the whole separation mechanism.

**2.4-C15** [§3.2 / home §6] PRESENTATION: The selected destination's glyph and label
are `accentIndigo`; the four unselected destinations' glyph and label are `ink55`. This
is the reverse of the current code, which paints unselected glyphs indigo and the
selected glyph near-white.
  Failure case: indigo appears on an unselected destination, the selected destination
  renders in white/grey, or glyph and label within one destination disagree.
  Verification: widget test asserting selected uses `accentIndigo` and unselected uses
  `ink55` — indigo *is* the active-tab signal per §2's colour rationing, so the colour
  carries the meaning.

**2.4-C16** [§3.2 / home §6 / ASSUMPTION-2] PRESENTATION: A cap sits above the glyph of
the selected destination — 18 wide, 3 tall, fully rounded, `accentIndigo`. All five
destinations reserve that same space at all times; on the four unselected ones the cap
is transparent rather than absent, so glyphs and labels do not shift when selection
moves.
  Failure case: the cap renders on more than one destination, renders below the glyph,
  or is added and removed from the layout so the row jumps on every tab change.
  Verification: widget test that the cap element exists on all five destinations and is
  `accentIndigo` only on the selected one and transparent on the rest. Its 18×3 size,
  its fully-rounded ends, its position above the glyph and the absence of any shift on
  selection change are a manual device check.
  Note: 3px is a logged, intentional exception to the project's even-number convention
  — it is stated identically in both design sources and the cap is the sole visual
  signal of the active tab. If it is ever overruled, round up to 4, never down to 2.

**2.4-C17** [§3.2 / home §6] PRESENTATION: Labels use the `tabLabel` type token — 10px,
weight 500, sentence case, not uppercased and not restyled per selection state. Only
the colour changes between selected and unselected.
  Failure case: labels are uppercased, use a different size or weight, switch font
  family, or bold themselves when selected.
  Verification: widget test for the token; the rendered size and weight on device is a
  manual check.

**2.4-C18** [§1.9 / ASSUMPTION-5] PRESENTATION: Every glyph is outline-only at 20px, 2px
stroke, taking its colour from the destination's current state. No filled glyph appears
in the bar. Each destination keeps the concept its current glyph expresses — no
destination is reassigned a different symbol by this item.
  Failure case: any filled glyph survives; a glyph hardcodes its own colour and ignores
  selection state; or a destination's symbol changes concept.
  Verification: widget test that each destination's glyph is colour-driven by state and
  maps to the same destination as before. Outline-only drawing, the 20px size and the
  2px stroke are a manual device check.

**2.4-C19** [ASSUMPTION-3 / §5] PRESENTATION: The bar reserves the device's live bottom
safe-area inset beneath the destination row, and consumes it — no descendant re-applies
the same inset. Where that inset is zero, the bar falls back to 22 of bottom padding so
it never sits flush to the screen edge. Top padding is 8 and horizontal padding is 6.
  Failure case: labels sit under the home indicator on an inset device; the inset is
  applied twice and leaves a dead band under the labels; or the bar sits flush to the
  edge on a device with no inset.
  Verification: widget test that a descendant of the bar sees zero remaining bottom
  inset, and that the bar builds with the inset both zero and non-zero. Clearance from
  the home indicator on a real inset device is a manual device check.

**2.4-C20** [§5 / home §6 / §3.2] PRESENTATION: Each destination occupies an equal fifth
of the bar's width and presents a hit target of at least 44 in both dimensions,
including its padding, at default text scale.
  Failure case: destinations are unequal widths, or the tappable area is limited to the
  glyph and label bounds and falls under 44.
  Verification: manual device check.

**2.4-C21** [ASSUMPTION-4] PRESENTATION: A label too long for its slot stays on one line
and truncates with an ellipsis. It never wraps to a second line, never shrinks or
displaces its glyph, never changes the bar's height, and never resizes the other four
destinations. This is reachable today through the `zh` locale and through OS text
scaling, not only through long English copy.
  Failure case: a layout-overflow error at a raised text scale or in `zh`; a label
  wrapping to two lines; the bar growing taller; or one long label squeezing its
  neighbours.
  Verification: widget test that the bar renders with no overflow error in `zh` and at a
  raised text scale, with all five destinations still present. The ellipsis itself and
  the glyph's stability are a manual device check.

**2.4-C22** [§1.7 / home §6] PRESENTATION: A selection change animates at 140ms with the
standard ease and affects only the destination colours and the cap. Nothing about the
bar's size, position or background animates. All of it collapses to an instant change
when the platform requests reduced motion.
  Failure case: a selection change animates the bar's height or slides an indicator
  across it; the transition runs at the old 200ms collapse duration; or motion continues
  under reduced-motion.
  Verification: widget test that selection settles with no residual animation under
  reduced motion. The 140ms feel and the absence of any sliding indicator are a manual
  device check.

## Out of scope

- **The orphaned scroll notifier and its writers.** `ScrollNotifier`, its DI
  registration, the three writer sites (the Home shell's listener, `browse_screen.dart`,
  `settings_screen.dart`) and the registration in `settings_screen_test.dart` all stay
  exactly as they are. See `ambiguities.md` FOLLOW-UP-1. No criterion above touches
  `browse_screen.dart`, `settings_screen.dart`, the DI config or that test.
- **Renaming or re-scoping destinations.** §6's mockup names a different five (Home ·
  Library · Search · Feed · Profile); that belongs to the week 3 Library migration.
- **Light theme.** The app pins dark mode and §8 of the screen doc marks light as an
  unratified proposal.
- **Routing behaviour behind the tabs** — tab state preservation, back-button handling,
  deep links and nested navigator behaviour are untouched.
- **The Home screen's content.** Only its wiring to the bar changes.
- Golden tests, and any test asserting a pixel dimension, gap, radius, offset or painted
  position. Those are the manual device checks named above.

## Assumptions

ASSUMPTION-1: Labels always render on every destination in both states, and because
these icons are label-paired the glyph carries no semantic label of its own. Accepted as
settled rather than open — both design sources agree.
ASSUMPTION-2: The cap ships at 3px as a logged, intentional exception to the
even-number convention. If overruled, round up to 4, never down to 2.
ASSUMPTION-3: §6's literal 22px bottom padding is a mockup stand-in for the home
indicator on a fixed frame; the live safe-area inset is used instead, with 22 as the
fallback when that inset is zero. The 8 top and 6 horizontal paddings are literal.
ASSUMPTION-4: An over-long label truncates on one line with an ellipsis — never wraps,
never shrinks the glyph, never reflows its neighbours.
ASSUMPTION-5: Each destination keeps its current concept; only the drawing style changes
to outline-only 20px.
ASSUMPTION-6: The ink ripple is replaced, not merely dropped — §1.8's 0.97 press scale
takes its place, and focus becomes §1.8's green outline.
ASSUMPTION-7: Dark appearance only.
ASSUMPTION-8: Destination count, order, labels, glyph-to-route mapping and the routing
behind them are unchanged by this item.

# Ticket — Welcome screens polish + global system UI convention (item 6.2)

Source: Product owner manual verification of item 6.1 (`5bd84e8`,
`feature/welcome-screens-header-rework`, not yet merged). Ticket ID `W1-6.2R`.
Continues directly on that same branch — this is a refinement of the same
screens, not a new feature.

## Context

Manual testing of item 6.1's flat-PNG hero rework surfaced four issues: the
hero images sit flush against the panel edges with no padding; the hero panel
takes up roughly half the screen height (400px / 356px of a 714px reference)
when it should read closer to a third; neither welcome screen implements
`SafeArea`, and the system status/navigation bars aren't styled to match the
screen; and there is no way to move between the two screens by swiping, only
by tapping Next.

## Requirements

1. **Hero content padding.** The centred content image
   (`welcome-1-header.png` / `welcome-2-header.png`) currently touches the
   hero panel's edges on both axes. Add padding inside the hero so the image
   has breathing room on every side. Pick a value consistent with the existing
   8px spacing scale (`system-foundation-specs.md § 1.3`) — this is not
   pinned to an exact number, use judgement and it will be reviewed at the
   human design gate.
2. **Hero height, roughly a third of the screen.** Current heights (400 /
   356, against a 714 reference) read as roughly half. Reduce both to
   approximately a third of the reference height, keeping the existing
   ratio-driven relationship between screen 1 and screen 2 (screen 1 taller
   or equal). Exact numbers are a design-review judgement call, not pinned
   here — this explicitly supersedes the height values in
   `.agents/runs/welcome-screens-20260802/tech-ac.md` (`[W1-6.12]`, which the
   6.1 ticket had already partially amended) and in
   `.agents/references/onboarding-welcome-design-spec.md § 3`. Update that
   design spec's height table to match whatever value is implemented, so it
   stops documenting a value the app no longer uses.
3. **`SafeArea`, and a matching system UI style — as a global app-wide
   default, not scoped to onboarding.** Neither welcome screen currently
   wraps its content in `SafeArea`. Fix that on both. Separately, and
   confirmed in scope for this run even though it's cross-cutting: set the
   app's system UI overlay style once, at the app's bootstrap/theme setup, so
   it applies everywhere — status bar transparent (so a screen's own top
   content, hero or otherwise, shows through rather than sitting under an
   opaque bar), and the bottom system gesture/navigation bar area coloured to
   match **the current screen's own canvas colour**, not a fixed brand
   colour — practically, since the app's canvas is onyx `#23272a` almost
   everywhere already, this will look identical to today except where a hero
   panel sits at the very top or bottom edge of a screen. This is a new
   standing convention: it needs recording in `project-conventions.md` or
   `flutter-arch.md` (Tech Lead's call which) so every future screen follows
   it, not just these two.
4. **Horizontal swipe between the two welcome screens, alongside the existing
   buttons.** Add a `PageView`-based (or equivalent) horizontal swipe so a
   user can move between welcome screen 1 and 2 by dragging, in addition to
   the existing Next / Skip / Get started buttons — none of which are
   removed or change behaviour. The progress-dot indicator's active state
   changes when the visible page changes (by either swipe or button), but the
   dots themselves render as a static, non-animating indicator — they do not
   interpolate or visually track the swipe gesture's in-progress drag
   position, they just reflect whichever page is currently settled.
   **This explicitly supersedes `[W1-6.31]`** from
   `.agents/runs/welcome-screens-20260802/tech-ac.md`, which currently
   forbids "parallax, spring, or scroll-jacking" for screen transitions — a
   swipeable page view is precisely that, and the reversal is intentional,
   confirmed by the product owner.

## Confirmed decisions (do not re-litigate, do not escalate)

- System bar colour is the **screen's own canvas colour**, not a fixed brand
  colour token.
- The system UI convention from requirement 3 is a **global default**,
  touching the app's bootstrap/theme setup, not a per-screen fix.
- Swipe navigation is **additive** — Next, Skip, and Get started all keep
  working exactly as they do today; nothing about their behaviour changes.
- **The onboarding-seen persistence flag's rules are unchanged.** Reaching
  screen 2 by any means — tapping Next or swiping — never writes it. Only an
  explicit Skip (screen 1) or Get started (screen 2) tap writes it, exactly
  as `[W1-6.36]`–`[W1-6.39]` from the original item-6 criteria already
  specify. Swiping backward from screen 2 to screen 1 remains possible and
  writes nothing either. These four criteria are carried forward unchanged;
  do not re-derive them.

## Out of scope

- Any other screen's `SafeArea` or system-UI treatment beyond setting the
  global default — auditing every existing screen against the new default is
  a separate concern, not this run's.
- Any change to the hero's fill/background handling (colour vs. image),
  border radius, or the content-image `BoxFit`/centering behaviour — item
  6.1 already settled those; this run only adds padding and changes the
  height.
- Any change to the three PNG assets themselves.
- Any change to the localisation keys, the token layer, or the token-to-image
  handoff logic.

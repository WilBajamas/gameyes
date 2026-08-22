# Ambiguities Report
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar; `system-foundation-specs.md` §3.2 "Tab bar" row (with §1.9, §1.8, §2, §5, §6); `home-screen-design-conventions.md` §6
Date: 2026-08-22

## CRITICAL (pipeline blocked — requires human decision before proceeding)

CRITICAL-1: item 2.4 — the shipped bar hides itself on scroll, and no spec says whether that survives the rework.

  `ScrolledNavigationBar` is not just a chrome wrapper. It listens to a global
  `ScrollNotifier` and animates its own height to 0 over 200ms when the user scrolls
  down, back to full height when they scroll up. That is live behaviour on the
  shipped Home shell, on all five tabs.

  Neither design source addresses it. §3.2's row describes static chrome and no
  scroll response. `home-screen-design-conventions.md` §6 says "Fixed to the bottom
  of the frame", which reads as a position statement about an HTML mockup — the same
  doc §2 separately and deliberately documents that the *header* scrolls away, so
  "fixed" here is at least suggestive, but it is not a decision about a hide-on-scroll
  interaction that the doc never saw.

  This is not only a visual question. It decides the run's blast radius. `ScrollNotifier`
  is written from three places — the Home shell's `NotificationListener` (which wraps
  every tab's body), `browse_screen.dart` and `settings_screen.dart` — and is read from
  exactly one, the bar itself. Drop the behaviour and all three writers, the singleton,
  its DI registration and a registration in `settings_screen_test.dart` become dead
  weight in files outside this item's component.

  Options:
    A) Drop it. The bar is permanently visible; the rework is pure chrome. Sub-decision:
       does this run also remove the now-unread `ScrollNotifier` and its three writers
       (two of which are other features), or does it leave them in place and file a
       follow-up?
    B) Keep it. The new chrome ships inside the same collapse animation; `ScrollNotifier`
       and all writers untouched. Tech Lead must then design a stateful component, not a
       stateless one, and the collapse must not clip the new cap or the safe-area inset.

  Recommended: A, with the dead `ScrollNotifier` and its writers left in place and filed
  as a follow-up rather than cleaned up here — removal keeps this item to the tab bar's
  own two files, and both design docs describe chrome that does not move. Recommended
  only weakly: option B is the strictly smaller change and nothing in either doc
  explicitly forbids the interaction.

  Decision needed from: Product Owner

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION-1: Labels always render, on every destination, selected or not. §3.2 and
`home-screen-design-conventions.md` §6 both require it, and §6 gives the reason ("five
destinations is too many to teach by glyph alone"). §5 does permit tab-bar icons to go
unlabelled, but that clause is a licence, not an instruction, and this component declines
it; §1.9's own exception list names the hamburger and circular icon buttons, not the tab
bar. Note that §1.9 therefore treats these icons as label-paired, so the glyph must not
carry a semantic label of its own that would double the spoken text.

ASSUMPTION-2: The active cap ships at 3px, as an intentional spec-driven exception to the
project's even-number convention, logged as such. Stated identically in two sources (§3.2
"a 3px cap", §6 "18 × 3px"), and unlike the two prior collisions with this convention
(item 2.2's 15px type step, item 1.9's 15px gap) the cap is the sole visual signal of which
tab is active, where a 1px change is a third of the element. Alternatives, if the human
prefers the convention to bind: round **up** to 4px, not down to 2px — 2px on an 18px bar
reads as a hairline and the system reserves hairlines for dense structures (§1.5). Flagging
because the convention is standing and this is new code; overrule this in the same
round trip as CRITICAL-1 if you disagree.

ASSUMPTION-3: The 22px bottom padding in §6 is the mockup's stand-in for the home indicator
on a fixed 390×844 frame, not a literal. The bar reserves the device's live bottom safe-area
inset instead, and falls back to 22px when that inset is zero so the bar never sits flush to
the screen edge. The 8px top and 6px horizontal padding are taken literally.

ASSUMPTION-4: A label too long for its slot renders on one line and truncates with an
ellipsis. It never wraps to a second line, never shrinks the glyph, and never shortens the
bar's other destinations. This is reachable today via the `zh` locale and via OS text
scaling, not only via long English copy.

ASSUMPTION-5: Each destination keeps the concept its current glyph expresses; only the
drawing style changes, to an outline-only 20px glyph per §1.9. No destination is reassigned
a different symbol as part of this item. Today's five are filled Material glyphs, which §1.9
forbids outright.

ASSUMPTION-6: Material's ink ripple is replaced rather than simply dropped. Tap feedback
becomes §1.8's press treatment — scale 0.97, no colour change — and focus becomes §1.8's
2px green outline at 2px offset. Losing the ripple with nothing in its place would leave the
control with no press affordance at all.

ASSUMPTION-7: Dark appearance only. `main.dart` pins `ThemeMode.dark`, and §8 of the screen
doc marks light theme as an unratified proposal, so no light-mode treatment for this chrome
is specified or built.

ASSUMPTION-8: Destination count, order, labels, icons-to-route mapping and the routing
behaviour behind them are unchanged by this item. The five stay Featured · Games · Tracker ·
Browse · Settings, in that order, even though §6's mockup names a different five
(Home · Library · Search · Feed · Profile) — that renaming belongs to the week 3 Library
migration, not to a chrome rework.

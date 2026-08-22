# Ambiguities Report
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar; `system-foundation-specs.md` §3.2 "Tab bar" row (with §1.9, §1.8, §2, §5, §6); `home-screen-design-conventions.md` §6
Date: 2026-08-22 (updated 2026-08-22 after the human decision — CRITICAL-1 cleared)

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE — CRITICAL-1 was resolved by the human on 2026-08-22. `tech-ac.md` is written.

### CRITICAL-1 (RESOLVED 2026-08-22) — scroll-hide behaviour

Original question: the shipped bar hides itself on scroll (an `AnimatedContainer`
collapsing its height to 0 over 200ms, driven by the `getIt` `ScrollNotifier`
singleton, live on the Home shell for all five tabs), and neither design source says
whether that survives the rework.

**Decision: DROP the scroll-hide behaviour. The bar becomes static chrome** —
permanently visible, never animating its own height, reading no scroll state.

Rationale, recorded so a later session does not misread it:

- §3.2's "Tab bar" row describes static chrome and specifies no scroll response.
- `home-screen-design-conventions.md` §6 opens with "Fixed to the bottom of the
  frame", and the same doc §2 separately and deliberately documents the *header*
  scrolling away — so the doc does distinguish the two, and puts the bar on the
  fixed side.
- **This is a deliberate, visible behaviour change on a shipped screen, not an
  oversight and not a regression.** Users lose the extra content height they get
  while scrolling down today. Anyone who later finds a static bar where git history
  shows a collapsing one is looking at an intentional product decision — do not
  "restore" it without a new decision.

## FOLLOW-UP (deliberately not done in this run — pick up as its own item)

FOLLOW-UP-1: dropping the scroll-hide leaves `ScrollNotifier` with writers and no
reader. The bar was its only reader. **Nothing below is touched by item 2.4** — same
call item 2.1 made on `PlatformRowList`: a component run does not widen into
unrelated files. What goes dead the moment this item ships:

- `lib/features/home/presentation/notifier/scroll_notifier.dart` — the singleton
  itself, now written but never read.
- its `@injectable` registration in the generated `service_locator.config.dart`.
- `lib/features/home/presentation/screens/home_screen.dart:61` — the
  `NotificationListener<UserScrollNotification>` wrapping every tab body, which
  still computes and pushes scroll direction into the notifier.
- `lib/features/browse/.../browse_screen.dart:19` — second writer, another feature.
- `lib/features/settings/.../settings_screen.dart:26` — third writer, another feature.
- `test/widget/.../settings_screen_test.dart:38` — the `ScrollNotifier` registration
  that exists only to keep that screen pumpable.

Removing them is a five-file change across three features plus DI regeneration, and
it is not verifiable by anything in this item's criteria. File it as its own cleanup
item. Until then the notifier keeps running harmlessly — a small amount of wasted
work per scroll frame, no user-visible effect.

Note the nuance already reflected in `tech-ac.md`: `home_screen.dart` **is** in scope
for this item as the bar's single caller — it must stop handing scroll state to the
bar. "The bar stops listening" is required now; "the screen stops notifying" is this
follow-up. They are two separate decisions and only the first is in this run.

## ASSUMPTIONS (minor — pipeline may proceed)

All eight accepted as written by the human on 2026-08-22 and carried into
`tech-ac.md`.

ASSUMPTION-1: Labels always render, on every destination, selected or not. §3.2 and
`home-screen-design-conventions.md` §6 both require it, and §6 gives the reason ("five
destinations is too many to teach by glyph alone"). §5 does permit tab-bar icons to go
unlabelled, but that clause is a licence, not an instruction, and this component declines
it; §1.9's own exception list names the hamburger and circular icon buttons, not the tab
bar. Note that §1.9 therefore treats these icons as label-paired, so the glyph must not
carry a semantic label of its own that would double the spoken text.
  *Accepted 2026-08-22 as **settled, not an open assumption**. The two design sources
  agree and §1.9's exception list is explicit; there is nothing here for a later session
  to reopen. Carried into `tech-ac.md` as criteria, not as an assumption.*

ASSUMPTION-2: The active cap ships at 3px, as an intentional spec-driven exception to the
project's even-number convention, logged as such. Stated identically in two sources (§3.2
"a 3px cap", §6 "18 × 3px"), and unlike the two prior collisions with this convention
(item 2.2's 15px type step, item 1.9's 15px gap) the cap is the sole visual signal of which
tab is active, where a 1px change is a third of the element. Alternatives, if the human
prefers the convention to bind: round **up** to 4px, not down to 2px — 2px on an 18px bar
reads as a hairline and the system reserves hairlines for dense structures (§1.5). Flagging
because the convention is standing and this is new code; overrule this in the same
round trip as CRITICAL-1 if you disagree.
  *Accepted 2026-08-22: **ships at 3px as a logged exception** to the even-number
  convention. Not overruled. If it is ever overruled later, round UP to 4, never down
  to 2.*

ASSUMPTION-3: The 22px bottom padding in §6 is the mockup's stand-in for the home indicator
on a fixed 390×844 frame, not a literal. The bar reserves the device's live bottom safe-area
inset instead, and falls back to 22px when that inset is zero so the bar never sits flush to
the screen edge. The 8px top and 6px horizontal padding are taken literally.
  *Accepted 2026-08-22.*

ASSUMPTION-4: A label too long for its slot renders on one line and truncates with an
ellipsis. It never wraps to a second line, never shrinks the glyph, and never shortens the
bar's other destinations. This is reachable today via the `zh` locale and via OS text
scaling, not only via long English copy.
  *Accepted 2026-08-22.*

ASSUMPTION-5: Each destination keeps the concept its current glyph expresses; only the
drawing style changes, to an outline-only 20px glyph per §1.9. No destination is reassigned
a different symbol as part of this item. Today's five are filled Material glyphs, which §1.9
forbids outright.
  *Accepted 2026-08-22.*

ASSUMPTION-6: Material's ink ripple is replaced rather than simply dropped. Tap feedback
becomes §1.8's press treatment — scale 0.97, no colour change — and focus becomes §1.8's
2px green outline at 2px offset. Losing the ripple with nothing in its place would leave the
control with no press affordance at all.
  *Accepted 2026-08-22.*

ASSUMPTION-7: Dark appearance only. `main.dart` pins `ThemeMode.dark`, and §8 of the screen
doc marks light theme as an unratified proposal, so no light-mode treatment for this chrome
is specified or built.
  *Accepted 2026-08-22.*

ASSUMPTION-8: Destination count, order, labels, icons-to-route mapping and the routing
behaviour behind them are unchanged by this item. The five stay Featured · Games · Tracker ·
Browse · Settings, in that order, even though §6's mockup names a different five
(Home · Library · Search · Feed · Profile) — that renaming belongs to the week 3 Library
migration, not to a chrome rework.
  *Accepted 2026-08-22.*

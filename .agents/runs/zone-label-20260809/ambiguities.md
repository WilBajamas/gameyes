# Ambiguities Report
Source: Week 2 task brief item 1.1 + `system-foundation-specs.md` §3.2 "Zone label" (with §1.2, §1.3, §1.9, §2.3)
Date: 2026-08-09

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

## ASSUMPTIONS (minor — pipeline may proceed)
ASSUMPTION: "A large vertical gap" is not given a number. Using the top of the 8px
spacing scale (§1.3): 40 above the label, 16 between the label and the zone's first
content. Both come from the sanctioned scale, so a later correction is a token swap,
not a rework.

ASSUMPTION: The gap sits above the label (separating this zone from the previous one),
with the smaller step below it, since the label belongs to the content that follows it.

ASSUMPTION: No "first zone on screen" variant (suppressed top gap) is built — nothing
calls it yet, and §1.3 already gives screens a 56px top frame. Add it when a screen
needs it.

ASSUMPTION: Horizontal padding is the caller's. §1.3 puts 24px gutters on the app frame,
so the widget adds none of its own.

ASSUMPTION: The optional link needs both its text and its tap callback; supplying one
without the other renders no link. Spec calls it optional but does not define a
non-tappable or disabled form.

ASSUMPTION: One link maximum, per §3.2's singular "optional right-aligned cyan link"
and §2.3's paired `See all` / `Calendar` examples.

ASSUMPTION: Long-label behaviour is unspecified. The label takes the remaining width and
ellipsises on one line; the link keeps its intrinsic width and never truncates — a
truncated `See all` reads as broken, a truncated zone name does not.

ASSUMPTION: §1.8's hover treatment (75% opacity + underline) is not built. Android-only
target per `project-conventions.md`, so there is no hover state to verify.

ASSUMPTION: Screen-reader header semantics are not spec'd and not added — noted as out of
scope rather than invented here.

ASSUMPTION: This run ships the widget with no screen rewired. The hand-rolled headers in
`featured` (countdown, critics grid, releases) are 18px bold section headings, not this
spec's 12px caps zone label; converting them changes those screens' visuals and collides
with items 2.3 and 2.8, which already own rewiring those sections. The Week 2 checklist
assigns rewiring-scope decisions to items 2.1 and 2.5 only, and says nothing about 1.1 —
so the narrow reading is component-only.

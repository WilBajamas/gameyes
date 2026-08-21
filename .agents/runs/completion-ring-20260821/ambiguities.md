# Ambiguities Report
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.2 — Completion ring
(spec `.agents/references/system-foundation-specs.md` §3.2, §2)
Date: 2026-08-21

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

Rewiring scope is not an ambiguity on this run: the checklist states there is no
caller and that shipping unwired is correct, and a grep confirms no ring widget
exists. Nothing is deferred, nothing is rebuilt.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: `system-foundation-specs.md` §3.2 says the ring is "indigo the whole way
up"; `home-screen-design-conventions.md` §3.1 specifies the same 60px ring with a pure
white arc on a 24% white track because it sits on the Home hero's indigo art. Building
§3.2's indigo/magenta component only, since the checklist names §3 as the source of
truth for what to build. The white-on-media variant is listed under `tech-ac.md`
`## Out of scope` and is a Home-screen decision in week 3/4 — worth knowing it exists so
it is not read then as a defect in this component.

ASSUMPTION: The 80px specimen size has no documented stroke, radius or centre type size.
Assuming an 8px stroke inset 2px from the box edge (the geometry both documented sizes
share: 88 is r38 + 8 stroke, 60 is r25 + 6 stroke) and an 18px display 700 centre number
— the app-scale "Stat figure" step in §1.2, sitting between the documented 15 and 22.

ASSUMPTION: Edge values are unspecified in the requirement. Assuming: below 0 clamps to
0; above 100 clamps to 100 and renders identically to 100; out-of-range never throws or
asserts; the value is required and non-nullable with no indeterminate state, so "no
recorded completion" is 0.

ASSUMPTION: Non-integer values are unspecified. Assuming the arc uses the exact fraction
and the label truncates toward zero, so `99.6` reads `99%`. This keeps the label and the
magenta close in agreement — `100%` and magenta both mean exactly 100, never "almost".

ASSUMPTION: The detail panel stacks `68%` over a `done` sub-label; the 60px inline ring
shows the number alone. Assuming the caption is an optional caller-supplied line rendered
only at 80 and 88, and dropped at 60 even when supplied, rather than fixed component
text or a per-size copy rule.

ASSUMPTION: No screen-reader copy is specified. Assuming `<n>% complete` as the semantics
label, mirroring the same clamped, truncated value as the visible text.

ASSUMPTION: Motion is unspecified for this component. Assuming no animation in v1 — no
sweep-in entrance, no tween between values, and therefore nothing to collapse under
`prefers-reduced-motion`.

## Notes for the Tech Lead

Sizes: all three (60 / 80 / 88) are stated in `tech-ac.md` as **fixed** outer boxes, not
minimums. Item 2.1's `md` 220 had to be downgraded to a design reference because it did
not fit a two-column phone grid; none of these three is anywhere near that pressure, so
no equivalent downgrade should be accepted here.

Testability split, called out because a custom-painted ring invites unverifiable
criteria: C5, C6, C7, C8, C10, C11, C13 and C14 are real widget tests (label text,
clamping, the indigo→magenta switch by token, caption presence per size, semantics). C1's
numbers, C4's arc geometry, C9's stroke, and C12's type steps are manual device checks —
no test may assert them and no golden test exists to cover them.

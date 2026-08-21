# Technical Acceptance Criteria
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.2 — Completion ring
(anatomy from `.agents/references/system-foundation-specs.md` §3.2 "Completion ring",
§1 foundations, §2 colour law; per-size numbers from
`.agents/references/game-detail-design-conventions.md` §"Your run" panel and
`.agents/references/home-screen-design-conventions.md` §3.1)
Date: 2026-08-21
BA Agent version: 1.0

## Feature summary

Build a new display-only completion ring: a circular track with a proportional arc
over it and the completion percentage in the display face at its centre. Three fixed
sizes — 60 inline, 80 specimen, 88 detail panel — one anatomy, sized rather than
redrawn. The arc is indigo for every value below 100 and closes as a full magenta ring
at exactly 100, matching the Completed status dot. The component renders only the value
it is handed: it derives nothing, fetches nothing, and has no interactive or error
behaviour. It ships with no caller — this is groundwork for the week 3/4 Game Detail
screen, so no screen is wired, rewired, or assumed.

**Verification convention for every criterion below.** Widget tests never assert
dimensions, gaps, radii, stroke weights, offsets or positions; colour assertions must
carry meaning and name a token; golden tests are never written. Every criterion carries
a `Verify:` line naming its real check. Where that line says `manual device check`, the
number in the criterion is the contract and QA confirms it on device — no test may
enforce it. A custom-painted ring puts most of its *appearance* in that manual bucket
(stroke weight, cap shape, arc geometry); its *behaviour* — value→sweep mapping,
clamping, the label, the colour switch at 100 — is testable and must be tested.

## Technical acceptance criteria

### Structure and sizes

[2.2-C1] Presentation — shared widget: The ring exposes exactly three sizes and no
other. Their outer boxes are **fixed, not minimums**: 60×60 inline, 80×80 specimen,
88×88 detail panel. A caller selects one of the three; it cannot pass an arbitrary
diameter.
  Verify: widget test pumping each of the three sizes; the three numbers themselves are
  a manual device check.
  Failure case: a caller that needs a fourth diameter is a spec change and escalates —
  the component is not given a free-form size input and no caller hand-rolls a ring.

[2.2-C2] Presentation — shared widget: All three sizes render the same anatomy in the
same order — circular track, progress arc painted over the track, percentage text
centred inside the ring. Nothing is structurally added or removed per size except the
optional caption (C13) and the centre type step (C12).
  Verify: widget test asserting the percentage text renders at each of the three sizes.
  Failure case: a per-size bespoke anatomy violates §0 principle 1 (one anatomy, sized
  rather than redrawn) and is rejected in review.

[2.2-C3] Presentation — shared widget: The ring occupies its own square box and never
sizes itself from its parent's constraints. It renders without an overflow or layout
exception inside an unbounded parent (a `Row`/`Column` with no width) and inside a
loose-constrained parent.
  Verify: widget test pumping the ring in an unbounded parent and expecting no thrown
  exception.
  Failure case: a ring that stretches or collapses with its parent is not shipped —
  item 2.1's `md` 220 downgrade came from exactly this, and all three ring sizes are
  small enough that no downgrade to "design reference" is accepted here.

### Value, sweep and edge values

[2.2-C4] Presentation — shared widget: The arc sweep is directly proportional to the
clamped value: 0 paints no arc at all (track only), 100 paints a full 360°, and
intermediate values paint the same fraction of the circle. The sweep starts at 12
o'clock and runs clockwise at every size.
  Verify: manual device check at 0 / 25 / 50 / 75 / 100; the clamped value that drives
  the sweep is covered by C5–C7.
  Failure case: an arc that starts anywhere but 12 o'clock, runs anticlockwise, or
  paints a visible cap dot at 0 is wrong — 0% must read as an untouched track.

[2.2-C5] Presentation — shared widget: Values outside 0–100 clamp. A value below 0
renders exactly as 0 does; a value above 100 renders exactly as 100 does, magenta
closed ring and `100%` label included. No assertion, no exception, no debug-only
guard.
  Verify: widget test asserting `-5` renders the `0%` label and `140` renders the `100%`
  label and resolves the magenta token.
  Failure case: an out-of-range value must never throw or paint an arc past a full
  circle — a caller passing bad data gets a sane ring, not a crash.

[2.2-C6] Presentation — shared widget: A non-integer value keeps its fraction for the
arc, but the label truncates toward zero — `99.6` renders `99%`. `100%` appears in the
label only when the clamped value is exactly 100, so the label and the magenta close
(C8) always agree.
  Verify: widget test on the label text for `99.6`, `0.4` and `100`.
  Failure case: a rounded `100%` label on an indigo ring is a contradiction and is
  treated as a defect, not a rounding preference.

[2.2-C7] Presentation — shared widget: The value is required and non-nullable. The
component has no unknown, indeterminate or loading state; a caller with no recorded
completion passes 0 and gets a track-only ring reading `0%`.
  Verify: widget test that 0 renders `0%` with no arc-bearing state; the absence of a
  nullable/indeterminate input is a compile-time contract confirmed in review.
  Failure case: a null-shaped "unknown" mode is not added on request — an unknown
  completion is the caller's decision to not render a ring.

### Colour

[2.2-C8] Presentation — shared widget: For every clamped value below 100 the arc is the
`accentIndigo` token. At exactly 100 the whole ring is the `accentMagenta` token,
matching the Completed status dot. This switch is a stated contract of the component,
not a painting detail: one flat colour at a time, no gradient, no blend or transition
across the arc.
  Verify: widget test asserting the ring's progress colour resolves to `accentIndigo` at
  99 and `accentMagenta` at 100 — the switch, not the pixels.
  Failure case: a ring that stays indigo at 100, or turns magenta before 100, breaks the
  §2 colour law reading of magenta as completion and does not ship.

[2.2-C9] Presentation — shared widget: The track is the `ink12` token at every size and
every value, drawn as a continuous solid stroke for the full circle. It is never dashed
or dotted (§0 principle 6) and is never recoloured by value; at 100 it is simply covered
by the magenta ring.
  Verify: widget test asserting the track colour resolves to `ink12`; stroke weight and
  cap shape are a manual device check.
  Failure case: a dashed or value-dependent track is rejected in review.

[2.2-C10] Presentation — shared widget: Magenta appears in this component only as the
100% close. The ring has no error, failure or warning state, and no value recolours it
red or reuses magenta for anything but completion (§2 colour law rule 2).
  Verify: widget test that no value below 100 resolves the magenta token; code review
  for the absence of any error path.
  Failure case: a future request to flag a failed sync on the ring is a spec change and
  escalates — red never enters this component.

### Centre display

[2.2-C11] Presentation — shared widget: The percentage is rendered at all three sizes,
always. The arc is never the only carrier of the value. Format is the truncated integer
immediately followed by `%`, no decimals and no space, in the display face at 700.
  Verify: widget test asserting the exact label string at each size.
  Failure case: suppressing the number at the 60 inline size to buy room is not
  permitted — dropping it breaks the accessibility contract in
  `game-detail-design-conventions.md` §7.

[2.2-C12] Presentation — shared widget: The centre percentage steps with size — 15 at
inline, 18 at specimen, 22 at detail panel — display face 700 in ink.
  Verify: manual device check.
  Failure case: one shared type size across all three renders the detail panel's number
  undersized and the inline number cramped; the ring is not shipped with a single step.

[2.2-C13] Presentation — shared widget: A short caption line beneath the percentage
(`done` in the detail panel) is optional. It renders at the specimen and detail sizes
when the caller supplies one, is absent when the caller supplies none, and is dropped at
the 60 inline size even when supplied — 60 carries the number alone. Caption is 10, in
`ink55`.
  Verify: widget test pumping the same caption at all three sizes and asserting it is
  found at 80 and 88 and not found at 60; its type size and colour token are a manual
  device check beyond the token assertion.
  Failure case: a caption squeezed into the 60 ring pushes the percentage below legible
  size — the drop is deliberate behaviour, not a bug to "fix" later.

### Accessibility and interaction

[2.2-C14] Presentation — shared widget: The ring exposes a semantics label carrying the
value and its meaning — `37% complete` — so a screen reader conveys progress without the
arc. The label reflects the same truncated, clamped value as the visible text.
  Verify: widget test asserting the semantics label for a mid value, for a clamped
  out-of-range value, and for 100.
  Failure case: a ring announced only as its raw text, or not announced at all, fails
  §5 and does not ship.

[2.2-C15] Presentation — shared widget: The ring is display-only. It takes no tap
callback, exposes no gesture, holds no internal state, and is not a hit target — so the
44px minimum-target rule does not apply to it and none of the three sizes is inflated to
meet it.
  Verify: widget test that tapping it triggers nothing; code review for the absence of a
  callback input.
  Failure case: making the ring tappable is a screen-level decision for whatever wraps
  it later, not a change to this component.

## Out of scope

- **Any caller, screen or wiring.** No ring exists in the codebase today and no screen
  consumes this one. It ships unwired by the checklist's explicit decision; nothing is
  rewired and no integration behaviour is specified or assumed.
- **The white-on-media ring variant.** `home-screen-design-conventions.md` §3.1 puts a
  pure-white arc on a 24% white track inside the Home hero card. §3.2 — this item's
  named source of truth — says indigo. Only the indigo/magenta component is built; the
  on-media variant is a Home-screen decision when Home is designed and built (see
  ASSUMPTION-1).
- **Animation.** No sweep-in entrance, no tween between values, no
  `prefers-reduced-motion` handling — a value change renders the new arc immediately.
- **An indeterminate / unknown-progress mode** (see C7).
- **Deriving completion from data.** Playtime, sessions, achievements and the Completed
  status all belong to the caller; the component receives a number.
- **The detail panel's Completed variant** (`game-detail-design-conventions.md` open
  decision 4 — full ring plus a changed CTA). That is a screen composition, not this
  component.
- **Pixel verification of the painted arc.** Stroke weight, cap shape, inset and arc
  geometry are QA manual device checks; no golden test is written for any of them.

## Assumptions

ASSUMPTION-1: §3.2 and `home-screen-design-conventions.md` disagree on the 60 ring's arc
colour (indigo vs pure white on the hero). Resolved in favour of §3.2, which the
checklist names as the source of truth for what to build. The white variant is recorded
as out of scope rather than built speculatively.

ASSUMPTION-2: The specimen (80) size has no published numbers. Assuming it follows the
two documented sizes' shared geometry — an 8 stroke inset 2 from the box edge, as 88
(r38 / 8 stroke) and 60 (r25 / 6 stroke) both are — and the app-scale "Stat figure" step,
18 display 700, for its centre number.

ASSUMPTION-3: Out-of-range values clamp silently rather than throwing or asserting;
`100%` is reserved for an exact 100 by truncating the label rather than rounding it.

ASSUMPTION-4: The centre caption is optional and caller-supplied; the detail panel's
`done` is one caller's copy, not fixed component text.

ASSUMPTION-5: Semantics copy is `<n>% complete`. Not specified anywhere; chosen to state
the number and its meaning in one phrase.

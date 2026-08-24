# Ambiguities Report
Source: `week-2-task-briefs.md` item 2.6 + `system-foundation-specs.md` §3.2 "Rows & hairline groups" (line 246)
Date: 2026-08-24 (re-run after the human resolved both CRITICAL items at the gate)

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE — both items below were raised on the first pass and answered by the human
on 2026-08-24. Recorded here for provenance; not open, not to be re-opened.

RESOLVED CRITICAL-1: [2.6 scope] — Which files this item may touch, and therefore
whether it can ship unwired at all.
  **Answer: option A — new file(s) only.** `group_task_item.dart`,
  `task_item.dart` and `horizontal_separator.dart` are all left untouched. The
  item ships genuinely unwired: no shipped surface changes appearance on merge,
  and tracker's rows remain optional adopters. Available only because 2.6 is an
  extraction — item 2.5 established that an in-place rework can never ship
  unwired.
  Consequences carried into `tech-ac.md`: `HorizontalSeparator`'s hardcoded
  `Colors.grey` and `width: context.screenWidth` are **not criteria in this
  item** and are listed under `## Out of scope` as a recorded follow-up for
  `handover.md`; and with no caller anywhere, the API is derived from the design
  docs rather than a live call site.

RESOLVED CRITICAL-2: [§3.2 line 246] — One component or two?
  **Answer: option B — two public components.** A row, plus a group container
  that owns the card fill, the `lg` (16) radius, the clipping, and inserts the
  hairlines between its children. §3.2's "single hairline between rows only,
  never a border on both edges of every row" is therefore a property the group
  guarantees by construction, not one each caller must remember. Pinned by
  [2.6-AC8] (exactly N−1 hairlines for N children) and [2.6-AC9] (no parameter
  exists that could place one on an outer edge). Accepted costs: a second public
  class, and a row that is usable standalone in a way the spec doesn't sanction.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: `game-detail-design-conventions.md` outranks §3.2 for every number
this item needs, per `system-foundation-specs.md` lines 6–8. §3.2 states no type
size, padding or colour for the row; §4.4 and §5.2 do, and they do not contradict
§3.2's r16 — `--radius-lg` resolves to 16 in `app_radius_tokens.dart`, so the two
docs agree.

ASSUMPTION: Row label is the 14/500 type step in full ink and the right-hand
value is the same step at `ink70` (§4.4 "Store name 14px/500 ink, price 14px
`--color-ink-70`, right-aligned"; §5.2's date/duration pair). **No 15px collision
arises here** — §3.3's 15px/500 belongs to the Provider / list row (`ActionRow`,
item 1.9), a different anatomy with a centred label and a leading mark. No new
type token is proposed.

ASSUMPTION: Group fill is `surfaceRaised`; the hairline is the existing
`hairline` token (`_ink12`). Both design docs agree.

ASSUMPTION: Row vertical padding is 14, not two variants. §4.4 says `14px 16px`
and §5.2 says `13px 16px`; 13 is odd, collides with the even-dimensions rule, and
a 1px difference between two instances of one pattern contradicts §0.1's "one
anatomy per concept". 14 is the even neighbour and already in use on one of the
two surfaces.

ASSUMPTION: The 1px hairline stroke is not an even-dimensions violation — a
hairline has no even alternative, and `HorizontalSeparator` and
`LabeledTextField`'s error hairline both already ship at 1px.

ASSUMPTION: A group given no children renders nothing rather than an empty card.
Not specified anywhere; the safest narrow reading.

ASSUMPTION: The row's value is text, not an arbitrary widget slot — no design doc
puts anything but a short string on the right-hand side.

ASSUMPTION: The group takes generic widget children rather than a typed list of
rows. This follows from the gate's own reasoning for choosing option B over
option C: C was rejected because "callers cannot place a bespoke row inside the
group", so B must permit it.

ASSUMPTION: The row exposes no tap or navigation callback. §3.2 asks for a
chevron glyph, not an interaction, and neither §4.4 nor §5.2 has a tappable row.
Keeping it out is the minimal-API reading the gate asked for; a tap belongs to
the first surface that needs one.

ASSUMPTION: No per-row value colour override. §4.4's `Day one` price is green, so
Where-to-play will need one eventually, but that surface is not built here and
adding the parameter now repeats the `suffixIcon` violation item 2.5 trimmed.
Flagged in `tech-ac.md` `## Out of scope` for whoever builds §4.4.

ASSUMPTION: No existing screen is rewired to adopt the new components in this
run. `_SignOutButton` (`settings/sign_out_section.dart`) is recorded in
`handover.md` as the natural second caller for `ActionRow`, not for this row.

ASSUMPTION: `library_stats.dart`'s `_DashedBorderPainter` is item 2.8's and is
not touched here, per `handover.md`.

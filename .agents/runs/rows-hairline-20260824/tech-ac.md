# Technical Acceptance Criteria
Source: `week-2-task-briefs.md` item 2.6 + `system-foundation-specs.md` §3.2 "Rows & hairline groups" (line 246) + `game-detail-design-conventions.md` §4.4 / §5.2; scope settled by the human gate decisions recorded in `orchestrator-state.md` (CRITICAL-1 → A, CRITICAL-2 → B)
Date: 2026-08-24
BA Agent version: 1.0

## Feature summary

Extract §3.2's row-and-hairline-group anatomy as two new, unwired presentation
components: a **row** (label leading, value trailing, optional chevron) and a
**group container** that owns the raised card fill, the 16 radius, the clipping,
and the hairlines it inserts *between* its children. The group's defining
property is structural: with N children it renders exactly N−1 hairlines and
gives callers no way to produce one above the first child or below the last, so
§3.2's "single hairline between rows only — never a border on both edges of
every row" holds by construction rather than by caller discipline. Nothing in
the app calls either component in this run; no shipped screen changes
appearance on merge.

## Technical acceptance criteria

### Row

[2.6-AC1] PRESENTATION: The row takes a label and a value, both required, and
renders both texts within a single row.
  Failure case: either text is absent from the tree, or the component accepts
  being constructed without one — a value-less row is a different anatomy (the
  §3.3 Provider row) and is not this component.

[2.6-AC2] PRESENTATION: The label renders in full `ink`; the value renders at
`ink70`. Both use the existing 14/500 type step — no new type token is added.
  Failure case: label and value render at the same ink level, collapsing the
  §4.4/§5.2 hierarchy where the value is secondary to what it is labelled by.
  Verified by: colour assertion naming the `ink` and `ink70` tokens.

[2.6-AC3] PRESENTATION: The chevron is optional and absent by default. With the
chevron not requested, the row's tree contains no chevron icon; with it
requested, it contains exactly one, trailing the value.
  Failure case: a chevron renders on a row that did not ask for one — §4.4's
  store rows and §5.2's session rows are non-navigating and must render clean.
  Verified by: icon-presence and icon-count assertions (position of the icon is
  not asserted).

[2.6-AC4] PRESENTATION: The row draws no hairline, divider, border or outline of
its own, in every configuration it supports. A row pumped on its own contains
zero separator elements.
  Failure case: the row carries its own edge, so a row inside a group produces
  the doubled border §3.2 explicitly forbids, and the group's guarantee
  ([2.6-AC7]–[2.6-AC8]) becomes unenforceable.

[2.6-AC5] PRESENTATION: The row paints no background fill and applies no corner
radius of its own. Surface and shape belong to the group container.
  Failure case: the row fills itself, so a group of rows paints `surfaceRaised`
  twice and a row placed outside a group looks like a standalone card, which no
  design doc sanctions.

[2.6-AC6] PRESENTATION: Row padding is 14 vertical, 16 horizontal, per §4.4.
  Failure case: rows sit tighter than the 44px touch-target floor
  (`game-detail-design-conventions.md` §6, list rows 43–46px).
  Verified by: code review against the token/spec value, and QA's visual check.
  Never a widget test — dimension assertions are not written in this project.

### Group container

[2.6-AC7] PRESENTATION: The group paints `surfaceRaised` as its fill, applies
the `lg` radius (16), and clips its children to that radius so a child's own
paint cannot escape the rounded corners (§3.2 `overflow:hidden`).
  Failure case: children square off the card's corners, or the fill is a literal
  colour instead of the token — a §2 colour-law violation of the shape item 2.5
  removed.
  Verified by: fill asserted as the `surfaceRaised` token; radius and clipping by
  code review and QA's visual check, not by a dimension assertion.

[2.6-AC8] PRESENTATION: Given N children, the group renders exactly N−1
hairlines: one between each adjacent pair, none before the first child and none
after the last. Holds for N = 1 (zero hairlines), N = 2 (one) and N = 3 (two).
  Failure case: N or N+1 hairlines render — the "border on both edges of every
  row" §3.2 forbids, and the reason two components were chosen over one.
  Verified by: separator-count assertions at N = 1, 2 and 3. This is a count, not
  a position or a measurement, so it is assertable within the project's testing
  rules.

[2.6-AC9] PRESENTATION: The group exposes no parameter, flag or per-child option
that adds, removes, suppresses or relocates a hairline. Hairline placement is
derived solely from the number of children.
  Failure case: any such flag exists, which hands §3.2's load-bearing rule back
  to the caller and reduces option B to the rejected option A with an extra
  class. No caller can construct a group whose first or last edge carries a
  hairline.
  Verified by: constructor/API review — the absence of the parameter is the
  criterion.

[2.6-AC10] PRESENTATION: The hairline is a solid 1px stroke in the existing
`hairline` token. No hardcoded colour, no dashed or dotted stroke (§0.6).
  Failure case: a literal colour ships, repeating the violation this week's items
  exist to close.
  Verified by: colour assertion naming the `hairline` token; the 1px stroke by
  code review.

[2.6-AC11] PRESENTATION: A group given no children renders nothing visible — no
card fill, no radius, no hairline, no reserved space.
  Failure case: an empty raised rectangle appears on screen where a caller had
  no rows to show.

[2.6-AC12] PRESENTATION: The N−1 hairline guarantee ([2.6-AC8]) holds for any
child widget, not only for the row from [2.6-AC1]–[2.6-AC6]. The group does not
require its children to be that row type.
  Failure case: the group only behaves for one child type, so a caller needing a
  bespoke row inside a group has to hand-roll the whole card and reproduces the
  pattern this item extracts.

### Scope guarantee

[2.6-AC13] REGRESSION: The run ships unwired. No existing file's rendered output
changes: `group_task_item.dart`, `task_item.dart` and `horizontal_separator.dart`
are untouched, and no existing widget references either new component.
  Failure case: any shipped surface — tracker or game_detail — changes
  appearance on merge, which is the outcome the gate's option A was chosen to
  avoid.
  Verified by: diff review plus the recorded analyzer and test baselines
  (0 errors / 2 warnings / 31 info; +315 −10) moving only by this run's own new
  tests.

## Out of scope

- **`HorizontalSeparator`'s two defects** — hardcoded `Colors.grey` (a §2
  colour-law violation; the `hairline` token already exists) and
  `width: context.screenWidth`. Left open deliberately by the gate's CRITICAL-1
  answer, because fixing them changes `detail_mid_section.dart`, a shipped
  game_detail screen, and ends the unwired option. Add to `handover.md`
  follow-ups when this run completes.
- **Any tap, navigation or press behaviour on the row.** §3.2 asks for a chevron
  glyph, not an interaction, and neither §4.4 nor §5.2 has a tappable row. A tap
  callback belongs to the first surface that actually needs one.
- **A per-row value colour override.** §4.4's `Day one` price is set in
  `--color-green`, so the Where-to-play surface will eventually need this — but
  it is not being built here, and adding the parameter now is the
  "no parameter nothing calls" violation that trimmed `suffixIcon` from item 2.5.
  Flagged for whoever builds §4.4.
- **Adopting the new components anywhere** — tracker's rows, `_SignOutButton`
  (`settings/sign_out_section.dart`, recorded as `ActionRow`'s natural second
  caller, not this row's), §4.4 Where to play and §5.2 Recent sessions are all
  later, optional adopters.
- **`library_stats.dart`'s `_DashedBorderPainter`** — item 2.8's, per
  `handover.md`.
- **Golden tests and any pixel comparison** — never written in this project.
  [2.6-AC6], the radius and clipping half of [2.6-AC7], and the 1px stroke in
  [2.6-AC10] are checked by code review and QA's visual pass, not by a test.

## Assumptions

ASSUMPTION: `game-detail-design-conventions.md` outranks §3.2 for every number
this item needs, per `system-foundation-specs.md` lines 6–8. §3.2 gives no type
size, padding or colour; §4.4 and §5.2 do, and they do not contradict §3.2's r16
— `--radius-lg` resolves to 16 in `app_radius_tokens.dart`, so the two docs
agree.

ASSUMPTION: Label and value both sit at the existing 14/500 step, label in full
ink and value at `ink70` (§4.4 "Store name 14px/500 ink, price 14px
`--color-ink-70`, right-aligned"; §5.2's date/duration pair). **No 15px collision
arises here** — §3.3's 15px/500 belongs to the Provider / list row (`ActionRow`,
item 1.9), a different anatomy with a centred label and a leading mark. No new
type token is proposed.

ASSUMPTION: Row vertical padding is 14, not two variants. §4.4 says `14px 16px`
and §5.2 says `13px 16px`; 13 is odd, collides with the even-dimensions rule, and
a 1px split between two instances of the same pattern contradicts §0.1's "one
anatomy per concept". 14 is the even neighbour and already in use on one of the
two surfaces.

ASSUMPTION: The 1px hairline is not an even-dimensions violation — a hairline has
no even alternative, and `HorizontalSeparator` and `LabeledTextField`'s error
hairline both already ship at 1px.

ASSUMPTION: The value is text, not an arbitrary widget slot. No design doc puts
anything but a short string on the right-hand side.

ASSUMPTION: The group takes generic widget children rather than a typed list of
rows. This follows from the gate's own reasoning for preferring option B over
option C — C was rejected because "callers cannot place a bespoke row inside the
group", so B must permit it. [2.6-AC12] pins that down.

ASSUMPTION: A group with no children renders nothing rather than an empty card
([2.6-AC11]). Not specified anywhere; the safest narrow reading.

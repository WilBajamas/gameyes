# Ambiguities Report
Source: `week-2-task-briefs.md` item 2.6 + `system-foundation-specs.md` §3.2 "Rows & hairline groups" (line 246)
Date: 2026-08-24

## CRITICAL (pipeline blocked — requires human decision before proceeding)

CRITICAL-1: [2.6 scope] — Which files this item is allowed to touch, and therefore
whether it can ship unwired at all.
  Item 2.6's bullet says "leave tracker's own rows as later, optional adopters
  rather than forcing a rewrite here", written on the assumption that all three
  named files are tracker-local. Phase 0's grep shows `HorizontalSeparator` is
  not: its main caller is `detail_mid_section.dart`, a **game_detail** screen.
  So the bullet's instruction does not cover it, and the extraction-vs-blast-radius
  fork item 2.5 identified is live again in a different shape.
  Options:
    A. **New file(s) only.** `group_task_item.dart`, `task_item.dart` and
       `horizontal_separator.dart` are all left untouched. Ships genuinely
       unwired — no shipped surface changes on merge; tracker and game_detail
       are unaffected. Cost: `HorizontalSeparator`'s two defects (below) stay
       open as a follow-up, and a second hairline-drawing widget now exists
       beside it, which `flutter-widgets`' "reuse before rebuilding" rule
       normally argues against.
    B. **New file(s) + fix `horizontal_separator.dart` in place.** Swap
       `Colors.grey` for the `hairline` token and drop `width: context.screenWidth`.
       Two callers change appearance on merge, one of them a **game_detail**
       screen — the unwired option is gone, exactly as 2.5 found for an in-place
       rework. Cost: a visible colour change on a shipped screen inside an item
       whose stated job is an extraction. Benefit: closes a §2 colour-law
       violation of the same shape as the `Colors.red` 2.5 removed.
    C. **New file(s), `HorizontalSeparator` deprecated or absorbed, both callers
       rewired.** Largest radius — tracker *and* game_detail both change, which
       is what the bullet's "don't force a rewrite" was written to avoid.
  Recommended: **A**, on precedent — item 2.8's dashed-border violation is the
  standing example of a known defect deliberately left for its own item, and A
  is the only option that keeps this run's merge visually inert. B is defensible
  and small if the human would rather not carry the colour-law violation another
  week; if B is chosen, say so explicitly, because it converts this run into one
  with a shipped-surface change and QA needs to expect that.
  Note two consequences that ride on this answer: (a) whether the
  `Colors.grey` / `context.screenWidth` fixes are in this run's criteria at all,
  and (b) under A the component has no caller anywhere, so its API has to be
  derived from the two surfaces the design docs describe (game_detail §4.4
  "Where to play" and §5.2 "Recent sessions") rather than from a live call site —
  which sits awkwardly against `flutter-widgets`' "no parameter nothing calls yet".
  Decision needed from: Product Owner / human at the gate

CRITICAL-2: [§3.2 line 246] — Does 2.6 ship one component or two?
  §3.2 describes a **group**, not a row: "raised card at r16, `overflow:hidden`,
  a single hairline *between* rows only — never a border on both edges of every
  row." "Between rows only" is a property no single row can assert about itself —
  it depends on position in a list. The item's title says "Rows & hairline
  groups", plural concepts, but the checklist bullet asks only for "a generic
  reusable row primitive".
  Options:
    A. **One row widget**, with an `isLast`/`showDivider`-style flag the caller
       sets. Cheapest, but hands the spec's load-bearing rule back to every
       caller — the first caller that gets the flag wrong reproduces the exact
       "border on both edges" the spec forbids.
    B. **Two public components** — a row, plus a group container that owns the
       card fill, r16, clipping, and inserts hairlines between its children. The
       rule becomes unbreakable by construction. Costs a second class, and the
       row alone is then usable in a way the spec never sanctions.
    C. **One public group component** that takes the row content as data and
       renders the rows itself; no separately public row. Strongest guarantee,
       narrowest API, but callers cannot place a bespoke row inside the group.
  Recommended: **B or C** — both make "hairline between rows only" a property of
  the component rather than of its caller, which is the whole point of extracting
  the pattern. No recommendation between them without the human's view on whether
  a caller ever needs to put arbitrary content in a group row.
  Decision needed from: Product Owner / human at the gate (component grain, same
  question 2.7's bullet flags for itself)

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: `game-detail-design-conventions.md` outranks §3.2 for every number
this item needs, per `system-foundation-specs.md` lines 6–8. §3.2 states no type
size, padding or colour for the row; §4.4 and §5.2 do, and they do not contradict
§3.2's r16 (`--radius-lg` resolves to 16 in `app_radius_tokens.dart`).

ASSUMPTION: Row label is the 14/500 type step in full ink and the right-hand value
is the same step at `ink70` (game_detail §4.4 "Store name 14px/500 ink, price 14px
`--color-ink-70`, right-aligned" and §5.2's date/duration pair). **No 15px
collision arises here** — §3.3's 15px/500 belongs to the *Provider / list row*,
which is `ActionRow` (item 1.9), a different anatomy (centred label, leading mark)
and not this component. No new type token is proposed.

ASSUMPTION: Group fill is `surfaceRaised`, hairline is the existing `hairline`
token (`_ink12`), per both design docs.

ASSUMPTION: Row vertical padding is taken as 14px, not two variants. §4.4 says
`14px 16px` and §5.2 says `13px 16px`; 13 is odd and collides with "dimensions
are even numbers", and a 1px difference between two instances of the same
pattern contradicts §0's "one anatomy per concept". 14 is the even neighbour and
the value the denser-looking of the two surfaces already uses.

ASSUMPTION: The 1px hairline stroke is not an "even dimensions" violation — a
hairline has no even alternative, and the existing `HorizontalSeparator` and
`LabeledTextField`'s error hairline both already ship at 1px.

ASSUMPTION: A group given no rows renders nothing rather than an empty card. Not
specified anywhere; the safest narrow reading.

ASSUMPTION: No existing screen is rewired to adopt the new component in this run.
`_SignOutButton` (`settings/sign_out_section.dart`) is recorded in `handover.md`
as the natural second caller for `ActionRow`, not for this row, and remains its
own item.

ASSUMPTION: `library_stats.dart`'s `_DashedBorderPainter` is item 2.8's and is not
touched here, per `handover.md`.

# Ambiguities Report
Source: `week-2-task-briefs.md` item 2.5 + `system-foundation-specs.md` §3.2 "Form fields" (with §1.8 Focus, §2.1 error ramp, §3.4 Field, §5)
Date: 2026-08-23

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

Both open questions below are delivery-scope calls, not business decisions about
what the component does. The project already routes both to a gate rather than to
a BA halt: `week-2-task-briefs.md` "Open decisions that could block" hands the
rewiring call to "that item's own BA/Tech Lead phase", and `handover.md`'s
next-session prompt says the decision "should reach the human at a gate".
`tech-ac.md` is therefore written, and every criterion in it holds whichever way
GATE-1 goes.

## GATE DECISIONS (non-blocking — settle at the Phase 3 gate before Dev starts)

GATE-1: item 2.5 — are the three caller files rewired in this run, or does the
  component ship reworked-but-unwired?
  Blast radius (Phase 0 recon, not re-derived): 3 files, 7 call sites —
  `add_content_dialog.dart` (2), `filter_bottom_sheet.dart` (3),
  `task_detail_screen.dart` (2). Nothing else in the app builds a text input, so
  there are no stragglers beyond these.
  Load-bearing fact: an in-place rework cannot ship unwired. The moment the
  component changes, all three surfaces change with it, and dropping the
  caller-passed `BuildContext` edits all three files whatever else is decided.
  "Unwired" is only available by building a second component.
  Options:
    A — Rework in place; revisit all 7 sites in this run (constructor change plus
        each site's label/placeholder/read-only usage under "label above,
        always"). Three shipped surfaces change appearance on merge. One
        migration, no duplicate component. Renaming the widget categorically (the
        conventions forbid a `Default` prefix on new widgets) is nearly free here
        because every caller is already being edited.
    B — Rework in place; touch callers only for the constructor change. Same
        visual change lands on the same three surfaces anyway, but no one reviews
        whether each site's copy still reads correctly — the search field's label
        beside its magnifier, the two date fields that are really tap targets, and
        the two dialog fields that carry genuine placeholders. Cheapest, leaves
        per-site copy unreviewed.
    C — Build the new field beside the old one, deprecate the old one, ship the
        new one with no caller. No shipped screen changes now. Costs: two form
        field components live at once (on top of the already-deprecated
        `GameItem`), the old widget keeps its caller-passed context and its
        hardcoded red until a follow-up run, and the component's manual checks
        need a scratch harness — the same position 2.2's ring is still in.
  Recommended: A. Item 2.1 settled the identical fork this way on 2026-08-21, the
    callers must be edited regardless, and C is the only option that leaves the
    hardcoded `Colors.red` alive in the tree.
  Decision needed from: Product Owner / human at the gate

GATE-2: items 2.5 vs 2.7 — which item owns the field-level error treatment?
  Checklist item 2.7 (Error states, 4 levels) explicitly claims "field-level
  tinted fill + red hairline", which is the same treatment §3.2's Form fields row
  gives to 2.5. Neither item can be run as written without deciding this, and it
  should not be settled by whichever runs first.
  Options:
    A — 2.5 builds it now. `[2.5-AC8]`–`[2.5-AC11]` stand as written; 2.7 then
        covers only Action, Screen and Item, and inherits the field level
        unchanged.
    B — 2.5 defers it. 2.5 ships resting + focus only; 2.7 later adds the tinted
        fill and hairline. Note this still does not let the hardcoded red survive:
        `isRequired` already drives a live validator, so 2.5 must at minimum move
        the error message onto the error-ink token. B therefore means editing the
        same widget twice.
  Recommended: A. §3.2's own Form fields row names the error swap as part of this
    component, and the error state already has a live producer at 4 call sites.
  Decision needed from: Product Owner / human at the gate

GATE-3: type steps for the field's label and body text — the 15px collision,
  third occurrence.
  §3.2's Form fields row names no type step. §1.2's app-scale ramp puts the
  nearest roles at "Row label / button 14–15 / 500" and "Lead 15–16 / 1.45", so
  the field's label and input text straddle 15px. There is still no 15px type
  token, and "dimensions are even numbers" is a standing convention. Item 1.9 left
  its 15px gap open for want of a token; item 2.2 shipped 14 as an approved
  deviation.
  Options:
    A — Use the existing 14/500 and 16/400 steps; mint nothing. `[2.5-AC18]` is
        written this way so the pipeline can proceed.
    B — Mint a 15px token and settle the collision for the whole system, which is
        a foundations change with reach far beyond this item.
  Recommended: A, with B raised as its own follow-up rather than smuggled into a
    component run. Flagging rather than inventing, per the standing instruction.
  Decision needed from: human at the gate

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: Placeholder text is kept as an optional capability. "No
placeholder-as-label anywhere" bars a placeholder *standing in for* a label; two
call sites use a genuine placeholder alongside a real label, which the rule
permits.

ASSUMPTION: The character counter is treated as helper text. Four call sites set a
maximum length, and §3.2 forbids a third line under the input, so the count
renders in the label row's helper slot and Material's below-field counter is
suppressed.

ASSUMPTION: The helper slot is built even though no current caller passes helper
text, because §3.2 specifies its placement and the counter above needs it.

ASSUMPTION: Ink levels are unspecified for this component. Label renders at full
ink (it names the field), helper/counter at 55% ink. Not copied from the provider
row's `ink70`, which `handover.md` records as a deliberate, separate call.

ASSUMPTION: Disabled styling is not defined by the spec and no caller disables a
field, so no disabled treatment is introduced; the existing hardcoded grey
disabled stroke is simply removed. Read-only fields keep the normal resting fill —
they are tap targets, not disabled.

ASSUMPTION: Error copy is unchanged. The existing localised required-field message
is reused; only its colour and placement change.

ASSUMPTION: Hover is not built. §1.8 defines hover for solid fills, ghost/raised
surfaces, links and media tiles, and names no treatment for an input.

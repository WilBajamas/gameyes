# Ambiguities Report
Source: `system-foundation-specs.md` §3.2 "Error states" row (line 247) + §3.4 (lines 266–279);
`week-2-task-briefs.md` item 2.7
Date: 2026-08-24

## Settled before this run (recorded, not re-derived)

- **Scope is three levels, not four.** §3.4 describes Field / Action / Screen / Item. The
  **Field** level shipped with item 2.5 (tinted fill + 1px error hairline on the labelled
  text field), and the 2026-08-24 gate settled that 2.7 inherits it unchanged. No criterion
  in this run covers the field level, and §3.4's field bullet is not a requirement here.
- Neither `game-detail-design-conventions.md` nor `home-screen-design-conventions.md`
  mentions errors, retry, toasts or strips at all — grepped. So the §3-outranked-by-screen-doc
  rule does not fire for this item; §3.4 is uncontested for the two features that host the
  existing error surfaces.

`tech-ac.md` is NOT written this run — three CRITICAL items are open. See `escalation.md`.

## CRITICAL (pipeline blocked — requires human decision before proceeding)

CRITICAL-1: item 2.7 — **Grain: one item covering three error levels, or separate runs?**
  The checklist bullet raises this itself and defers it ("Tech Lead should confirm that's the
  right grain rather than four separate runs"), and it is also listed under the checklist's
  own "Open decisions that could block". It is unresolved and it changes which criteria belong
  in this run at all, so it cannot be answered inside `tech-ac.md`.
  Options:
    A — One run, all three levels (Action + Screen + Item). One design gate, one QA cycle,
        one allowlist. Cost: a Phase 3 reversal on any one level re-opens the whole run; the
        blast-radius answer from CRITICAL-2 has to be the same for all three levels, because
        a run either ships unwired or it does not. This is also the strongest module-folder
        candidate so far (three sibling components), though 2.5 and 2.6 both deliberately
        shipped flat files, so the folder is a judgement, not a consequence.
    B — Three runs, one level each. Each level's shipped-surface question is decided on its
        own evidence; smallest blast radius per gate. Cost: three BA/Tech-Lead/Dev/QA cycles
        and three human gates for roughly one item's worth of code, and the three levels
        share tokens and probably a red-dot/badge primitive, which would then be built in run
        one and imported by runs two and three (or duplicated).
    C — Two runs, split on blast radius rather than on level count: the levels that touch no
        shipped surface in one run, the level(s) that do in another. Cost: one extra gate;
        benefit: "unwired" becomes a property of a whole run rather than a per-criterion
        argument, which is exactly the distinction 2.5 and 2.6 established.
  Note the dependency: **A is only coherent if CRITICAL-2 resolves the same way for all three
  levels.** On today's evidence it does not — the Item and Action levels have no incumbent at
  all, the Screen level has two.
  Recommended: NONE — this is delivery cadence versus blast radius, a human call.
  Decision needed from: Product Owner (with Tech Lead input)

CRITICAL-2: item 2.7 — **Extraction, rewire, or in-place rework — does 2.7 own the existing
error surfaces?** This decides whether the item can ship unwired at all.
  Facts, grepped this run rather than inherited:
    - `ErrorRetryWidget` (37 lines) has **5 live callers**: `detail_top_header.dart:34`,
      `detail_mid_section.dart:29`, `games_screen.dart:68`, `:78`, `:88`. Two features
      (game_detail, games). Plus two **commented-out** blocks in
      `detail_screenshot_section.dart:22` and `:52` — dead code, not callers.
    - **One of those five is not an error state.** `games_screen.dart:88` renders
      `ErrorRetryWidget` for `GamesStatus.empty` with `S.current.no_results_found`. That is
      an **empty** state, which belongs to item 2.8, not 2.7. Absorbing `ErrorRetryWidget`
      into 2.7 therefore reaches into 2.8's scope, or leaves a component with one caller
      still using it as an empty state.
    - **§3.4 does not spec a per-section retry block.** `ErrorRetryWidget` is a centred
      message plus a retry button rendered inside a failed section. §3.4's four levels are
      field, action, screen and item; the "error per section, never full page" line lives in
      §3.2's **Async states** row, not the Error states row. Replacing `ErrorRetryWidget`
      means designing a surface no current doc describes, or re-reading one of §3.4's levels
      as covering it. Neither is a BA call.
    - `DefaultSnackbar` (21 lines) has **1 caller**, `task_detail_screen.dart:70` — and that
      call site shows **both** outcomes through it: `RemoveStepSuccess` → "removed step",
      `RemoveStepFailed` → "remove step failed". So it is a general-purpose snackbar, not an
      error surface. §3.4's toast is error-only by construction (it carries a red dot), and
      §0.3/§2.1 ration red hard. A straight swap would put a red dot on a success message.
      Replacing it needs either the call site split into two surfaces, or a non-error toast
      variant that §3.4 does not describe.
    - `DefaultSnackbar` is also currently off-spec regardless: it fills with
      `kColorScheme.primary` (indigo), where §3.4's toast is `#2e3236`.
  Options:
    A — **Pure extraction.** New Action/Screen/Item components beside the existing ones;
        `ErrorRetryWidget` and `DefaultSnackbar` untouched. Ships genuinely unwired (2.6's
        shape): zero shipped-surface change, no manual-check burden on live screens.
        Cost: two error vocabularies coexist; 4 error call sites stay off-spec indefinitely;
        the follow-up debt list grows (it already carries `horizontal_separator.dart` of
        exactly this shape). And nothing exercises the new components — 2.2's unwired ring
        left 10 manual checks that still cannot be performed for want of a caller.
    B — **Extraction plus rewire in the same run.** Build beside, then move call sites over
        and deprecate or delete the old widgets. Cost: unwired is not available; game_detail
        and games both change appearance on merge; largest manual-check surface. Precedent
        exists (2.1 rewired in-run; 2.5 accepted three changed surfaces at the gate). Needs
        CRITICAL-2's `games_screen.dart:88` and `task_detail_screen.dart:70` questions
        answered first, since neither call site is a plain error.
    C — **In-place rework** of `ErrorRetryWidget` / `DefaultSnackbar` (same class, same file).
        2.5 established that this cannot ship unwired under any circumstances — the same
        class in the same file changes every caller the moment it merges, touched or not.
        Highest blast radius, least reversible, and it inherits both mismatches above.
    D — **Mixed by level.** Item and Action levels are pure extraction (nothing in the app
        renders a failed card or a destructive confirmation today, so there is no incumbent);
        Screen level is the only one with incumbents. Cost: the run is then partly unwired
        and partly not, which is precisely the fork CRITICAL-1's Option A cannot express.
  Also decide, in the same breath: the two commented-out `ErrorRetryWidget` blocks in
  `detail_screenshot_section.dart` — delete as part of this run, or leave for a sweep.
  Recommended: NONE.
  Decision needed from: Product Owner (with Tech Lead input)

CRITICAL-3: §3.4 Screen level — **which token carries the toast fill `#2e3236`?**
  A token with exactly that value already exists: `surfaceTabChrome` (`0xFF2E3236`), minted
  for item 2.4's tab bar chrome. The value is right; the name describes a different surface.
  Options:
    A — Reuse `surfaceTabChrome`. No foundations change, no new token, stays inside a
        component run's normal allowlist. Cost: a toast component reads a tab-bar-named token,
        which reads as a mistake to the next person and invites a "fix" that breaks the tab bar.
    B — Mint a semantic alias (a second name for the same value, e.g. a toast/overlay surface
        token). Reads correctly at both call sites. Cost: this edits
        `lib/config/theme/tokens/app_color_tokens.dart` — a **foundations change**, which
        every component run so far has deliberately stayed out of (see the standing 15px type
        token gap, now open across 1.9, 2.2 and 2.5). It also needs the token allowlisted and
        the two-name-one-value duplication accepted.
    C — Rename `surfaceTabChrome` to a neutral surface name and update 2.4's module. Cost:
        touches a shipped component for a naming reason only.
  A criterion can be written against the value either way, so this is not blocking on
  correctness — it is blocking on "don't silently pick", which is what has gone wrong before.
  Since the pipeline is already stopped by CRITICAL-1 and 2, answering it in the same
  round-trip is free.
  Recommended: NONE.
  Decision needed from: Product Owner

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: §3.4's Action level names an outline-in-error-ink variant "reserved for the rarer,
heavier destruction (account deletion)". No account-deletion flow exists in the app and there
would be no caller. Assuming the run builds only the solid destructive-fill variant, per the
"no parameter nothing calls" rule that dropped `suffixIcon` in 2.5. Cheap to overrule at the
gate if the human wants the variant built ahead of the flow.

ASSUMPTION: no copy is specified for any of the three levels, and §4 forbids a corporate
register but gives no strings. Assuming every user-visible string is caller-supplied and no
component hardcodes English; anything a component owns internally goes through the existing
localisation path.

ASSUMPTION: §3.4's toast has no stated duration. Assuming the app's existing snackbar display
duration rather than introducing a new number.

ASSUMPTION: §3.4 calls the Screen-level strip "dismissable" without saying what dismissal
means. Assuming dismissal removes the strip for that failure only, with no persistence and no
suppression of a later failure — re-showing is the caller's decision, not the component's.

ASSUMPTION: §3.4's Item level says the failed row or card "dims to 55%". Assuming that is
55% opacity applied to the item's own content, not a recolouring of its text to the `ink55`
token — §3.4 describes a dim, and a colour token could not dim cover artwork.

ASSUMPTION: no type step is specified for any of the three levels. §1.2's ramp gives
"Row label / button 14–15 / 500" as a **range**, and the shipped primary button already uses
the 14/500 step. Assuming 14/500 throughout, so **this item does not re-open the 15px
collision** that 1.9, 2.2 and 2.5 each hit — no new type token is needed here. If a reviewer
insists on 15 for any of these three surfaces, that becomes the fourth instance and needs the
foundations decision, not a hand-rolled number.

ASSUMPTION: §3.4's Item badge is explicitly **wordless** ("No label fits a 64px cover"), and
sits "in the same slot as the indigo library tick" — the existing library tick overlay is the
positional reference. Assuming the badge carries no text in any form, and that its
accessibility affordance is a semantics label rather than visible copy (§5 exempts only the
tab bar and circular icon buttons from label pairing, so a semantics label is required, not
optional).

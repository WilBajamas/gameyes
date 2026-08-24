# Ambiguities Report
Source: `system-foundation-specs.md` §3.2 "Error states" row (line 247) + §3.4 (lines 266–279);
`week-2-task-briefs.md` item 2.7
Date: 2026-08-24 (BA re-run, after the human gate answered all open criticals)

## Settled before this run (recorded, not re-derived)

- **Scope is three levels, not four.** §3.4 describes Field / Action / Screen / Item. The
  **Field** level shipped with item 2.5 (tinted fill + 1px error hairline on the labelled
  text field), and the 2026-08-24 gate settled that 2.7 inherits it unchanged. No criterion
  in this run covers the field level, and §3.4's field bullet is not a requirement here.
- Neither `game-detail-design-conventions.md` nor `home-screen-design-conventions.md`
  mentions errors, retry, toasts or strips at all — grepped. So the §3-outranked-by-screen-doc
  rule does not fire for this item; §3.4 is uncontested for the two features that host the
  existing error surfaces.

`tech-ac.md` **is** written this run. No CRITICAL item remains open.

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE — all three criticals raised on 2026-08-24 were answered by the human at a gate, plus a
fourth question on dead-code scope. `escalation.md` is deleted. The answers are reproduced below
so this file reads correctly on its own; the full reasoning lives in `orchestrator-state.md`'s
"Gate decisions" section.

### RESOLVED CRITICAL-1 — grain: one run, all three levels

Answered: **one run covering Action + Screen + Item, one `tech-ac.md`.** This is coherent
precisely *because* CRITICAL-2 resolved uniformly across the three levels — pure extraction
applies to every level, so the run ships unwired as a whole rather than partly. The three levels
also share tokens and probably a badge/dot primitive, which one run builds once.
Consequence for this document: every criterion for all three levels lives in one `tech-ac.md`.

### RESOLVED CRITICAL-2 — blast radius: pure extraction

Answered: **option A, pure extraction.** New Action / Screen / Item components are built beside
the incumbents. `ErrorRetryWidget` and `DefaultSnackbar` are **not** reworked, replaced or
rewired, and neither file is touched. The item ships genuinely **unwired**.

The decisive argument was this BA's own finding: **§3.4 does not spec a per-section retry block
at all** — `ErrorRetryWidget`'s anatomy comes from §3.2's *Async states* row — so replacing it
would mean designing a surface no document describes, which is not a BA call.

Accepted cost, recorded honestly by the human: two error vocabularies coexist, four error call
sites stay off-spec, and nothing exercises the new components (item 2.2's unwired completion ring
left 10 manual checks still unperformable for want of a caller).

Consequence for this document: `tech-ac.md` carries **no criteria** about `ErrorRetryWidget`,
`DefaultSnackbar`, `games_screen.dart:88`'s empty state, or `task_detail_screen.dart:70`'s
success/failure snackbar. All four are listed under `## Out of scope` instead. The three findings
that drove the decision — the empty-state caller, the both-outcomes snackbar, and the missing
per-section-retry spec — are preserved in `orchestrator-state.md` and are not re-litigated here.

### RESOLVED CRITICAL-3 — toast token: mint a semantic alias

Answered: **option B, mint a semantic alias.** `#2e3236` already exists as `surfaceTabChrome`
(minted for item 2.4's tab bar). A toast reading `surfaceTabChrome` would read as a bug later, so
a second, semantically named token carries the same value.

This makes `lib/config/theme/tokens/app_color_tokens.dart` an allowlisted file — the **first
foundations edit a component run has been permitted**. The human scoped it to adding the alias:
`surfaceTabChrome` is not renamed or removed, because the shipped tab bar depends on it.

Consequence for this document: `[2.7-AC1]`–`[2.7-AC4]` cover the alias and nothing else, with
`[2.7-AC4]` explicitly fencing off every other foundations file.

### RESOLVED (fourth question) — dead-code removal: one file, narrowly

Answered: **delete `lib/features/game_detail/presentation/screens/detail_screenshot_section.dart`
entirely** and remove the commented reference at `game_detail_screen.dart:73`. Traced, not
assumed: the file is 66 lines of which 54 are commented out, its live body is
`return SizedBox.shrink()` so it renders nothing, and its only reference anywhere is itself
commented out. Deleting it also removes the two phantom `ErrorRetryWidget` "callers" at `:22` and
`:52` that this item's recon tripped over.

**Explicitly NOT in scope**, by human decision: `GameScreenshotCubit`, `game_screenshot_entity.dart`,
`screenshot.dart`, `screenshot_response_model.dart`, and `ImageRouteView`'s route registration.
And **`lib/widgets/game_screenshot.dart` is LIVE** (`image_page_view.dart:32` uses it) — it must
not be touched, despite looking dead from inside the deleted file's commented block.

Consequence for this document: `[2.7-AC30]` states that boundary as an explicit do-not-touch
list, because a Dev Agent following the dead-code trail could easily over-delete.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: §3.4's Action level names an outline-in-error-ink variant "reserved for the rarer,
heavier destruction (account deletion)". No account-deletion flow exists in the app and there
would be no caller. Assuming the run builds only the solid destructive-fill variant, per the
"no parameter nothing calls" rule that dropped `suffixIcon` in 2.5. Cheap to overrule at the
gate if the human wants the variant built ahead of the flow.

ASSUMPTION: no copy is specified for any of the three levels, and §4 forbids a corporate register
but gives no strings. Assuming every user-visible string is caller-supplied and no component
hardcodes English; anything a component owns internally goes through the existing localisation
path.

ASSUMPTION: §3.4's toast has no stated duration. Assuming the app's existing snackbar display
behaviour — which sets no explicit duration and inherits the framework default — rather than
introducing a new number.

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

ASSUMPTION (new this run): §3.4 does not state the toast's text colour. The red dot carries the
signal and §2.1 rations red harder than green, so assuming the toast message renders in the `ink`
token on the `#2e3236` surface. The strip, which carries no dot, keeps `errorInk` per §3.3's
"signal hairline + `#ff8f88` message". Overrule at the design gate if the toast should carry
error ink instead.

ASSUMPTION (new this run): a `/// TODO: fetch screenshots - from game detail` comment sits
immediately above `game_detail_screen.dart:73` and annotates only the commented reference being
removed. Assuming it goes with it rather than dangling above nothing. The live "Screenshots"
heading above both stays — removing that would be a shipped-surface change this run is not
permitted to make.

## Note on §3.4's "never both a strip and a toast"

Not an ambiguity — recording it because the earlier pass established it and `tech-ac.md` depends
on it. The rule **has a checkable form** in the shape item 2.6 used for its hairline guarantee: a
single required variant selector with no default makes "both" unrepresentable, and the absence of
any parameter that could render the second surface is verified at the API surface. It does not
need to be a manual-only check. See `[2.7-AC11]` and `[2.7-AC12]`.

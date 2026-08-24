# Ambiguities Report
Source: FRS `requirements.md` (run `async-empty-state-20260824`), FR-2.8.1–FR-2.8.5,
against `system-foundation-specs.md` §3.2 Async states row
Date: 2026-08-24 (second pass — post gate)

Stale-spec check performed per this run's standing trap: §3.2's cover-art
desaturation text was not used and is not in this item's scope. No handover record
reverses any part of §3.2's *empty* half, and §0 item 6 (outlines always solid)
independently confirms the dashed-border removal at site 2.

Site numbers below are `requirements.md` FR-2.8.3's five in-scope sites, where site
5 is `featured_screen`'s silent countdown section — not `orchestrator-state.md`'s
seven-row recon table. The file named in each row is the reference, per
`gate-decisions.md`.

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE — both previously open items were decided by the human on 2026-08-24 and are
recorded as settled requirements below. `escalation.md` is closed and deleted.
`tech-ac.md` is written this pass.

### RESOLVED (kept for the record — do not re-open)

CRITICAL-1 — RESOLVED 2026-08-24, option B. FR-2.8.1's mandated `--surface-art-deep`
card fill had no value anywhere in the project. The empty-state card uses the
existing raised card surface `surfaceRaised` (#2f333c). No token is minted and no
foundations file is touched. Recorded as a foundations gap, not this run's to fix:
`system-foundation-specs.md` §2.2's claim that art-deep is the empty-state card
fill is unimplemented app-side, because no art surface carries a value and §2
rule 4 keeps violet out of the UI until ratified. Joins the 15px token gap.
Carried into criteria AC-02.

CRITICAL-2 — RESOLVED 2026-08-24, option A. §3.2's "one action" is honoured at all
five sites and the component's action is required, not optional. Destinations, as
ruled: site 1 re-dispatches `GamesFetched` (unchanged); site 2 keeps
`onMarkNowPlaying` (unchanged); site 3 clears the genre selection; sites 4 and 5 go
to Browse. Sites 4 and 5 are a **tab switch, not a push** — Browse is index 3 of the
home tabs router, and the shipped pattern in these files is
`AutoTabsRouter.of(context).setActiveIndex(n)`. Carried into criteria AC-06,
AC-11, AC-13, AC-14, AC-15, AC-16, AC-17.

CRITICAL-3 (raised as related) — RESOLVED 2026-08-24. A retry affordance on a
no-results state does not read as apologising here; site 1 keeps today's
`GamesFetched` re-dispatch and only its presentation and copy change. Confirms
ASSUMPTION-4 below.

Factual note, no decision needed: `gate-decisions.md` cites
`auto_route_config.dart:28` under `config/router/`; the file on disk is
`lib/config/route/auto_route_config.dart` and line 28 is the Browse child route as
described. Tab order is featured 0, games 1, tracker 2, browse 3, settings 4.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION-1: Headline type step not named by §3.2. Assuming the Section heading
role of §1.2's app ramp — 22 / 1.2, display 700, caps — the only caps display step
that is neither a screen headline (34/32) nor the 12px zone label. 22 is even, so
this does not repeat the 15px collision of items 1.9, 2.2 and 2.5 and needs no new
token.

ASSUMPTION-2: Supporting-line type step not named. Assuming §1.2's Lead role,
resolved at **16** / 1.45 body 400 — the even end of its 15–16 range. Flagged
explicitly because the constraint list asked for the odd-value case to be raised:
the range holds a legal even value, so no 15px token is required here.

ASSUMPTION-3: Copy for sites 3, 4 and 5 does not exist. Assuming new keys added to
both `intl_en.arb` and `intl_zh.arb`, phrased to invite the next step — no "sorry",
no "nothing found" framing, no exclamation marks, no emoji or dingbats (§1.9, and
item 2.3's precedent for stripping them).

ASSUMPTION-4: Action behaviour at sites 1 and 2 unspecified. Assuming both keep the
callback they run today (the `GamesFetched` re-dispatch; `onMarkNowPlaying`) —
"preserve what ships", per items 1.9 and 2.5. Only presentation and copy change
there. Confirmed by the human at the gate (CRITICAL-3).

ASSUMPTION-5: Reuse of existing strings unspecified. Assuming `no_results_found`,
`no_game_in_progress` and `mark_something_playing` are reused rather than
duplicated, with the trailing `→` dropped from `mark_something_playing` in both
locales — the component supplies the affordance, and §1.9 bans dingbats in copy.

ASSUMPTION-6: Caps mechanism unspecified. Assuming strings are authored in normal
case in the `.arb` files and the caps treatment belongs to the type role, so it is
a no-op for the Chinese locale.

ASSUMPTION-7: Glyph per site unspecified. Assuming each call site supplies its own
glyph and the component defaults none; outline-only per §1.9; site 2 keeps the play
glyph it renders today.

ASSUMPTION-8: Interaction between sites 4 and 5 unspecified. Assuming site 5's
empty state occupies exactly the slot `SizedBox.shrink()` occupies today (so no
section heading renders above it), and that the two are mutually exclusive by their
own conditions — site 5 fires only when there is no countdown game *and* no weekly
releases, site 4 only when a countdown game exists and the weekly list is empty.
Exactly one empty state renders per countdown section.

ASSUMPTION-9: Outer spacing unspecified. Assuming the component carries none, per
the standing "No spacing of its own" convention from item 1.1; callers keep owning
their surrounding layout.

ASSUMPTION-10: Card border unspecified. Assuming fill only, with no border —
CRITICAL-1 resolved to a filled raised surface, which needs none. No dashed stroke
survives at site 2 (§0 item 6).

The ten above stood unchanged at the human gate. The seven below are new this
pass, all consequences of the two gate rulings.

ASSUMPTION-11: Sites 1 and 2 have no supporting line, and site 1 has no recruiting
action label. Now that the anatomy is fixed at headline + one line + one action,
assuming new keys in both locales for site 1's supporting line and action label and
site 2's supporting line, phrased under ASSUMPTION-3's tone rule. Assuming
`S.current.retry` is *not* reused as site 1's label — the behaviour stays a
re-dispatch (CRITICAL-3) but the word "retry" is error copy.

ASSUMPTION-12: Site 3's cleared-selection action has no defined behaviour when no
genre is selected, and the shipped `onGenreToggled` handles one genre per call
(each toggle saves and reloads). Assuming a single tap produces exactly one save and
exactly one reload of the section regardless of how many genres were selected, and
that with nothing selected it resolves to reloading the section unfiltered. No new
destination is introduced either way.

ASSUMPTION-13: "Standard card radius" not resolved to a step. Assuming the shipped
`lg` radius token (16) — the value all four incumbent empty-state containers
already use.

ASSUMPTION-14: Content colours unnamed. Assuming `ink` for the headline and `ink70`
for the supporting line; the action label's colour comes from the shared button
widget, not from this component.

ASSUMPTION-15: Glyph size unspecified. Assuming one fixed even size owned by the
component rather than a caller parameter, at site 2's shipped 44.

ASSUMPTION-16: "One line" is a copy constraint, not a layout clamp. Assuming one
sentence of supporting copy with no `maxLines`/ellipsis, so longer Chinese copy
wraps rather than truncating.

ASSUMPTION-17: Component height unspecified. Assuming intrinsic height and full
available width — the incumbent fixed 160px and 170px boxes at sites 3 and 4 are
not carried over.

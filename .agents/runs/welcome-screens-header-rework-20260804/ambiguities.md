# Ambiguities Report
Source: Ticket `W1-6.1R` — "Welcome screens header rework (item 6.1)", amending
`.agents/runs/welcome-screens-20260802/tech-ac.md` (ref `W1-6`)
Date: 2026-08-04

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

The ticket's one flagged open question — the ten unused localisation keys — is explicitly
delegated to "the Tech Lead/BA to make explicit, not assume", comes with a stated
recommendation and a stated precedent, and forces no business decision. It is decided
below as `DECISION-1` rather than escalated. Blocking the pipeline on a call the ticket
handed to this role would be a misread.

## DECISIONS (ticket-delegated, made explicit here)

DECISION-1: Unused localisation keys — remove all ten from both `lib/l10n/intl_en.arb`
and `lib/l10n/intl_zh.arb`: `welcome_chip_one`, `welcome_chip_two`,
`welcome_stat_tracked`, `welcome_stat_hours`, `welcome_stat_playing`,
`welcome_social_proof`, `welcome_countdown_title`, `welcome_countdown_days`,
`welcome_countdown_hours`, `welcome_countdown_minutes`.
  Rationale: every consumer is deleted by this run, item 6 set the precedent when it
  removed `onboarding_description_one/two/three`, and the change is trivially reversible
  if the art is ever reverted to composed widgets.
  Recorded as `[W1-6.1R.14]`.
  Reversal cost if the Product Owner disagrees: one revert of two `.arb` files.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: The `playing` key is **not** removed, despite becoming unused when the status
chip goes. The ticket listed ten keys to remove and a separate list of keys that stay, and
`playing` is on neither list — the two lists do not partition item 6's key set. Removing
a key the ticket did not name is riskier than leaving one unused, and the ticket already
accepts unused leftovers for the token layer. Note for the Product Owner: `playing` is a
generic status string a later game-status feature may well reuse, which is a second reason
to keep it. `AppStatusTokens.playing` is a colour token, unrelated, untouched.

ASSUMPTION: "Content image, centered" means scaled down to fit wholly inside the hero,
aspect preserved, no crop, centered on both axes. Cropping would clip the baked-in text
these images exist to show.

ASSUMPTION: `welcome-2-header-bg.png` covers screen 2's hero and crops its overflow rather
than fitting inside it. Fitting would letterbox and expose the container colour at an
edge — the exact flat fill this ticket removes.

ASSUMPTION: Both content PNGs are transparent-background overlays composited onto the
layer beneath (indigo fill on screen 1, background image on screen 2). Verified by
inspecting the three files on disk; all three exist and `assets/images/` is already
registered in `pubspec.yaml`.

ASSUMPTION: The three images are decorative for accessibility and carry no semantic label.
Labelling them would require new user-facing copy and new localisation keys, which this
ticket forbids; the content is illustrative stand-in material.

ASSUMPTION: All locales receive the same three PNGs. **Product Owner visibility, not a
blocker:** the images have English text baked in — "YOUR LIBRARY", "Playing",
"Games / Hours / Platforms", "WISHLISTED · PS5", "SILENT HOLLOW II", "DAYS / HRS / MIN".
The `zh` build will therefore show English hero art where item 6 showed translated
strings, and `DECISION-1` deletes the translations that covered it. No Chinese asset was
supplied and none can be invented here, so there is no second option this run could take
— it is a consequence of the flat-art decision, recorded so nobody discovers it in QA and
files it as a defect. If Chinese hero art is wanted, it is a follow-up ticket with new
assets.

ASSUMPTION: Removing the social-proof row removes its surrounding spacing with it, leaving
no gap. "Nothing replaces it" reads as the row and its rhythm both going.

ASSUMPTION: `[W1-6.12]` is amended rather than contradicted. The ticket did not list it as
superseded, yet requirement 1 explicitly restates screen 2's fill, so the later explicit
statement governs the fill clause and the criterion's height and radius survive.

ASSUMPTION: Text content baked into the images is not required to match item 6's strings.
It already differs ("Games / Hours / Platforms" against `Tracked / Hours / Playing`,
"SILENT HOLLOW II" against `NEON VESPER`), consistent with all of it being stand-in art.

ASSUMPTION: No fallback or error widget is added for a failed image load. Inventing error
UI for a bundled asset would be unrequested scope; the hero container still renders.

ASSUMPTION: The two failures `orchestrator-state.md` records as pre-existing in
`test/widget/onboarding/welcome_screen_test.dart` are this run's to resolve, since that
file is rewritten here. The baseline exemption still covers every other recorded
pre-existing failure. Recorded as `[W1-6.1R.20]`.

ASSUMPTION: This run needs no manual localisation regeneration. It adds no key, so no new
`S` accessor is needed and the branch compiles as-is; the stale accessors for the ten
removed keys survive in `lib/generated/` until a human regenerates and must not be
hand-deleted. `[W1-6.35]`'s halt does not apply here.

# Ambiguities Report
Source: Week 2 task brief item 1.2 + `system-foundation-specs.md` §3.2 "Status system" / §3.3 "Status chip" (with §1.2, §1.3, §1.4, §1.6, §5, §6, §7.1)
Date: 2026-08-12

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

The one candidate was §7.1 / §6's "**Open decision** — status chip hues" (violet `On hold`,
cyan `Wishlist` sit outside the closed accent palette, and §2.4 says violet "is not a UI
colour until ratified"). It is already decided elsewhere and is not open:
`roadmap-deferred.md` "Status chip hues — **RESOLVED 2026-07-30**" ratifies violet `#7d4ee0`
for On hold and link cyan `#00b0f4` for Wishlist, withdraws the 55%-ink fallback, and the
decision is already materialised in `lib/config/theme/tokens/app_status_tokens.dart` +
`app_color_tokens.dart` for all six statuses. Nothing to decide; `system-foundation-specs.md`
§6/§7.1 is stale on this point and should be corrected when someone next touches it.

## ASSUMPTIONS (minor — pipeline may proceed)
ASSUMPTION: §3.2 ("the rest on 8% ink") and §3.3 ("`rgba(0,0,0,.42)` + `--blur-glass`") give
two different capsule fills for the same component. Read as one fill per variant, not a
contradiction: the list variant sits on a solid app surface and uses 8% ink flat; the
on-media variant sits over cover art and uses black at 42% behind the glass blur. §1.6 backs
this — 8–12% white *is* the glass chip on a surface, and the blurred capsule is specifically
the "copy over media" treatment; `game-detail-design-conventions.md` §2 likewise calls blur
"the one place blur is used in the app — it sits over media, never over the mesh".

ASSUMPTION: Playing keeps its indigo fill in both variants — it is a per-status property in
the tokens (`treatment: filled`), not a per-variant one. Only the other five change fill
between variants.

ASSUMPTION: On the filled Playing pill the dot is white, per §7.1's "Playing white on
indigo" — not the status token's `color`, which is indigo and would render an invisible dot
on an indigo fill. The token's `color` is the status hue; on a filled treatment the hue is
carried by the fill and the dot reverts to ink.

ASSUMPTION: Label colour is unspecified. Full ink in both treatments — the only value that
clears §5's AA floor at 11px on both a 42%-black capsule and an indigo fill.

ASSUMPTION: Count colour is unspecified. De-emphasised relative to the label: `ink55` on the
five tinted states (mirroring §3.3's filter/count chip, "`--color-ink` label + `--color-ink-55`
count"), full ink on the filled Playing pill — 55% white over `#5865f2` measures ~3.1:1 and
fails §5's AA at 11px, while full white measures ~4.6:1 and passes.

ASSUMPTION: Interior capsule padding is not given for this primitive (§3.3 gives it for the
filter chip, context chip, stat pill and countdown tile, but not this row). Using §1.3's
8px scale: `4` vertical / `8` horizontal on-media, `4` vertical / `12` horizontal list, with
a `6` gap between dot, label and count — 6 being the same small gap §3.3 fixes for progress
dots. All are scale values, so a later correction is a number swap, not a rework.

ASSUMPTION: The count is an optional integer and renders exactly as given, including `0`.
Zero is the point of §3.2's "a filter never reads as a dead end" — the count is what tells
someone a status is empty before they tap it, so the chip neither hides itself nor drops the
number at zero. No abbreviation (§4's `2.4M` rule): no formatting helper exists in the repo
and a per-status library count does not reach that magnitude.

ASSUMPTION: The status label is resolved inside the widget from the status value, not passed
in as a string. The six statuses are a closed set whose copy does not vary by caller, so a
`label` parameter would only let two screens drift apart. This differs from item 1.1's
`ZoneLabel`, where the label genuinely varies per caller.

ASSUMPTION: The chip is display-only. §3.3 gives it no press, hover or hit-target rule, and
the interactive counterpart is item 1.5's filter/count chip. A caller that needs a tap wraps
it, so §5's 44px floor is the caller's concern.

ASSUMPTION: This run ships the component unwired and touches neither
`lib/widgets/saved_game_status_tag.dart` nor its one caller. Its `Status` enum is the legacy
tracker set (`toBuy`, `notStarted`, `ragedQuit`, `inProgress`), not the six spec statuses, so
there is no mapping to swap in; its single use in
`lib/features/tracker/presentation/screens/tracker_game_detail_screen.dart` is hardcoded to
`Status.notStarted` inside a no-op `InkWell`. The task brief puts the tracker → library
status migration in week 3 and assigns the game-card status overlay to item 2.1. Marking it
`@Deprecated` now would also add a new deprecation lint on that live caller against a clean
baseline. Flagged for Tech Lead to overturn if it disagrees.

ASSUMPTION: §1.8's press and hover states are not built — Android-only target, and a
non-interactive chip has neither.

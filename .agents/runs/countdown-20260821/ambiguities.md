# Ambiguities Report
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.3 — Countdown + Countdown tile
Date: 2026-08-21

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

Two spec disagreements were found and both resolve from context rather than needing a decision, so
neither is raised as critical. Both are recorded as assumptions below and are the two most likely
things a human would want to overrule at this gate:

- The card's fill (§3.2 "raised-indigo card" vs `home-screen-design-conventions.md` §4.1
  `--surface-raised`) — resolved by the precedence rule stated at `system-foundation-specs.md`
  lines 6–8. See ASSUMPTION-1.
- Whether the card keeps a cover thumbnail — no spec lists one, the current implementation has one.
  See ASSUMPTION-2.

The rewiring question is not an ambiguity: the checklist settles it (single known caller, rewire in
this item).

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION-1: "Raised-indigo card" (§3.2) is the raised surface token `#2F333C`, not the indigo
panel `#2F3782`. `system-foundation-specs.md` lines 6–8 give the screen conventions doc precedence
for its own screen; `home-screen-design-conventions.md` §4.1 names `--surface-raised`; §1.1 reserves
the indigo panel for the hero card and sheet header; and §3.2's own rationale asks for the quieter
step. Featured is the first destination in the home shell, so §4.1 governs this card.

ASSUMPTION-2: The card carries no cover thumbnail — neither §3.2 nor home §4.1 lists one, though
the current card has an 80×110 cover (`countdown_releases.dart:105–120`). Visible change from what
ships today.

ASSUMPTION-3: Card figures 22px, tile figures 30px, per the two screen specs. Both even, so no
collision with the even-number convention. `countdownFigure` and `countdownColon` type tokens
already exist and match the tile form.

ASSUMPTION-4: The component renders a snapshot and owns no timer. home §4.1 omits seconds
explicitly so a live timer is unnecessary, and `CountdownReleasesCubit` already re-emits the
duration every 60 seconds and cancels its timer in `close()`. A widget-owned timer would duplicate
that and is the likely leak.

ASSUMPTION-5: Wishlist provenance is left as today's inference (game id present in the local
library id set), which over-triggers because that set is every saved game, not just wishlisted
ones. A truthful cyan line would need one boolean carried from the repository's wishlist-first
selection through the use case and state — deliberately not done, so the cubit, state and use cases
stay untouched (C19). Overrule if the literal wording of the wishlist line matters more.

ASSUMPTION-6: Copy is unspecified everywhere. New strings follow §4 and are added as l10n keys in
both existing locales; `wishlist`, `wishlist_upcoming_game` and `reminder` already exist for reuse.

ASSUMPTION-7: Unit labels are `DAYS` / `HRS` / `MIN` (home §4.1, welcome §3c), replacing today's
`Days` / `Hrs` / `Mins`.

ASSUMPTION-8: The countdown gets one semantics label announcing the remaining time in words. Not in
any design doc; follows §5 and item 2.2's precedent.

ASSUMPTION-9: The released-state wording is unspecified; only its shape and colour are constrained
(short caps line, no green, no digits).

ASSUMPTION-10: The tile form ships with no caller. Its only spec'd host — welcome screen 2's hero —
was replaced by flat PNG art in item 6.1, and `onboarding-welcome-design-spec.md` §3c is marked
superseded. Same situation as the completion ring in item 2.2.

ASSUMPTION-11: The Remind action renders only when a handler is supplied, so nothing ships as a
dead affordance. No notification capability exists (`pubspec.yaml` has none, and
`roadmap-deferred.md` defers the notification centre), so `featured` supplies no handler this run
and no Remind button appears on the screen — the affordance exists in the component and is
exercised by tests only.

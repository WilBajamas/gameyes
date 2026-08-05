# Ambiguities Report
Source: W1-8 — `.agents/week-1-task-briefs.md` § "8 — Route guard and session",
as amended by `decisions.md` (Product Owner, 2026-08-05)
Date: 2026-08-05

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

CRITICAL-1 (guard scope) was answered at the Phase 1 gate: option B **plus**
deep-link resume. See `decisions.md` DECISION-1. It is settled and folded into
`tech-ac.md` (W1-8-AC01, AC02, AC08–AC12). ASSUMPTION 7 was confirmed in scope
by DECISION-2 (W1-8-AC10, AC11).

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION 1: Signed-in beats onboarding-unseen. A signed-in status routes to the
tab shell even when the `first_use` flag is absent or false; the flag is only
consulted for a signed-out user. Confirmed unchanged by the Product Owner.
  Precedence note: this meets ASSUMPTION 8 (leave the existing onboarding guard
  alone) in one case — signed-in with the flag unset. ASSUMPTION 1 is the more
  specific rule and governs, so the guard chain on `/` must not divert a
  signed-in user into onboarding. No change is made to when the flag is written,
  so ASSUMPTION 8 is otherwise intact. Not re-escalated: both assumptions were
  put to the Product Owner and confirmed, and this reading follows from the
  ticket's "authenticated users go straight to the main tab shell".

ASSUMPTION 2: A guard redirect replaces the navigation stack rather than pushing
onto it, so after a forced sign-out the system back gesture cannot return to a
protected screen. The ticket says the user is "returned to sign-in" but does not
state stack behaviour.

ASSUMPTION 3 (superseded in part by DECISION-1): A signed-in emission resumes the
route the user originally requested. Only when no requested route was recorded is
the destination the tab shell root — that half of the original assumption stands.

ASSUMPTION 4: The reactive redirect applies from whatever route is on screen, and
is a no-op when the app is already on the correct destination, so a repeat
emission of the same status does not push a duplicate route or loop.

ASSUMPTION 5: No user-facing message accompanies a forced return to sign-in (no
snackbar, dialog or banner explaining the expiry). The ticket asks for none, and
per `handover.md` new localisation keys cannot be made to compile by an agent,
so a silent redirect is the safe choice.

ASSUMPTION 6: "An expired session" needs no separate detection. Item 5's status
stream already reports a null-session or errored auth event as signed-out, so
expiry and explicit sign-out arrive as the same signed-out emission and the guard
treats them identically.

ASSUMPTION 7 (confirmed by DECISION-2): The signed-in direction is this item's
work — a signed-in emission must move the user off the sign-in screen to their
destination.

ASSUMPTION 8: The existing onboarding guard stays in place and the `first_use`
write rules are untouched; the auth guard is added alongside it. This run reads
onboarding-seen state and never writes it. Subject to the precedence note under
ASSUMPTION 1.

ASSUMPTION 9 (new this pass): If the auth status is not yet available when a
guarded navigation is resolved — the cold-start race the ticket does not
describe — it is treated as signed-out. Failing closed never leaks a protected
screen; the correct destination follows from the first real emission.

ASSUMPTION 10 (new this pass): The pending requested route is held for the app
session only and is not persisted across a process restart. DECISION-1 asks for
resume after sign-in, not resume after relaunch; persisting it would add storage
and a staleness policy that nothing in the ticket calls for.

# Ambiguities Report
Source: W1-8 — `.agents/week-1-task-briefs.md` § "8 — Route guard and session"
Date: 2026-08-05

## CRITICAL (pipeline blocked — requires human decision before proceeding)

CRITICAL-1: W1-8 — Which routes the authentication guard protects is undefined,
and the ticket's two relevant sentences pull in opposite directions.
"unauthenticated users are routed to the onboarding flow" implies app-wide
gating; "Preserve the existing tab structure and deep links" can be read as
leaving today's reachability untouched. Today only `/` (the tab shell and its
five children) carries a guard. Four content routes are declared at the router
root with their own paths and are reachable by deep link with no guard at all:
`/game-detail`, `/tracker-detail`, `/task-detail`, `/image-view`. `/legal` is
also unguarded and must stay that way — the sign-in screen's terms and privacy
links open it, so gating it would make sign-in unusable. So "guard everything"
is not a mechanical default; it needs a deliberate carve-out list, which is a
product decision about whether app content is readable while signed out.
  Options:
    A) Guard `/` only — the auth guard sits alongside the existing onboarding
       guard on the tab shell. Deep links to `/game-detail`, `/tracker-detail`,
       `/task-detail` and `/image-view` keep working for a signed-out user
       exactly as they do today. Smallest diff, no change to deep-link
       behaviour, but signed-out users can read content through a link.
    B) Guard `/` plus the four content routes, with `/onboarding`, `/auth` and
       `/legal` explicitly unguarded. A signed-out deep link lands on the auth
       screen (or welcome screen 1 if onboarding was never seen) instead of the
       requested content. Closes the hole; changes deep-link behaviour for
       signed-out users, which may be what "preserve deep links" forbids.
  Recommended: B, on the reading that gating the shell but not the detail
    screens leaves the guard trivially bypassable — but this is a product call
    on whether QuestLoggd content is public, not a technical one, so it is not
    being taken unilaterally. Note that under B the post-sign-in destination is
    the tab shell root, not the originally requested deep link (see ASSUMPTION
    3); if the requested route should be resumed after sign-in instead, say so
    with the answer, as that is additional scope.
  Decision needed from: Product Owner

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION 1: Signed-in beats onboarding-unseen. If the auth state is signed-in
while the `first_use` flag is absent or false, the destination is the tab shell,
not welcome screen 1 — per the ticket's "authenticated users go straight to the
main tab shell". The onboarding flag is only consulted for a signed-out user.

ASSUMPTION 2: A guard redirect replaces the navigation stack rather than pushing
onto it, so after a forced sign-out the system back gesture cannot return to a
protected screen. The ticket says the user is "returned to sign-in" but does not
state stack behaviour.

ASSUMPTION 3: After a reactive signed-in emission the destination is the tab
shell root. No pre-expiry route or pending deep link is stored and resumed —
"go straight to the main tab shell" is taken literally.

ASSUMPTION 4: The reactive redirect applies from whatever route is on screen,
and is a no-op when the app is already on the correct destination, so a repeat
emission of the same status does not push a duplicate route or loop.

ASSUMPTION 5: No user-facing message accompanies a forced return to sign-in
(no snackbar, dialog or banner explaining the expiry). The ticket asks for none,
and per `handover.md` new localisation keys cannot be made to compile by an
agent, so a silent redirect is the safe choice.

ASSUMPTION 6: "An expired session" needs no separate detection. Item 5's status
stream already reports a null-session or errored auth event as signed-out, so
expiry and explicit sign-out arrive as the same signed-out emission and the
guard treats them identically.

ASSUMPTION 7: The forward direction of the reactive requirement is in scope.
The ticket spells out only sign-out and expiry, but nothing in the app currently
navigates away from the sign-in screen after a successful sign-in, and no other
week-1 item owns that. So a signed-in emission must move the user to the tab
shell, otherwise "authenticated users go straight to the main tab shell" is
unreachable in practice. Flagging rather than burying it: if this belongs to a
later item, say so.

ASSUMPTION 8: The existing onboarding guard's behaviour and the `first_use`
write rules stay as they are. The auth guard is added alongside it; this run
reads onboarding-seen state and never writes it.

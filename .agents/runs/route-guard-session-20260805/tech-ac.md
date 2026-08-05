# Technical Acceptance Criteria
Source: W1-8 — `.agents/week-1-task-briefs.md` § "8 — Route guard and session",
as amended by `decisions.md` DECISION-1 and DECISION-2 (Product Owner, 2026-08-05)
Date: 2026-08-05
BA Agent version: 1.0

## Feature summary

Add an authentication guard to the router so that reaching any protected route
requires a signed-in auth status, and so that a change in that status re-routes
the running app with no restart. Signed-out and onboarding-seen are two separate
inputs: a signed-out user who has already seen onboarding goes to the sign-in
route, one who has not goes to the first welcome screen. Protected routes are the
tab shell with its five children plus the four root-level content routes;
onboarding, auth and legal stay open. A blocked navigation records the route that
was requested, and a later signed-in status resumes it; with nothing recorded,
a signed-in status lands on the tab shell root. Existing tab structure, route
paths and signed-in deep-link behaviour are unchanged.

## Technical acceptance criteria

### Guard scope

[W1-8-AC01] ROUTING: The auth guard applies to `/` (and therefore its five
children `featured`, `games`, `tracker`, `browse`, `settings`) and to the four
root-level content routes `/game-detail`, `/tracker-detail`, `/task-detail` and
`/image-view`.
  Failure case: a navigation to any of these routes that does not pass through
  the auth guard is a defect, including a navigation started from inside the app
  rather than from a deep link.

[W1-8-AC02] ROUTING: `/onboarding`, `/auth` and `/legal` carry no auth guard and
resolve for any auth status, including signed-out with the onboarding-seen flag
absent.
  Failure case: if any of the three redirects while signed out, sign-in becomes
  unreachable (the sign-in screen's terms and privacy links open `/legal`).

[W1-8-AC03] ROUTING: With auth status signed-in, a navigation to any guarded
route resolves to the requested route with no redirect and no change to its
arguments.
  Failure case: a signed-in user is redirected, or arrives at the route with
  arguments dropped, so deep links regress for signed-in users.

[W1-8-AC04] ROUTING: With auth status signed-out and the onboarding-seen flag
`true`, a navigation to any guarded route is redirected to `/auth`.
  Failure case: the user lands on the first welcome screen instead of sign-in,
  which is the exact regression the ticket's third sentence names.

[W1-8-AC05] ROUTING: With auth status signed-out and the onboarding-seen flag
absent or `false`, a navigation to any guarded route is redirected to
`/onboarding` at welcome screen 1.
  Failure case: a first-time user is dropped straight on sign-in and never sees
  the welcome flow.

[W1-8-AC06] ROUTING: With auth status signed-in and the onboarding-seen flag
absent or `false`, a navigation to `/` reaches the tab shell; the guard chain on
`/` must not divert that user to `/onboarding`.
  Failure case: a signed-in user is trapped in onboarding, or the onboarding-seen
  flag gets written by this run to work around it (writing that flag is out of
  scope).

[W1-8-AC07] ROUTING: The guard decides from the auth status current at the moment
the navigation is resolved, not from waiting for the next stream emission. If no
status is available yet, the navigation resolves as signed-out.
  Failure case: a cold start renders a guarded screen for an unknown status, or
  the app hangs on an unresolved navigation at launch.

### Pending requested route (deep-link resume)

[W1-8-AC08] SESSION: When the guard blocks a navigation to a guarded route, the
requested route is recorded as the pending route, including its path arguments
and any query parameters, replacing any previously recorded pending route.
  Failure case: the route is recorded without its arguments, so the resume lands
  on a detail screen with no subject.

[W1-8-AC09] SESSION: A navigation that the guard allows (signed-in), and any
navigation to `/onboarding`, `/auth` or `/legal`, records no pending route and
leaves an existing pending route untouched.
  Failure case: browsing to `/legal` from the sign-in screen overwrites the
  pending deep link, so the resume goes to the wrong place.

[W1-8-AC10] SESSION: A signed-in emission while a pending route is recorded
navigates to that pending route and clears the record.
  Failure case: the user lands on the tab shell root instead of the route they
  followed, or the record is left set and a later sign-in re-opens a stale route.

[W1-8-AC11] SESSION: A signed-in emission with no pending route recorded
navigates to the tab shell root `/` on its existing initial tab.
  Failure case: the user stays on the sign-in screen after a successful sign-in,
  or the app opens on a different tab than it does today.

[W1-8-AC12] SESSION: The pending route survives the onboarding hop — recorded at
welcome screen 1 (per W1-8-AC05), it is still resumed after the user completes
onboarding, reaches `/auth` and signs in.
  Failure case: the record is dropped when onboarding replaces its route, so a
  first-time user's deep link is lost.

### Reactive auth status

[W1-8-AC13] SESSION: The guard subscribes to the auth status stream for the life
of the app and reacts to every emission, not only the first.
  Failure case: a second sign-out in the same app session does nothing, or two
  subscriptions cause each emission to be handled twice.

[W1-8-AC14] SESSION: A signed-out emission while the app is on a guarded route
redirects immediately, using the same seen-flag branch as W1-8-AC04 and
W1-8-AC05, with no app restart.
  Failure case: the user keeps reading a protected screen after their session
  ends, or the redirect only takes effect on the next manual navigation.

[W1-8-AC15] SESSION: A guard redirect replaces the navigation stack, so after a
forced return to sign-in the system back gesture cannot reach a guarded route.
  Failure case: back from `/auth` re-enters the tab shell or a detail screen
  while signed out.

[W1-8-AC16] SESSION: A signed-out emission while the app is on `/onboarding`,
`/auth` or `/legal` performs no navigation.
  Failure case: a stream replay at launch kicks the user off the welcome screens
  or interrupts an in-progress sign-in.

[W1-8-AC17] SESSION: An emission that repeats the status the app is already
settled on is a no-op — no duplicate route is pushed and no redirect loop occurs.
  Failure case: repeated emissions stack duplicate `/auth` entries or the app
  loops between two routes.

[W1-8-AC18] SESSION: The guard derives its decision only from the auth status
stream's signed-in/signed-out values; an expired session and an explicit sign-out
are handled identically because both reach the guard as signed-out. No separate
expiry detection is added here.
  Failure case: the guard inspects session or token internals directly, which is
  item 5's territory, or an error on the stream goes unhandled and no redirect
  happens.

[W1-8-AC19] SESSION: A forced return to sign-in shows no snackbar, dialog or
banner, and this run adds no new localisation key.
  Failure case: a new `S` key is introduced, which cannot be made to compile
  without the IDE plugin and will break the build.

### Preserved behaviour

[W1-8-AC20] ROUTING: The route table's existing paths, the tab shell's five
children and their order, and the initial route are unchanged.
  Failure case: any existing deep-link URL resolves to a different screen for a
  signed-in user than it does today.

## Out of scope

- Building or changing any screen the guard routes to — the welcome screens, the
  sign-in screen and the tab shell already exist.
- Changing when or how the onboarding-seen flag is written. This run reads it.
- Session token refresh and persistence inside the auth data layer (item 5).
- Configuring Discord, Google or Supabase provider credentials (items 0.3, 0.4,
  0.6 — deferred by the product owner). No real provider is needed to build or
  test the guard.
- Guarding `/onboarding`, `/auth` or `/legal` (DECISION-1).
- Signing the user out, refreshing a session, or any other write to auth state —
  this run only observes.
- Constraint, not a criterion: the router is code-generated, so the regenerated
  `*.gr.dart` output is an expected part of the diff and must be consistent with
  the route table.
- Constraint, not a criterion: no golden tests, per the project's execution rules.

## Assumptions

ASSUMPTION 1: Signed-in beats onboarding-unseen — a signed-in user goes to the
tab shell even with the seen flag absent or false. Confirmed unchanged by the
Product Owner. Where this meets ASSUMPTION 8 (the existing onboarding guard is
left as it is), ASSUMPTION 1 is the more specific rule and governs: the combined
guard chain on `/` must not divert a signed-in user into onboarding
(W1-8-AC06). No change is made to when the flag is written.

ASSUMPTION 2: A guard redirect replaces the navigation stack rather than pushing
onto it (W1-8-AC15).

ASSUMPTION 3 (as superseded by DECISION-1): A signed-in emission resumes the
recorded pending route; only when nothing is recorded is the destination the tab
shell root.

ASSUMPTION 4: The reactive redirect applies from whatever route is on screen and
is a no-op when the app is already at the correct destination (W1-8-AC17).

ASSUMPTION 5: No user-facing message accompanies a forced return to sign-in
(W1-8-AC19).

ASSUMPTION 6: "An expired session" needs no separate detection; it arrives as a
signed-out emission (W1-8-AC18).

ASSUMPTION 7 (confirmed by DECISION-2): The signed-in direction — moving the user
off the sign-in screen to their destination — is this item's work.

ASSUMPTION 8: The existing onboarding guard stays in place and this run never
writes the onboarding-seen flag, subject to the precedence noted under
ASSUMPTION 1.

ASSUMPTION 9 (new this pass): If the auth status is not yet available when a
guarded navigation is resolved, it is treated as signed-out (W1-8-AC07). Failing
closed is the safe default; the ticket does not describe the cold-start race.

ASSUMPTION 10 (new this pass): The pending requested route is held in memory for
the app session only — it is not persisted across a process restart. The ticket
asks for resume after sign-in, not resume after relaunch.

# Technical Acceptance Criteria
Source: W1-8.1 — `source-request.md` (Product Owner ticket, 2026-08-05),
follow-up to W1-8
Date: 2026-08-05
BA Agent version: 1.0

## Feature summary

Give the Settings screen a sign-out control that runs the existing sign-out
path and nothing else. The control is a permanent part of the app, not debug
scaffolding, and is not gated on a flag, flavour or build mode. A single tap
starts the sign-out immediately, with no confirmation step. The screen performs
no navigation of its own on any outcome — where a signed-out user goes is
already decided by the shipped auth-status mechanism from W1-8, and a second
navigation path here would race it and would invalidate the four manual checks
this work exists to unblock (W1-8 manual checks 2, 9, 10 and 13). A failed
sign-out surfaces as an inline error inside the control's own section,
following the product brief's per-section error convention and matching how the
sign-in screen reports a failed sign-in; it never becomes a full-page error, a
snackbar or a dialog. Every user-facing string comes from the localisation
layer.

## Technical acceptance criteria

### The control

[W1-8.1-AC01] UI: The Settings screen renders exactly one sign-out control,
present on every render of the screen, with its visibility not conditioned on a
debug flag, a build flavour, `kDebugMode` or any equivalent build-mode check.
  Failure case: the control exists only in a debug build, so the beta ships
  with no way to sign out and the four blocked W1-8 manual checks stay blocked
  on any release build.

[W1-8.1-AC02] PRESENTATION: A single tap on the control starts the sign-out
immediately. No confirmation dialog, bottom sheet, second tap or any other
intermediate step stands between the tap and the sign-out call.
  Failure case: a confirmation step is added, slowing the manual checks this
  unblocks and contradicting the ticket's settled decision.

[W1-8.1-AC03] PRESENTATION: One tap produces exactly one sign-out call. While a
sign-out is in flight, further taps on the control start no additional call.
  Failure case: rapid taps queue several sign-out calls, producing overlapping
  results and an unpredictable final state.

[W1-8.1-AC04] UI: While a sign-out is in flight the control renders a visually
distinct pending state, and it returns to its resting state once the result
arrives (either outcome).
  Failure case: the control looks idle during a slow or hanging sign-out, so
  the user cannot tell whether the tap registered.

### No navigation from this feature

[W1-8.1-AC05] ROUTING: Neither the Settings screen nor any state object added
by this feature performs any route action — push, replace, pop, navigate back
or otherwise — as a result of the tap or of either outcome of the sign-out.
  Failure case: the screen navigates on success, racing W1-8's guard and
  status-driven redirect. This both risks a duplicated or conflicting
  transition and hides whether W1-8's reactive path actually works, which is
  the entire reason the four blocked manual checks are being unblocked. This is
  the ticket's single most important constraint.

[W1-8.1-AC06] PRESENTATION: This feature introduces no second reaction to a
signed-out auth status. It observes auth status only insofar as it needs the
result of its own sign-out call, and derives no routing behaviour from it.
  Failure case: a duplicate listener re-implements what W1-8 already ships, so
  the two mechanisms can disagree and W1-8's behaviour can no longer be
  verified in isolation.

[W1-8.1-AC07] UI: On a successful sign-out the screen renders no success
message, snackbar, dialog or banner, and shows no confirmation of any kind.
  Failure case: any transient message during the redirect fails W1-8's
  `[W1-8-AC19]` silent-redirect criterion and W1-8 manual check 13.

### Failure handling

[W1-8.1-AC08] UI: A failed sign-out renders an inline error message within the
sign-out control's own section of the Settings screen. The rest of the screen
continues to render its existing content unchanged.
  Failure case: a full-page or whole-screen error state replaces the Settings
  content, breaking the product brief's per-section inline error convention.

[W1-8.1-AC09] UI: The failure is reported by that inline message only — no
snackbar, no dialog, no banner, no route change.
  Failure case: a snackbar or dialog appears, requiring dismissal and polluting
  exactly the surface W1-8 manual check 13 inspects for silence.

[W1-8.1-AC10] PRESENTATION: Every non-success outcome of the sign-out call
reaches the inline error state. No outcome leaves the control back in its
resting state with nothing shown, and no error escapes as an unhandled
exception.
  Failure case: an offline or backend-unreachable sign-out silently does
  nothing, so the control reads as broken.

[W1-8.1-AC11] PRESENTATION: After a failure the control is tappable again, a
further tap starts a fresh sign-out, and the inline error clears as that new
attempt begins.
  Failure case: the control is left permanently disabled, or a stale error
  stays on screen alongside a new attempt.

### Strings and existing content

[W1-8.1-AC12] L10N: Every user-facing string this feature adds is resolved
through the localisation layer, and every key it introduces exists in both
locale files. No user-facing string literal is hard-coded in a widget.
  Failure case: an English literal ships untranslatable, or a key present in
  only one locale file fails at runtime in the other locale.

[W1-8.1-AC13] UI: No existing Settings screen content, layout, scroll behaviour
or app bar changes, beyond the addition of the sign-out section itself.
  Failure case: unrelated Settings changes ride along in the diff, widening
  review and regression surface for a follow-up ticket.

## Out of scope

- Any change to W1-8's auth guard, auth status listener, session navigator or
  pending-route store. This run consumes all four unchanged; they decide where
  a signed-out user goes and this feature must not duplicate or pre-empt them.
- Any other Settings screen content, layout or feature.
- A confirmation ("are you sure?") step, account deletion, or any other account
  management action.
- Clearing cached app data, saved tracker content or stored preferences on
  sign-out, including the onboarding-seen flag. The action is the existing
  sign-out path and nothing more (see `ambiguities.md` ASSUMPTION 9).
- The sign-in loading-state gap found during W1-8's manual checks (idle is
  emitted as soon as the OAuth browser opens, so nothing shows while sign-in is
  in flight). Real, logged in W1-8's `qa-report.md`, and a separate run.
- Verifying W1-8's own criteria. Running the four unblocked manual checks
  (W1-8 checks 2, 9, 10, 13) is W1-8's outstanding work, not a criterion here;
  this run only has to make them runnable.
- Hand-writing or otherwise faking the generated localisation accessor. New
  keys go into both `.arb` files and are then flagged for human IDE
  regeneration (`handover.md` gotcha #1).

## Assumptions

ASSUMPTION: Label copy is a short "Sign out"; failure copy is one short generic
line shaped like the existing sign-in failure line. Exact wording is the
Product Owner's to change later.

ASSUMPTION: No existing localisation key fits either string — both `.arb` files
were checked — so two new keys are unavoidable and the branch will not compile
until a human regenerates the localisation output.

ASSUMPTION: No Settings design spec exists; the section is added using the
existing design token layer without restyling what is already on the screen.

ASSUMPTION: In-flight and error-persistence behaviour mirror the sign-in
screen — pending state while running, repeat taps ignored, error held until the
next attempt.

ASSUMPTION: If the backend call fails after the on-device session has already
been discarded, the user may be redirected before the inline error is readable.
Accepted; the screen makes no attempt to coordinate with that redirect.

Full detail for all of the above: `ambiguities.md`.

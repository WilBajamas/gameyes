# Ambiguities Report
Source: W1-8.1 — `source-request.md` (Product Owner ticket, 2026-08-05), a
follow-up to W1-8 (`.agents/runs/route-guard-session-20260805/`)
Date: 2026-08-05

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

The ticket pre-settles the two decisions that would otherwise have blocked:
this is a real feature rather than debug scaffolding (no flag/flavour gating),
and there is no confirmation step. Both are recorded as criteria, not
assumptions.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION 1: Control label copy is not specified. Assuming a short "Sign out"
label sourced from the localisation layer. Wording is the Product Owner's to
change later without reopening the pipeline.

ASSUMPTION 2: Failure message copy is not specified. Assuming a single short
generic line in the same shape as the existing sign-in failure line — e.g.
"We couldn't sign you out. Please try again." No error code, no provider name,
no retry button of its own (the control itself is the retry).

ASSUMPTION 3: No existing localisation key covers either string. Both
`lib/l10n/intl_en.arb` and `lib/l10n/intl_zh.arb` were checked: the nearest
candidates (`auth_sign_in_error`, `error_results`, `settings`) all mean
something else, so reusing one would ship a wrong string. Two new keys are
therefore genuinely unavoidable, and the ticket's standing rule applies — add
both keys to both `.arb` files, use `S.current.[key]`, then stop and flag for a
human IDE regeneration. **Consequence the human must expect: the branch will
not compile until that regeneration happens** (`handover.md` gotcha #1). This
is the single largest practical constraint on the run; it is an assumption
rather than a critical item only because the ticket already prescribes the
procedure.

ASSUMPTION 4: There is no design spec for the Settings screen — the screen is
currently a placeholder. Assuming the action is added as its own section using
the existing design token layer, without restyling or relocating what is
already there. Exact placement and visual treatment are a Tech Lead call, not a
new requirement.

ASSUMPTION 5: In-flight behaviour is not specified. Assuming it mirrors the
sign-in screen: the control shows a pending state while the sign-out is
running, and repeat taps during that window start nothing new.

ASSUMPTION 6: Error persistence is not specified. Assuming the inline error
stays until the next sign-out attempt begins, then clears — again mirroring
the sign-in screen, where a failure persists until a new attempt is started.

ASSUMPTION 7: Success feedback is not specified. Assuming none at all: item 8's
`[W1-8-AC19]` requires the return to sign-in to be silent, and manual check 13
watches for exactly that, so any success snackbar or banner would fail a check
this run exists to unblock.

ASSUMPTION 8: If the backend call fails *after* the on-device session has
already been discarded, the auth-status mechanism may move the user off the
Settings screen before the inline error is readable. Assuming that is
acceptable and that the screen makes no attempt to delay, suppress or
coordinate with that redirect — doing so would mean adding navigation
awareness, which requirement 2 forbids.

ASSUMPTION 9: Sign-out clears only what the existing sign-out path already
clears. No additional clearing of cached app data, saved tracker content or
stored preferences (the onboarding-seen flag included) is assumed. Requirement
1 defines the action as the existing use case and nothing more. If the Product
Owner wants local data wiped on sign-out, that is a separate ticket with its
own privacy scope.

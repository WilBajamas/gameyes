# Ticket — Sign-out action on the Settings screen

Source: Product Owner, 2026-08-05, arising from week 1 item 8's manual QA.
Ticket ID `W1-8.1`. Not a checklist item of its own — a follow-up to item 8
(`.agents/runs/route-guard-session-20260805/`).

## Why this exists

Item 8 shipped an auth guard that returns a signed-out user to the sign-in
screen without an app restart. **Four of its thirteen manual checks could not be
run**, because there is no way to sign out from inside the app:

- check 2 — the guard covers in-app navigation, and the pending route resumes
- check 9 — live sign-out redirects with no restart `[W1-8-AC14]`
- check 10 — the back gesture cannot return to a protected screen `[W1-8-AC15]`
- check 13 — the redirect is silent, no snackbar or dialog `[W1-8-AC19]`

`SignOutUseCase` (`lib/features/auth/domain/use_cases/sign_out_use_case.dart`)
is built and unit-tested from item 5, and `AuthRepositoryImpl.signOut` calls
Supabase. Nothing in the presentation layer calls any of it.

Revoking the session server-side is not a workaround: Supabase restores
`currentSession` from local storage and trusts that JWT until its own expiry, so
a revoked user stays signed in on-device until the next failed token refresh —
up to an hour on the default expiry. Confirmed on device by the Product Owner.

## Requirements

1. **Add a sign-out action to the Settings screen**
   (`lib/features/settings/presentation/screens/settings_screen.dart`), wired to
   the existing `SignOutUseCase`. Tapping it signs the user out of Supabase.
2. **Do not navigate as a result of the tap.** Item 8's `AuthGuard` and
   `AuthStatusListener` already handle where a signed-out user goes — the auth
   status stream emits `signedOut`, guards re-evaluate, and the user lands on
   the sign-in screen. Adding navigation here would race that mechanism and
   would defeat the point of the exercise, which is to verify item 8's reactive
   path end to end. This is the single most important constraint in the ticket.
3. **Handle a failed sign-out** per the project's existing error conventions —
   per-section inline, never a full-page error, matching how the sign-in screen
   reports a failed sign-in. A sign-out can fail (offline, Supabase
   unreachable), and silently doing nothing would look like a broken button.

## Confirmed decisions (do not re-litigate, do not escalate)

- **This is a real feature, not throwaway debug scaffolding.** The app requires
  an account, so a sign-out has to exist before beta regardless. Build it to the
  same standard as any other screen — the fact that it unblocks QA checks is the
  reason for its timing, not a licence to cut corners. Do not hide it behind a
  debug flag, a flavour check, or `kDebugMode`.
- **No confirmation dialog for now.** Keep the interaction to a single tap. If
  the Product Owner wants an "are you sure?" step it will be added later, and a
  dialog would slow down exactly the manual checks this unblocks.

## Scope guidance

Prefer a design that needs **no new localisation keys** — per `handover.md`
gotcha #1, the `S` class comes from an IDE plugin with no CLI, so an agent
cannot make a new string compile. Check `lib/l10n/*.arb` for an existing
suitable key first. If a new key is genuinely unavoidable, follow the standing
rule: add it to both `.arb` files, use `S.current.[key]`, then stop and flag it
for a human IDE regeneration rather than hand-writing the accessor.

## Out of scope

- Any change to `AuthGuard`, `AuthStatusListener`, `SessionNavigator` or
  `PendingRouteStore` — item 8 shipped those and this run consumes them
  unchanged.
- Any other Settings screen content, layout or feature.
- The sign-in loading-state gap also found during item 8's manual checks
  (`sign_in_cubit.dart` emits idle as soon as the OAuth browser opens, so no
  progress is shown while sign-in is in flight). Real, logged in item 8's
  `qa-report.md`, and a separate run.
- A confirmation dialog, account deletion, or any other account management.

# Ticket — Route guard and session (week 1 item 8)

Source: `.agents/week-1-task-briefs.md` § "8 — Route guard and session
[PIPELINE]", quoted verbatim below. Ticket ID `W1-8`. Handed to the pipeline
by the product owner on 2026-08-05 with the instruction "start item 8 through
the normal `/orchestrate` pipeline — feed it the spec from
week-1-task-briefs.md item 8 as the source request. New run, new branch off
`develop`."

## Requirements (verbatim from the checklist)

> Add an authentication guard to the `auto_route` configuration so unauthenticated
> users are routed to the onboarding flow and authenticated users go straight to the
> main tab shell. The guard must react to the auth state stream from item 5, so a
> sign-out or an expired session returns the user to sign-in without an app restart.
> A user who has completed onboarding but signed out should land on the auth screen,
> not on welcome screen 1. Preserve the existing tab structure and deep links.

## Context the checklist assumes

Everything this guard sits on top of is already merged to `develop`:

- **Item 5 — auth domain and data layer** (PR #19). Provides the auth
  repository and the auth-state stream this guard must react to. Both
  providers (Discord, Google) are coded and unit-tested.
- **Item 6 / 6.1 / 6.2 — welcome screens** (PR #20, PR #23). Two-screen
  welcome flow behind the existing `/onboarding` route, with a `first_use`
  "seen" flag persisted to `SharedPreferences`. Only an explicit Skip or
  Get started tap writes that flag.
- **Item 7 — auth screen** (PR #21). The sign-in screen with its two provider
  rows, driven by `SignInCubit`.

The distinction the ticket draws in its third sentence is the one that matters:
**onboarding-seen and signed-in are two independent pieces of state.** The
existing onboarding guard only knows about the first.

## Known related notes from `handover.md`

- Items 0.3 (Discord app) and 0.4/0.6 (Google + Supabase provider config) are
  **deferred by the product owner's choice**, so no real provider is wired up in
  a console yet. `handover.md` explicitly records that this does not block item
  8: "Item 8's guard reacts to the auth state stream either way — it doesn't
  need a real provider configured to be built and tested."
- `auto_route` is one of this project's code-generating packages. Router
  changes require `dart run build_runner build --delete-conflicting-outputs`,
  and the `*.gr.dart` output is an expected part of the diff.
- Adding a user-facing string is expensive here — the `S` localisation class
  comes from an IDE plugin with no CLI, so an agent cannot make new strings
  compile. Prefer a design that needs no new localisation keys; if one is
  genuinely unavoidable, follow the standing rule (add the key to both `.arb`
  files, use `S.current.[key]`, stop and flag it) rather than hand-writing the
  accessor.

## Out of scope

- Building or changing any screen this guard routes *to* — the welcome screens,
  the auth screen and the tab shell all already exist and are not this run's
  work.
- Configuring Discord/Google/Supabase provider credentials in their consoles
  (items 0.3/0.4/0.6, deferred).
- Any change to how the `first_use` onboarding-seen flag is written — items
  6/6.2 settled those rules. This run reads that state, it does not change
  when it is set.
- Session token refresh/persistence mechanics inside the auth data layer —
  item 5's territory. This run consumes the auth state stream it already
  exposes.

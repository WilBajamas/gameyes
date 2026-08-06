# Technical Acceptance Criteria
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]"
Date: 2026-08-06
BA Agent version: 1.0

## Feature summary

Wire Sentry crash reporting into app startup so that unhandled Dart errors and
Flutter framework errors are reported automatically from both flavours into one
Sentry project. Initialisation happens before `runApp` in the shared startup path.
A single DSN serves both flavours; dev and prod are separated only by Sentry's
`environment` option, driven by the active `Flavor`. Every event carries a flavour
tag and an app version tag. Event payloads must contain no email, no other
personally identifying field and no auth token; the Supabase user ID is the only
user-identifying value permitted, attached when a session exists and removed when
it ends. Startup must survive a missing, placeholder or failing Sentry
configuration without blocking the first frame. Delivery is verified by a
deliberate uncaught error raised in the dev flavour.

## Technical acceptance criteria

[10.1] STARTUP: Sentry initialisation runs in the shared startup path before
`runApp` is called, for both the dev and prod entrypoints, and after the active
flavour has been resolved.
  Failure case: if initialisation throws or the SDK is unavailable, the error is
  contained at the startup boundary, `runApp` still executes, and the app reaches
  its first frame with the same UI as before this change.

[10.2] CONFIG: Exactly one DSN value exists in the codebase and both flavours
resolve to it. No per-flavour DSN field, constant or env key is introduced.
  Failure case: a second DSN source, or a `switch (flavor)` selecting between DSN
  values, fails this criterion outright.

[10.3] CONFIG: The DSN is not committed to the repository in plaintext; it is
resolved through the project's existing obfuscated env mechanism with a
placeholder default, so a fresh checkout with no env file still builds.
  Failure case: build with no env file present must succeed and produce the
  placeholder value rather than a build-time error.

[10.4] STARTUP: When the resolved DSN is empty or equal to the placeholder
default, Sentry is left uninitialised/disabled, no event is transmitted, and
startup continues normally.
  Failure case: no exception surfaces to the user, no retry loop, and at most one
  diagnostic log line — repeated logging per error is a failure.

[10.5] CONFIG: Sentry's `environment` option is set from the active `Flavor` —
`dev` for the dev flavour, `prod` for the prod flavour. The value is derived at
runtime from the flavour, never hardcoded per entrypoint.
  Failure case: if the flavour is somehow unresolved at initialisation time,
  initialisation is skipped rather than defaulting to a wrong environment.

[10.6] ERROR HANDLING: An unhandled Dart error raised outside the Flutter
framework — including asynchronous errors reaching the root error handler — is
captured and sent to Sentry as an error event with its stack trace.
  Failure case: if the event cannot be sent (offline, transport error), the error
  is dropped or queued by the SDK without crashing the app or surfacing a
  secondary error to the user.

[10.7] ERROR HANDLING: An error reported through the Flutter framework's error
hook (build/layout/paint errors, framework assertions) is captured and sent to
Sentry, and the framework's existing error presentation is preserved — console
output in debug and the existing error widget behaviour are unchanged.
  Failure case: if the Sentry hook throws, the original framework error handler
  still runs.

[10.8] EVENT DATA: Every event sent carries a tag identifying the flavour (value
= active flavour name) and a tag carrying the app version including build number.
Both are present on events captured from both error sources in [10.6] and [10.7].
  Failure case: if the app version cannot be read at initialisation time, the
  version tag is omitted and the event is still sent; missing version never
  suppresses an event.

[10.9] PRIVACY: No event payload — user context, tags, extras, contexts,
breadcrumbs, or exception message — contains the user's email address, display
name, avatar URL, or any Supabase access/refresh token.
  Failure case: any code path that would attach one of these values must be
  removed or scrubbed before send, not merely relied upon to be empty.

[10.10] PRIVACY: The SDK's default PII collection is disabled, so IP address,
device name and OS username are not attached to events.
  Failure case: any option that re-enables default PII, directly or transitively,
  fails this criterion.

[10.11] USER CONTEXT: When a Supabase session is active, events carry the
Supabase user ID as the only user-identifying field. When no session exists, or
after sign-out, no user identifier is attached.
  Failure case: after sign-out, the next captured event must not carry the
  previous user's ID; stale user context is a failure.

[10.12] VERIFICATION (manual, dev flavour): A deliberately raised uncaught error
in the dev flavour produces an event in the Sentry project within a minute,
tagged `environment = dev`, carrying the flavour and app version tags, showing a
readable Dart stack trace, and showing none of the fields listed in [10.9].
  Failure case: no event, wrong environment, missing tags, or any PII present is
  a QA FAIL.

[10.13] VERIFICATION: The mechanism used to raise the test error in [10.12] is
not reachable in a prod build — it is either removed before delivery or gated to
the dev flavour.
  Failure case: any user-reachable crash trigger in the prod flavour is a FAIL.

[10.14] REGRESSION: Existing startup behaviour is unchanged — flavour
initialisation order, Supabase client setup and its connectivity check, and
time-to-first-frame are unaffected; analyzer and test results do not regress
against the run baseline.
  Failure case: a new analyzer error or a newly failing test that is not in the
  recorded pre-existing failure list.

## Out of scope

- Performance monitoring, tracing, profiling, session replay and release-health
  sessions.
- Reporting of handled/caught exceptions, and routing the app's existing logging
  into Sentry breadcrumbs.
- Native (Android JVM/NDK) crash capture as a stated requirement, plus debug
  symbol, ProGuard mapping and source-map upload to Sentry. Whatever the SDK does
  by default is acceptable; no upload tooling or build-step integration is added.
- Sentry-side dashboard work: alert rules, issue owners, quota limits, data
  scrubbing rules, retention settings.
- Prod-flavour verification. There is no prod Supabase project and no prod
  deployment (item 0.1b, deferred), so only the dev flavour can be verified.
- iOS verification of any kind — Android is the only buildable target.
- User-facing changes: no crash dialog, no "report a problem" UI, no change to
  existing error messaging.
- Supplying the real DSN value. It is not in this checkout; the human provides it
  locally for the [10.12] verification run.

## Assumptions

ASSUMPTION: Environment values are the flavour names `dev` and `prod`.

ASSUMPTION: The DSN lives in the existing shared (non per-flavour) obfuscated env
config with a placeholder default; nothing plaintext is committed.

ASSUMPTION: The real DSN is absent from this checkout, so builds here resolve the
placeholder and [10.4] is the path exercised until the human supplies it.

ASSUMPTION: Sentry initialises in all build modes, including debug, so the dev
test crash can be triggered from a normal debug run.

ASSUMPTION: The test crash is a verification aid, not a shipped feature; any
trigger is dev-only and short-lived.

ASSUMPTION: The app version tag uses the full `pubspec.yaml` version with build
number (currently `1.0.0+1`).

ASSUMPTION: Attaching the Supabase user ID is required, not merely permitted.

ASSUMPTION: 100% of error events are sent; no sampling and no quota guard against
the ~5k events/month free tier.

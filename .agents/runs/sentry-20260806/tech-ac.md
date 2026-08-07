# Technical Acceptance Criteria
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]", plus a second
requirement added by the human on 2026-08-06 to the same run (IGDB client logging
via `talker`, and removal of the deprecated `PrettyDioLogger` interceptor)
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

Added to the same run: local network visibility for the live IGDB path. Calls
through the Supabase IGDB client are logged with `talker` — the outgoing endpoint
and query, the returned body trimmed to at most 50 lines, and any failure with a
full untrimmed stack trace — gated on the dev flavour and a debug build together,
console output only, and entirely separate from Sentry. Alongside it, the
`PrettyDioLogger` interceptor is stripped from the two deprecated files that still
register it, the `pretty_dio_logger` package is dropped from the project, and the
architecture reference is updated so it no longer documents a logger the code no
longer has.

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

[10.15] LOGGING: Each invocation of the Supabase IGDB client's `invoke` entry
point emits one `talker` request entry before the call is dispatched, carrying
both the endpoint value and the query value passed to it.
  Failure case: if emitting the log entry throws, the call is still dispatched
  unchanged and the thrown log error does not reach the caller.

[10.16] LOGGING: After `invoke` returns successfully, one `talker` response entry
is emitted whose body content is capped at 50 lines. When the rendered body
exceeds the cap, only the first 50 lines are emitted and the entry carries an
explicit marker that output was cut short.
  Failure case: a body at or under the cap is emitted in full with no truncation
  marker, so a complete log is never mistaken for a truncated one.

[10.17] LOGGING: When `invoke` fails — including a timeout, a transport failure
and an error returned by the edge function — one `talker` error entry is emitted
carrying the error and its complete stack trace with no line trimming applied,
and the original error then propagates to the caller unchanged in type and
message.
  Failure case: swallowing the error, wrapping it in a different type, or
  applying the [10.16] 50-line cap to error output or a stack trace each fail
  this criterion.

[10.18] GATING: The logging in [10.15]-[10.17] runs only when the active flavour
is dev AND the build is a debug build. Both conditions are evaluated per call.
Any other combination — dev release, prod debug, prod release — emits nothing at
all for these three entries.
  Failure case: if the active flavour cannot be resolved at call time, nothing is
  logged; the call itself still proceeds normally.

[10.19] OUTPUT SURFACE: Log output goes to the console/logger sink only. No
in-app log viewer screen, route, overlay, floating button or other user-reachable
affordance is added, and no stored log history is exposed in the UI.
  Failure case: any new widget, route or gesture that surfaces log contents fails
  this criterion.

[10.20] SEPARATION: The IGDB logging path is independent of crash reporting. No
entry from [10.15]-[10.17] is turned into a Sentry breadcrumb, event or
attachment, and neither mechanism's failure or disablement affects the other.
  Failure case: a Sentry-disabled build must still log per [10.15]-[10.18], and a
  build with logging gated off must still report crashes per [10.6]-[10.7].

[10.21] REGRESSION: The IGDB client's public entry point keeps its existing
signature, return value and error propagation, and its callers — the games, game
detail and featured API services — are not modified and gain no logging of their
own.
  Failure case: an existing test of the client or of those services that passed
  at the run baseline and now fails.

[10.22] CLEANUP: `lib/core/di/network_module.dart` no longer imports or registers
`PrettyDioLogger`. Everything else in the file is byte-identical in behaviour —
the same `Dio` instance, the same base options, the same `TwitchAuthInterceptor`
registration, the same `@Deprecated` annotation and comments.
  Failure case: removing or reordering any other interceptor, option or member of
  that file fails this criterion.

[10.23] CLEANUP: `lib/core/services/api/twitch_auth_interceptor.dart` no longer
imports `PrettyDioLogger` and no longer registers it on its private token `Dio`.
The constructor still builds that `Dio` with the same base URL and the same three
timeouts, and every other member of the class is unchanged. The class stays in
the tree, stays `@Deprecated`, and stays unregistered in DI.
  Failure case: deleting the file, deleting the token `Dio`, or changing any
  other method fails this criterion.

[10.24] DEPENDENCY: The `pretty_dio_logger` entry is removed from `pubspec.yaml`,
and after dependency resolution the package appears nowhere in `pubspec.lock` —
neither as a direct nor as a transitive dependency. No import of it remains
anywhere under `lib/` or `test/`.
  Failure case: a leftover import produces an analyzer error against the run
  baseline; the package reappearing in the lock as transitive means something
  still pulls it in and must be reported rather than worked around.

[10.25] DOCS: `.agents/references/flutter-arch.md` no longer presents
`PrettyDioLogger` as part of the Dio/network setup at either of its two mentions
(around lines 170 and 181). What remains at those two points describes only
mechanisms the code still contains.
  Failure case: a doc line still naming `PrettyDioLogger`, or a rewrite that
  describes network logging that does not exist in the code, both fail.

[10.26] REGRESSION: The changes for [10.15]-[10.25] produce no new analyzer error
and no newly failing test against the recorded run baseline, and no runtime
behaviour change outside the IGDB client call path — the two files touched by
[10.22] and [10.23] are unreachable from the running app, so removing the logger
from them changes nothing observable.
  Failure case: a new analyzer error or a newly failing test that is not in the
  recorded pre-existing failure list.

## Out of scope

- Performance monitoring, tracing, profiling, session replay and release-health
  sessions.
- Reporting of handled/caught exceptions, and routing the app's existing logging
  into Sentry breadcrumbs. This explicitly includes the [10.15]-[10.17] IGDB log
  entries — no breadcrumb bridging in either direction.
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
- `talker_flutter`'s viewer UI — the log screen, overlay, route and any in-app
  log inspector — stays out. This run adds console/logger output only ([10.19]).
- Logging on any other network or data path: Supabase auth, storage, the tracker
  repository and direct `SupabaseClient` calls are untouched. Only the IGDB
  client's `invoke` is instrumented.
- Log persistence, file or remote export, log-level configuration, and privacy
  scrubbing of log content. Output is local, dev-only and debug-only.
- Migrating existing `debugPrint`/`logger` calls to `talker`, and any change to
  the `logger` or `talker_flutter` dependency entries.
- Broader dead-code cleanup. `NetworkModule`, `TwitchAuthInterceptor`, the `dio`
  and `retrofit` dependencies and all remaining Dio wiring stay exactly as they
  are apart from the single logger interceptor removed by [10.22] and [10.23].
  Deleting those deprecated files belongs to item 11, not this run.
- Any reference-doc edit other than the two `PrettyDioLogger` mentions in
  `flutter-arch.md` ([10.25]) — including the unrelated stale module path on the
  line above them.

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

ASSUMPTION: A "line" for the [10.16] cap is a newline-separated line of the
rendered response body.

ASSUMPTION: Request and successful-response entries log at an informational
level, failures at error level, so failures are filterable in console output.

ASSUMPTION: No new package is needed for logging — `talker_flutter` is already a
direct dependency and carries `talker` transitively.

ASSUMPTION: `pretty_dio_logger` is `direct main` in `pubspec.lock` with nothing
else depending on it, so removing the `pubspec.yaml` line drops it from the lock
entirely.

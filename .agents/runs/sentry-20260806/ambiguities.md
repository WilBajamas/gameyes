# Ambiguities Report
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]" (ticket-style brief),
plus a second requirement added by the human on 2026-08-06 to the same run:
IGDB client request/response/error logging via `talker`, and removal of the
deprecated `PrettyDioLogger` interceptor.
Date: 2026-08-06

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

CRITICAL-1 (`pretty_dio_logger` removal contradicted leaving
`TwitchAuthInterceptor` untouched) was answered by the human on 2026-08-06:
**Option A** — strip the import and the `PrettyDioLogger` registration from
`twitch_auth_interceptor.dart` as well, then remove the package from
`pubspec.yaml` entirely, and update the two now-stale `PrettyDioLogger`
references in `.agents/references/flutter-arch.md`. The file allowlist grows by
those two files. Criteria [10.15]-[10.26] are now appended to `tech-ac.md`.

## ASSUMPTIONS (minor — pipeline may proceed)

### Added requirement — `talker` logging

ASSUMPTION: "Trimmed to a maximum of 50 lines" does not define a line. Assuming
the rendered response body is split on newlines and at most the first 50 are
logged, with a visible marker that the rest was dropped, so a truncated log is
never mistaken for a complete one. The 50-line cap applies only to a successful
response body; error output and stack traces are never trimmed.

ASSUMPTION: Log severities not specified. Assuming the request and the successful
response log at an informational level and failures at error level, so a failure
is filterable in console output.

ASSUMPTION: The gate is evaluated per call, not cached at startup, and both
conditions must hold — dev flavour AND debug build. Any other combination
(dev + release, prod + debug, prod + release) logs nothing at all.

ASSUMPTION: Wrapping the single `SupabaseIgdbClient.invoke` call site is read as
covering every caller of it (the games, game detail and featured API services);
no per-caller logging is added.

ASSUMPTION: Log content is not privacy-reviewed the way Sentry payloads are in
[10.9]-[10.10], because output is console-only, dev-flavour-only and debug-only,
and never leaves the device.

ASSUMPTION: No new package is needed for the logging half. `talker_flutter` is
already a direct dependency and `pubspec.lock` carries `talker` transitively
through it, so "use talker" is assumed to mean the logging core already on hand,
not a new `pubspec.yaml` entry.

### Added requirement — `PrettyDioLogger` removal

ASSUMPTION: `pubspec.lock` lists `pretty_dio_logger` as `direct main` and nothing
else depends on it, so removing the `pubspec.yaml` line is assumed to remove it
from the lock outright rather than demote it to transitive.

ASSUMPTION: "Remove the interceptor" means remove only the logger registration
and its import from the two files. Both files stay in the tree, still
`@Deprecated`, still unregistered in DI; deleting them outright is item 11's
question, not this run's.

ASSUMPTION: The `.agents/references/flutter-arch.md` edit is scoped to its two
`PrettyDioLogger` mentions (lines 170 and 181). A separate staleness in the same
section — line 169 gives the module's path as
`lib/core/services/api/network_module.dart` while the file actually lives at
`lib/core/di/network_module.dart` — is assumed out of scope and left alone, since
correcting it is unrelated to the logger removal.

### Original Sentry requirement

ASSUMPTION: Environment string values not specified. Assuming the active `Flavor`
enum's own name, lowercase — `dev` and `prod` — so Sentry's environment filter
matches the flavour names already used everywhere else in the project.

ASSUMPTION: DSN storage mechanism not specified. The DSN is a single value shared
by both flavours, so assuming it is supplied through the existing shared (non
per-flavour) `envied` secret path with a placeholder default, matching how every
other credential in `lib/config/config_envied.dart` is handled. No plaintext DSN
committed to the repository.

ASSUMPTION: The real DSN is not present in this checkout — no `secret.env`/env
file exists here and no DSN string appears anywhere in the tree, so builds resolve
the placeholder default. Assuming the human supplies the real value locally for the
dev verification run; the code path must tolerate the placeholder without breaking
startup (criterion 10.4).

ASSUMPTION: Build-mode gating not specified. Assuming Sentry initialises in every
build mode including debug, since the required dev test crash will most likely be
triggered from a debug or profile run of the dev flavour.

ASSUMPTION: The "deliberate test crash" is a verification step, not a shipped
feature. Assuming any trigger the Dev Agent adds is confined to the dev flavour and
not reachable in a prod build; no permanent user-facing crash/report affordance.

ASSUMPTION: App version tag format not specified. Assuming the full `pubspec.yaml`
version including build number (currently `1.0.0+1`), because the build number is
what distinguishes two uploads of the same marketing version.

ASSUMPTION: Attaching the Supabase user ID is read as required, not merely
permitted — the brief argues the user ID "alone is sufficient to correlate reports",
which only holds if it is actually attached.

ASSUMPTION: Event sampling not specified. Assuming 100% of qualifying error events
are sent (SDK default) and no performance/trace sampling is enabled. The ~5k
events/month free-tier ceiling noted in item 0.7 is accepted as-is; no quota
guard is in scope.

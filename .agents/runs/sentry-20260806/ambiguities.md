# Ambiguities Report
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]" (ticket-style brief),
plus a second requirement added by the human on 2026-08-06 to the same run:
IGDB client request/response/error logging via `talker`, and removal of the
deprecated `PrettyDioLogger` interceptor.
Date: 2026-08-06

## CRITICAL (pipeline blocked — requires human decision before proceeding)

CRITICAL-1: added requirement 2 (remove the deprecated `PrettyDioLogger`
interceptor) — two instructions in it cannot both hold. Removing
`pretty_dio_logger: ^1.4.0` from `pubspec.yaml` was premised on nothing else
referencing it, but `lib/core/services/api/twitch_auth_interceptor.dart` also
imports the package and registers `PrettyDioLogger` on its private `_tokenDio`
(lines 3, 27-32). The same requirement lists `TwitchAuthInterceptor` as staying
exactly as-is and says this is not a broader dead-code cleanup. Removing the
package while leaving that file alone breaks compilation and adds an analyzer
error against the run baseline.
  Options: A — also strip the import and the `PrettyDioLogger` registration from
  `twitch_auth_interceptor.dart`, then remove the package, expanding the file
  allowlist by one file | B — keep `pretty_dio_logger` in `pubspec.yaml` and
  delete only the `network_module.dart` registration and import
  Recommended: A — it is the same one logger interceptor, both usages sit in
  `@Deprecated` reference-only code the app never runs, and it is the only option
  where the package actually leaves the project. Secondary: `.agents/references/
  flutter-arch.md` lines 170 and 181 document `PrettyDioLogger` and go stale under
  A; confirm whether the reference doc is in scope for this run.
  Decision needed from: Human / Product Owner

Requirement 1 (`talker` logging around the IGDB client) has no critical
ambiguity. Its criteria are ready to append as 10.15 onward once CRITICAL-1 is
answered; per the BA rules nothing was written to `tech-ac.md` while a CRITICAL
is open, so the existing 10.1-10.14 file is untouched.

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

# Ambiguities Report
Source: `.agents/week-1-task-briefs.md` §"10 — Sentry [PIPELINE]" (ticket-style brief)
Date: 2026-08-06

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

## ASSUMPTIONS (minor — pipeline may proceed)
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

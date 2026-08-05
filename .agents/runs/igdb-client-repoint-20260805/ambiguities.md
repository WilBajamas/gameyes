# Ambiguities Report
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/source-request.md`
Date: 2026-08-05

## CRITICAL (pipeline blocked — requires human decision before proceeding)
NONE

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: Featured is in scope. The request names only the games list and game
detail as `games` callers, but `FeaturedRepositoryImpl` injects the IGDB service
directly and calls it in three places (countdown, out-this-week, critics' choice).
Deleting the service without repointing Featured breaks the build, so the only
reading consistent with "credentials removed entirely" and "behaviour must not
change" is that Featured is repointed too.

ASSUMPTION: The `release_dates` path is ported even though nothing calls it. The
request names `release_dates` as one of the two endpoints in scope, but no
production code calls `fetchReleaseDates` today — only the service declaration and
the model exist. Porting it keeps the capability; verification is by unit test
only, since no screen exercises it.

ASSUMPTION: "Behaviour must not change" is judged at the `Result` level, not at the
`ErrorType` variant level. Today a failed IGDB call yields
`Failure(ErrorType.connectionTimeout | receiveTimeout | sendTimeout |
responseError | unknown)`; the UI renders the same generic retry widget for all of
them, so the variant is not user-visible. The criteria therefore require a
`Failure` with the proxy's status code and message preserved where one exists, not
a variant-for-variant reproduction of the Dio classification.

ASSUMPTION: The preserved request timeout is 30 seconds, taken from today's
`ConfigConstants.connectTimeout` / `receiveTimeout`. The 5-second send timeout is
not separately preserved. Flagged because this is the one number an engineer may
reasonably want to challenge — and because the shared Supabase client also carries
auth and database traffic that must not inherit a new timeout.

ASSUMPTION: Losing the client-side 401 refresh-and-retry is intended, not a
regression. Token handling moves server-side, so there is no client requirement to
replace it.

ASSUMPTION: Losing request/response logging for IGDB traffic (today via the Dio
logger) is acceptable; no replacement is required.

ASSUMPTION: No local `.env` file exists in the working tree (all envied values
currently fall back to placeholders), so credential removal is a source-and-
generated-code change only. Nothing to scrub from an env file.

ASSUMPTION: No sign-in dependency is introduced. Every screen that loads IGDB data
already sits behind the auth guard, and the Supabase SDK attaches the anon key when
no session exists, so proxy calls remain possible in both states exactly as before.

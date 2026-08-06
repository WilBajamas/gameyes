# Technical Acceptance Criteria
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3 ("Flutter client repointed", "IGDB credentials removed from the client
build entirely"), via `.agents/runs/igdb-client-repoint-20260805/source-request.md`
Date: 2026-08-05
BA Agent version: 1.0

## Feature summary

Transport swap only. Every IGDB read the client performs today — games list, game
detail, featured, and the declared-but-uncalled release-dates path — moves from a
direct authenticated `POST` to `api.igdb.com` onto an invocation of the already
deployed `igdb-proxy` Supabase Edge Function, which takes `{"endpoint", "query"}`
and returns IGDB's JSON array unchanged. Queries, field sets, decoded model types
and every downstream repository/bloc/UI contract stay exactly as they are. The
now-dead direct-to-IGDB stack — both Retrofit services, the shared IGDB Dio
instance, the Twitch auth interceptor and the two Twitch envied constants — is
deleted, so no IGDB or Twitch credential remains in the build.

Source IDs used below:
- `REQ-9.2` — Flutter client repointed
- `REQ-9.3` — IGDB credentials removed from the client build entirely
- `REQ-NC` — "Existing behaviour and output must not change"

## Technical acceptance criteria

[REQ-9.2] DATA: The games-list fetch obtains its results by invoking the
`igdb-proxy` Edge Function with body `{"endpoint": "games", "query": <built
query>}`, and issues no HTTP request to `api.igdb.com`.
  Failure case: invoke throws or returns non-2xx — the error reaches the games
  repository, which returns `Failure(ErrorType)`; the bloc emits the failed status
  and the screen shows its existing retry widget. No crash, no partially populated
  list.

[REQ-9.2] DATA: The `games` response is decoded per array element into `Game`, and
the games-list fetch still returns the same `GamesModel` wrapper it does today
(`count: 0`, `results` = decoded list).
  Failure case: body is not a JSON array, or an element fails to decode — the call
  fails as an error result, never as a silently empty list.

[REQ-9.2] DATA: The game-detail fetch invokes `igdb-proxy` with `{"endpoint":
"games", "query": <built query>}` and returns the first decoded `GameDetailModel`
of the returned array.
  Failure case: an empty array produces the same failure it does today (taking the
  first element of an empty list), surfacing as `Failure(ErrorType)` from the
  repository and the detail screen's existing error state. This pre-existing rough
  edge is preserved, not fixed.

[REQ-9.2] DATA: Featured's three IGDB-backed reads — countdown game (wishlist query
plus the global most-anticipated fallback), out-this-week (7-day window with the
14-day retry), and critics' choice (genre query plus the global top-up) — all go
through the same proxy-backed path.
  Failure case: proxy failure — each method's existing catch returns
  `Failure(ErrorType.unknown())` and the section renders its current empty/error
  state.

[REQ-9.2] DATA: A release-dates path exists that invokes `igdb-proxy` with
`{"endpoint": "release_dates", "query": <built query>}` and decodes the returned
array into `List<ReleaseDate>`.
  Failure case: same failure handling as the games path. No screen consumes this
  today, so it is verified by unit test only.

[REQ-NC] DATA: Query text is unchanged. For identical inputs, the string sent as
`query` is byte-identical to the body sent to IGDB today — same builder output,
same field lists, same `where`/`sort`/`search`/`limit`/`offset`, including the
search-suppresses-sort rule and the paging offset arithmetic.
  Failure case: any difference in the built query for identical inputs is a defect,
  even if the returned data happens to look correct.

[REQ-NC] REPOSITORY: Repositories still never throw. Every proxy call failure
returns `Failure(ErrorType)`. When the function responds 4xx/5xx with
`{"error": "<message>"}`, the resulting `ErrorType` carries that HTTP status code
and message; anything else yields `ErrorType.unknown()`.
  Failure case: any exception from the Supabase functions call escaping a
  repository and reaching a bloc, cubit or widget is a defect.

[REQ-NC] DATA: A proxy call that has not completed within 30 seconds fails with a
`Failure(ErrorType)` rather than hanging, matching today's Dio connect/receive
timeout. Timeout behaviour of non-IGDB Supabase traffic (auth, database) is
unchanged.
  Failure case: a request that never resolves leaves the screen permanently in its
  loading state.

[REQ-9.3] CONFIG: The Twitch client ID and secret are gone from the build — no
Dart source or generated Dart file under `lib/` references `TWITCH_CLIENT_ID`,
`TWITCH_CLIENT_SECRET`, or the corresponding `Env` accessors, and the envied
generated output is regenerated without those fields.
  Failure case: a case-insensitive search for `twitch` under `lib/` returning any
  hit that is not covered by the reference-code carve-out below is a fail.

[REQ-9.3] NETWORKING: The direct-to-IGDB stack is deleted from active use, not
left wired up — both Retrofit IGDB services and their generated files, and the
DI providers for the shared IGDB Dio instance and those two services. DI
generated output is regenerated without them.
  Failure case: a dangling import, an unresolvable DI registration, or any new
  analyzer error measured against the recorded Phase 0 analyzer baseline.

  **Reference-code carve-out (added 2026-08-06, human decision at the QA gate
  on this run):** `TwitchAuthInterceptor` and `NetworkModule` may exist under
  `lib/` as inert, `@Deprecated`-annotated reference code, kept because the
  human wants the old shape available to consult. This does not satisfy "the
  Twitch client ID and secret are gone from the build" or "the stack is
  deleted" as a literal file-presence rule — it satisfies the actual security
  intent behind both: no real credential (`Env.twitchClientId`/
  `twitchClientSecret` and the `TWITCH_CLIENT_ID`/`TWITCH_CLIENT_SECRET` envied
  fields are still fully gone, replaced in the reference file by the literal
  placeholder `'REMOVED_BY_ITEM_9'`), and no DI registration (confirmed by
  `injectable_builder` reporting both files as no-op — neither the interceptor
  nor the module is reachable from any code path the app actually runs). Any
  future carve-out of this kind must meet the same three conditions:
  `@Deprecated`, no real credential, unregistered in DI.

[REQ-NC] APP: Both flavours build and start with no IGDB or Twitch credential
present, and games list, game detail and featured all load real data against the
dev Supabase project, matching today's content.
  Failure case: a DI resolution or missing-registration exception at startup, or
  any screen that loaded data before this change and does not after it.

[REQ-NC] TEST: The API-layer tests for games and game detail exercise the proxy
call path — the endpoint name and query sent in the invoke body, decoding of a bare
JSON array into the model type, and the failure case — rather than a raw Dio POST
against a stand-in IGDB URL. Repository, bloc, cubit and use-case tests keep their
current expectations and results.
  Failure case: a test still asserting on Dio transport for IGDB is stale and must
  be replaced or deleted; any new test failure beyond the recorded Phase 0 test
  baseline is a fail.

## Out of scope

- The Edge Function itself: its source, its deployment, and anything under
  `supabase/functions/` or `supabase/migrations/`.
- Any prod deployment (no prod Supabase project exists).
- Removing `retrofit` / `retrofit_generator` (or any other package left unused) from
  `pubspec.yaml`. Under the pipeline execution rules `pubspec.yaml` is read-only, so
  dependency pruning needs its own allowlisted change. `dio` stays regardless — it is
  still used by the error model, the base repository mixin and the RAWG-era
  interceptor.
- RAWG-era leftovers: the RAWG API key constant, its interceptor, and the RAWG base
  URL / endpoint constants. Not IGDB or Twitch credentials, so not covered by
  "credentials removed".
- The `DioException` branch in the base repository mixin and the `ErrorType.dioError`
  factory. They stop being reachable for IGDB traffic but are not required to be
  deleted in this run.
- Query, field-set or pagination changes of any kind, including the hardcoded
  `count: 0` on the games model and the game-detail empty-result crash path. Both are
  pre-existing and stay as they are.
- Caching, per-app rate limiting, and shipping query-shape changes without a build —
  the brief's stated wins, all delivered server-side, none of them client work here.
- Any UI, copy, error-message or logging change.
- Updating `.agents/references/api-contracts.md` and `flutter-arch.md`, which both
  describe the removed Dio/Retrofit/Twitch stack as current. Not requested here;
  raised as a documentation follow-up.

## Assumptions

ASSUMPTION: Featured is in scope even though the request names only the games list
and game detail — it injects the IGDB service directly and cannot compile once that
service is deleted.

ASSUMPTION: The release-dates path is ported despite having no production caller,
because the request names it as one of the two in-scope endpoints.

ASSUMPTION: "Behaviour must not change" is judged at the `Result` level. The
specific `ErrorType` variant is not user-visible today (one generic retry widget
covers all of them), so preserving status code and message is enough; a
variant-for-variant reproduction of Dio's classification is not required.

ASSUMPTION: The preserved timeout is 30 seconds, from today's connect/receive
timeout constants. The separate 5-second send timeout is not preserved.

ASSUMPTION: Losing the client-side 401 refresh-and-retry, and losing IGDB request
logging, are both intended consequences of moving auth server-side.

ASSUMPTION: No local `.env` file exists in the working tree, so credential removal
is a source-and-generated-code change only.

ASSUMPTION: No sign-in dependency is introduced — the affected screens already sit
behind the auth guard, and the SDK sends the anon key when there is no session.

# Source Request

From `.agents/week-1-task-briefs.md` item 9 ("IGDB Edge Function proxy"), the
`[PIPELINE]`-marked half of that item:

> Then update the Flutter side to call the function instead of IGDB directly.

## Already done, not part of this run

`supabase/functions/igdb-proxy/index.ts` is written, deployed to the dev
Supabase project, and confirmed working. It is a Supabase Edge Function:

- Invoked via the Supabase Flutter SDK:
  `supabaseClient.functions.invoke('igdb-proxy', body: {...})`.
- Request body: `{"endpoint": "games" | "release_dates", "query": "<APICalypse string>"}`.
- Response: on success, the raw IGDB JSON response body, passed through
  unchanged. On failure, `{"error": "<message>"}` with a 4xx/5xx status —
  400 for a bad request shape or disallowed endpoint, 502 if the upstream
  Twitch/IGDB call itself failed.
- Holds the Twitch Client ID/Secret and does the token fetch/refresh
  server-side; the client no longer needs any of that.

`SupabaseClient` is already registered in DI (`lib/core/di/supabase_module.dart`,
`@preResolve`), so it is available to inject anywhere already.

## What this run must do

Replace the client's current direct-to-IGDB calls with calls to the
`igdb-proxy` function, for the two endpoints the app uses today:

- `games` — used by `lib/features/games/services/igdb_api_service.dart`
  (via `lib/features/games/data/datasources/games_datasource.dart`) and by
  `lib/features/game_detail/services/game_detail_service.dart`.
- `release_dates` — used by `igdb_api_service.dart`.

Today's stack: two Retrofit services (`IgdbApiService`, `GameDetailService`)
over a shared Dio client (`lib/core/di/network_module.dart`) with
`TwitchAuthInterceptor` (`lib/core/services/api/twitch_auth_interceptor.dart`)
attaching a Twitch app token fetched via `client_credentials`. All of that
becomes dead code once the client calls `functions.invoke` instead, and
should be removed as part of this run — including the
`TWITCH_CLIENT_ID`/`TWITCH_CLIENT_SECRET` `envied` constants — not left
behind unused. That removal is exactly what "IGDB credentials removed from
the client build entirely" (the next checklist line under this one) means.

The response from `functions.invoke` needs decoding the same way the
existing `Game`/`GameDetailModel`/`ReleaseDate` models already do (they're
`json_serializable`), since the Edge Function passes IGDB's JSON straight
through unchanged. Design whatever seam is cleanest for that — most likely
a datasource-level change, not an attempt to keep Retrofit's HTTP
annotations pointed at a Supabase functions URL.

**Existing behaviour and output must not change.** This is a plumbing swap,
not a feature change — same queries, same results, same UI.

## Explicitly out of scope

- Writing or redeploying the Edge Function itself (already done).
- Any change under `supabase/migrations/` or `supabase/functions/`.
- Deploying anything to prod (blocked — no prod Supabase project exists yet).

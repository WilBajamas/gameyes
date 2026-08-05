# Technical Design Document
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-05

## Feature summary

A transport swap in the data layer. Two new core classes replace the direct-to-IGDB
Retrofit stack: `IgdbProxyClient`, a thin injectable wrapper over
`SupabaseClient.functions.invoke` (the same seam pattern as `SupabasePing` and
`AuthDatasource`), and `IgdbProxyService`, which applies the 30-second timeout,
checks the reply is a JSON array and decodes each element into the model the caller
asks for. The three existing callers — `GamesDataSource`,
`GameDetailRemoteDatasource` and `FeaturedRepositoryImpl` — swap their injected
dependency and keep every query builder, field set and return type untouched.
`BaseRepositoryMixin` gains one branch so a Supabase `FunctionException` becomes a
`Failure(ErrorType.responseError)` carrying the proxy's status and message. The
Retrofit services, the shared IGDB `Dio` instance, `TwitchAuthInterceptor` and the
two Twitch `envied` fields are deleted.

## Layer map

REQ-9.2 (games list): data (service + datasource) → repository (unchanged)
REQ-9.2 (game detail): data (service + datasource) → repository (unchanged)
REQ-9.2 (featured): data (service) → repository (call sites only)
REQ-9.2 (release dates): data (service)
REQ-NC (query text): data — no change by construction
REQ-NC (repositories never throw): core error model + base repository mixin
REQ-NC (30s timeout): data (service)
REQ-9.3 (credentials): config (envied) + core constants
REQ-9.3 (dead stack): core DI + core services + feature services
REQ-NC (app boots): DI (generated)
REQ-NC (tests): test/api

No domain, state or UI layer is touched.

## Data layer

### API contracts

`igdb-proxy` Edge Function: POST via `SupabaseClient.functions.invoke('igdb-proxy')`
  Body: `{"endpoint": "games" | "release_dates", "query": "<APICalypse string>"}`
  Success (2xx): IGDB's JSON array, passed through unchanged. Element shape is
  whatever the query's `fields` clause asked for — already modelled by `Game`,
  `GameDetailModel` and `ReleaseDate`, all unchanged.
  Failure (4xx/5xx): `{"error": "<message>"}`. 400 = bad shape or disallowed
  endpoint, 502 = upstream Twitch/IGDB failure. The SDK raises
  `FunctionException(status, details, reasonPhrase)`; `details` is the decoded map.
  Source: `source-request.md ## Already done, not part of this run` (function
  contract) and `package:functions_client` 2.6.4 (`FunctionsClient.invoke`).

### Models

None created or modified. `Game`, `GameDetailModel`, `ReleaseDate` and `GamesModel`
keep their current fields and `json_serializable` output — the function passes
IGDB's JSON through unchanged, so the decode is the same decode.

### Services

IgdbProxyClient (create) — `lib/core/services/supabase/igdb_proxy_client.dart`
  `Future<Object?> invoke({required String endpoint, required String query})`
  Injects `SupabaseClient`. Returns `FunctionResponse.data` untouched. Holds no
  decoding or error logic — it exists so tests can stand in for Supabase without
  mocking the SDK, matching `SupabasePing` and `AuthDatasource`.

IgdbProxyService (create) — `lib/core/services/api/igdb_proxy_service.dart`
  `Future<List<Game>> fetchGames(String query)`
  `Future<List<ReleaseDate>> fetchReleaseDates(String query)`
  `Future<List<T>> fetchList<T>({required String endpoint, required String query,
   required T Function(Map<String, dynamic> json) fromJson})`
  Injects `IgdbProxyClient`. `fetchList` applies
  `IgdbProxyConstants.requestTimeout` (30s), rejects a non-list body with a
  `FormatException`, and maps each element through `fromJson`. The two named
  methods are thin calls into it and keep today's call-site shape for the two
  core-owned models; `fetchList` stays public because `GameDetailModel` belongs to
  the game_detail feature and `lib/core/` must not import it.

IgdbApiService (delete) — `lib/features/games/services/igdb_api_service.dart`
GameDetailService (delete) — `lib/features/game_detail/services/game_detail_service.dart`
TwitchAuthInterceptor (delete) — `lib/core/services/api/twitch_auth_interceptor.dart`
NetworkModule (delete) — `lib/core/di/network_module.dart` (its only registrations
  are the IGDB `Dio` instance and the two Retrofit services; nothing else in `lib/`
  injects `Dio`)

### DataSources

GamesDataSource (modify) — `lib/features/games/data/datasources/games_datasource.dart`
  `fetchDatasourceGames({page, pageSize, searchTerm, dateRange, orderings,
   platforms, genres}) → Future<GamesModel>` — signature, query building and the
  `GamesModel(count: 0, results: ...)` wrapper all unchanged; only the injected
  dependency and the one call line change.

GameDetailRemoteDatasource (modify) —
  `lib/features/game_detail/data/datasources/game_detail_datasource.dart`
  `fetchGameDetail({required int id}) → Future<GameDetailModel>` — unchanged
  signature; calls `fetchList<GameDetailModel>` with the `games` endpoint and still
  returns `response.first`, preserving the empty-array failure.

### Repositories

GamesRepositoryImpl — no change.
GameDetailRepositoryImpl — no change.
FeaturedRepositoryImpl (modify) —
  `lib/features/featured/data/repositories/featured_repository_impl.dart`
  Interface, method signatures, queries, sorting, fallbacks and `catch` blocks all
  unchanged. Injected dependency swaps from `IgdbApiService` to `IgdbProxyService`
  and its five `fetchGames(query)` call sites keep the same shape.

## Domain layer

No change. No use case is created or modified.

## State layer

No change.

## UI layer

No change.

## Reuse decisions

`SupabaseClient` at `lib/core/di/supabase_module.dart` — already registered
  `@preResolve`; injected, not re-created.
`IGDBQueryBuilder` at `lib/core/utils/igdb_query_builder.dart` — untouched, which
  is what makes REQ-NC's byte-identical query requirement hold by construction.
`BaseRepositoryMixin.fetchData` — the two repositories that use it keep using it.
`ErrorType.responseError` — reused for proxy failures rather than adding a variant;
  per the BA's assumption, behaviour is judged at the `Result` level.
`SupabasePing` / `AuthDatasource` shape — copied as the pattern for
  `IgdbProxyClient`, so Supabase never has to be mocked in a test.
`Game`, `GameDetailModel`, `ReleaseDate`, `GamesModel` — unchanged.

## Shared-code changes — for the Phase 3 gate

Two files in `lib/core/` change. Both are additive and neither alters an existing
code path, but they are shared code, so they are called out for sign-off:

1. `lib/core/data/models/error.dart` — adds a factory
   `ErrorType.functionError({required FunctionException exception})` alongside the
   existing `ErrorType.dioError`. Maps `{"error": "<message>"}` plus the HTTP
   status to `ErrorType.responseError(message:, statusCode:)`, and anything else to
   `ErrorType.unknown()`. No variant is added, changed or removed.
2. `lib/core/data/datasource/base_repository_mixin.dart` — adds one
   `on FunctionException` branch to `fetchData`. The existing `DioException` branch
   and the generic `catch` are untouched.

Judged an extension rather than an architecture change: the mixin's mechanism and
contract are unchanged (repositories still never throw and still return `Result`),
and its only two callers — `GamesRepositoryImpl` and `GameDetailRepositoryImpl` —
are both in scope for this run, so no out-of-scope behaviour moves. The alternative,
hand-rolling try/catch in those two repositories, would orphan the mixin and break
`dart-style.md`'s `with BaseRepositoryMixin` rule, which is the larger change.

The 30-second timeout deliberately sits in `IgdbProxyService`, not in the shared
`SupabaseClient`, so auth and database traffic keep today's behaviour.

## Out of scope

- The Edge Function, its deployment, and anything under `supabase/`.
- `pubspec.yaml`, so `retrofit` / `retrofit_generator` stay as unused dependencies.
- `ConfigConstants.igdbBaseUrl`, `connectTimeout`, `receiveTimeout`, `sendTimeout` —
  they become unused, but they are not credentials and REQ-9.3 does not reach them.
- RAWG-era leftovers: `Env.apiKey`, `ConfigConstants.apiKey`, `baseUrl`,
  `gamesEndpoint`, `screenshotsEndpoint`, `DefaultDioInterceptor`. `dio` itself
  stays — the error model, the base repository mixin and that interceptor use it.
- The `DioException` branch in `BaseRepositoryMixin` and `ErrorType.dioError`.
- Any query, field-set, pagination, UI, copy, error-message or logging change,
  including the hardcoded `count: 0` and the game-detail empty-array crash path.
- Repository, bloc, cubit and use-case test expectations, other than one added
  case covering the new proxy failure mapping.
- Updating `api-contracts.md` and `flutter-arch.md`, which still describe the
  deleted Dio/Retrofit/Twitch stack — raised as a documentation follow-up.

## Open questions

NONE

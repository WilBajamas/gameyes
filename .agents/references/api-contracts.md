# api-contracts.md — Gameyes API Contracts Reference
Project: gaming_library_assessment_flutter
Last updated: 2026-07-29

---

## The API

Everything talks to **IGDB v4**. Base URL `https://api.igdb.com/v4/`
(`ConfigConstants.igdbBaseUrl` in `lib/core/res/const.dart`).

IGDB is unusual in two ways that shape every contract below:

- **Every endpoint is `POST`, including reads.** There are no query params. The
  entire query — fields, filters, sort, limit, offset — is a single plain-text
  string in the request body, in IGDB's own query language.
- **Responses are bare JSON arrays**, not an envelope. There is no `data`,
  `results`, or `items` wrapper, and no pagination metadata. Paging is done by
  sending `limit` and `offset` in the query string and counting on the client.

Because the body is one opaque string, the interesting contract is not the HTTP
shape — it is **which fields you asked for**. A response only contains the fields
named in the query. Ask for the wrong ones and you get valid JSON with everything
null.

---

## Auth — handled for you

`TwitchAuthInterceptor` sits on the shared `Dio` instance and transparently
handles the Twitch OAuth2 token, refresh-on-401, and request headers. Wiring
detail is documented once in `flutter-arch.md § HTTP networking` — not
restated here.

**No feature code ever sets an auth header or handles a 401.** If a design calls
for either, that design is wrong.

---

## Query building

Request bodies are never hand-written. Use `IGDBQueryBuilder`
(`lib/core/utils/igdb_query_builder.dart`) and call `.build()`.

```dart
final query = IGDBQueryBuilder()
    .fields(IGDBConfig.standardGameFields)
    .limit(20)
    .offset(0)
    .where('platforms = (48, 49)')
    .sort('first_release_date')
    .build();
```

**Constraint:** `search` and `sort` are mutually exclusive in IGDB. When
`search(term)` is set the builder suppresses `sort` for you.

`IGDBConfig.standardGameFields` (in `lib/core/res/const.dart`) is the shared base
field set: `name`, `cover.url`, `game_modes.name`, `keywords.name`,
`platforms.name`, `platforms.abbreviation`, `platforms.platform_logo.url`,
`release_dates.date`, `release_dates.human`.

It does **not** include `total_rating`, `hypes`, `genres`, or
`first_release_date`. A feature needing those appends them with `.fields([...])`
— the builder accumulates. `FeaturedRepositoryImpl._gameFields` is the worked
example.

---

## Endpoints

### IGDB_Games: POST /games

Returns games. Used by the games list, game detail, and featured.

```
Request body: query: String (required) — IGDBQueryBuilder output
Response body: List<Game> — bare JSON array, may be empty
Handled status codes: 200, 401 (auto-refresh + retry), 403, 500
```

Response element type depends on the caller:

| Caller | Service | Dart type | Model file |
|---|---|---|---|
| Games list, Featured | `IgdbApiService.fetchGames` | `List<Game>` | `lib/core/data/models/game.dart` |
| Game detail | `GameDetailService.fetchGameDetail` | `List<GameDetailModel>` | `lib/features/game_detail/data/models/game_detail_model.dart` |

Both hit the same `/games` path with different field sets and different DTOs.
Game detail asks for far more fields, which is why it has its own model.

**Field-level shape is defined by the DTO, not by this document.** Read the model
file for exact field names, types, nullability, and `@JsonKey` mappings. Treat
every field as nullable unless the model says otherwise — IGDB omits fields it has
no data for rather than sending null.

### IGDB_ReleaseDates: POST /release_dates

Returns release-date records, which carry a platform and a precision category.

```
Request body: query: String (required) — IGDBQueryBuilder output
Response body: List<ReleaseDate> — bare JSON array, may be empty
Handled status codes: 200, 401 (auto-refresh + retry), 403, 500
Service: IgdbApiService.fetchReleaseDates
Model: lib/core/data/models/release_date.dart
```

`category` matters: it encodes precision (exact day vs. quarter vs. year vs. TBA).
Any feature counting down to a release must filter to day-level dates — a game
dated "Q4 2026" has no day to count down to.

---

## Services

Two Retrofit services, both `@RestApi(baseUrl: ConfigConstants.igdbBaseUrl)` and
both provided as singletons by `NetworkModule`:

| Service | File | Methods |
|---|---|---|
| `IgdbApiService` | `lib/features/games/services/igdb_api_service.dart` | `fetchGames`, `fetchReleaseDates` |
| `GameDetailService` | `lib/features/game_detail/services/game_detail_service.dart` | `fetchGameDetail` |

**`IgdbApiService` is the shared IGDB client despite living under
`features/games/`.** Featured injects it directly. Do not create a second service
for `/games` — extend the field set instead.

Never instantiate a service. Always inject it via constructor.

---

## Errors

Repositories never throw. All API calls go through `BaseRepositoryMixin.fetchData<T>()`,
which returns `Success<T>` or `Failure(ErrorType)`.

`ErrorType` variants (`lib/core/data/models/error.dart`):
`responseError({message, error, statusCode})` · `connectionTimeout` ·
`receiveTimeout` · `sendTimeout` · `unknown`

Use the `ErrorType.dioError(exception:)` factory. Do not construct variants by
hand in feature code.

Timeouts (`ConfigConstants`): connect 30s, receive 30s, send 5s.

---

## Adding an endpoint

1. Add the method to the relevant Retrofit service with `@POST('/path')` and
   `@Body() String query`.
2. Run `dart run build_runner build --delete-conflicting-outputs`.
3. If it is a new service, register it as a `@singleton` in `NetworkModule`.
4. Add it to this file — endpoint, body, response type, model path.

---

## Known gaps

- No sample response JSON is checked in. There is no `api-samples/` folder. A
  design needing exact field shapes must read the DTO, or capture a real response
  first.
- Rate limits are not documented or handled. IGDB enforces them; nothing in this
  codebase backs off.
- `ConfigConstants.baseUrl` still points at RAWG (`https://api.rawg.io/api/`).
  It is unused legacy — IGDB is the only live API. Do not build against it.

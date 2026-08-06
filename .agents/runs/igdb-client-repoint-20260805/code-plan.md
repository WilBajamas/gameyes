# Code Plan
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-05

## CREATE NEW

### lib/core/services/supabase/supabase_igdb_client.dart

```dart
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Asks the igdb-proxy function one question and hands back whatever it replied
// with. Nothing else uses this class, so the call is always bounded here — no
// caller has to remember to time it out.
@injectable
class SupabaseIgdbClient {
  const SupabaseIgdbClient(this._client);

  final SupabaseClient _client;

  Future<Object?> invoke({
    required String endpoint,
    required String query,
  }) async {
    final response = await _client.functions
        .invoke(
          IgdbProxyConstants.functionName,
          body: {'endpoint': endpoint, 'query': query},
        )
        .timeout(IgdbProxyConstants.requestTimeout);

    return response.data;
  }
}
```

### lib/features/games/services/games_api_service.dart

```dart
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:injectable/injectable.dart';

// Replaces the Retrofit IgdbApiService. Keeps both of its method names and
// return types, so the datasource call sites read the same as before.
@injectable
class GamesApiService {
  const GamesApiService(this._client);

  final SupabaseIgdbClient _client;

  Future<List<Game>> fetchGames(String query) => _decodeList(
        endpoint: IgdbProxyConstants.gamesEndpoint,
        query: query,
        fromJson: Game.fromJson,
      );

  Future<List<ReleaseDate>> fetchReleaseDates(String query) => _decodeList(
        endpoint: IgdbProxyConstants.releaseDatesEndpoint,
        query: query,
        fromJson: ReleaseDate.fromJson,
      );

  // Private on purpose. Games is the only feature reading two endpoints; the
  // other two services decode inline rather than share this.
  Future<List<T>> _decodeList<T>({
    required String endpoint,
    required String query,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final body = await _client.invoke(endpoint: endpoint, query: query);

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }
}
```

### lib/features/game_detail/services/game_detail_api_service.dart

```dart
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';
import 'package:injectable/injectable.dart';

// Replaces the Retrofit GameDetailService, method name and return type intact,
// so the datasource keeps calling `response.first`.
@injectable
class GameDetailApiService {
  const GameDetailApiService(this._client);

  final SupabaseIgdbClient _client;

  Future<List<GameDetailModel>> fetchGameDetail(String query) async {
    final body = await _client.invoke(
      endpoint: IgdbProxyConstants.gamesEndpoint,
      query: query,
    );

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body
        .map((item) => GameDetailModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
```

### lib/features/featured/services/featured_api_service.dart

```dart
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:injectable/injectable.dart';

// Featured borrowed games' service before this run. It owns one now, so the two
// features can diverge without either one growing the other's endpoints.
@injectable
class FeaturedApiService {
  const FeaturedApiService(this._client);

  final SupabaseIgdbClient _client;

  Future<List<Game>> fetchGames(String query) async {
    final body = await _client.invoke(
      endpoint: IgdbProxyConstants.gamesEndpoint,
      query: query,
    );

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body.map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
```

## MODIFY EXISTING

### lib/core/res/const.dart

```dart
class ConfigConstants {
  static const baseUrl = 'https://api.rawg.io/api/';
  static const igdbBaseUrl = 'https://api.igdb.com/v4/';
  static const gamesEndpoint = 'games';
  static const screenshotsEndpoint = 'screenshots';
  static const apiKey = 'API_KEY';
  // twitchClientId and twitchClientSecret deleted
  static const heroTag = 'hero_tag';
  ...
}

// ...added alongside the other constant classes. Keeps the IgdbProxy name
// because it describes the deployed function's contract, not the Dart classes:
class IgdbProxyConstants {
  static const functionName = 'igdb-proxy';
  static const gamesEndpoint = 'games';
  static const releaseDatesEndpoint = 'release_dates';

  // Same 30 seconds the direct IGDB calls used before the proxy. Read in one
  // place only: SupabaseIgdbClient.invoke.
  static const Duration requestTimeout = Duration(seconds: 30);
}
```

### lib/config/config_envied.dart

```dart
@Envied(path: ConfigConstants.enviedFilePath)
abstract class Env {
  @EnviedField(
    varName: ConfigConstants.apiKey,
    obfuscate: true,
    defaultValue: 'PLACEHOLDER_API_KEY',
  )
  static String apiKey = _Env.apiKey;
}
// both Twitch @EnviedField members deleted; EnvDev and EnvProd unchanged
```

### lib/core/data/models/error.dart

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

// ...inside sealed class ErrorType, next to the existing dioError factory:
  factory ErrorType.functionError({required FunctionException exception}) {
    final details = exception.details;
    final message = (details is Map) ? details['error']?.toString() : null;

    if (message == null) return const ErrorType.unknown();

    return ErrorType.responseError(
      message: message,
      statusCode: exception.status,
    );
  }
```

### lib/core/data/datasource/base_repository_mixin.dart

```dart
    try {
      final response = await apiCall;

      return Success(response);
    } on DioException catch (dioException) {
      return Failure(
        ErrorType.dioError(exception: dioException),
      );
    } on FunctionException catch (functionException) {
      return Failure(
        ErrorType.functionError(exception: functionException),
      );
    } catch (_) {
      return Failure(ErrorType.unknown());
    }
```

A `TimeoutException` from `SupabaseIgdbClient` lands in the generic `catch` and
becomes `ErrorType.unknown()` — same `Failure`-not-hang outcome as before, when
the timeout sat one layer higher.

### lib/features/games/data/datasources/games_datasource.dart

```dart
@injectable
class GamesDataSource {
  final GamesApiService gamesApiService;

  const GamesDataSource(this.gamesApiService);

  Future<GamesModel> fetchDatasourceGames({ /* unchanged */ }) async {
    final queryBuilder = IGDBQueryBuilder()      // unchanged
        .fields(IGDBConfig.standardGameFields)   // unchanged
        .limit(pageSize)                         // unchanged
        .offset((page - 1) * pageSize);          // unchanged
    // search / sort branch unchanged

    final response = await gamesApiService.fetchGames(queryBuilder.build());

    return GamesModel(
      count: 0,
      results: response,
    );
  }
}
```

### lib/features/game_detail/data/datasources/game_detail_datasource.dart

```dart
@injectable
class GameDetailRemoteDatasource {
  final GameDetailApiService _gameDetailApiService;

  GameDetailRemoteDatasource(this._gameDetailApiService);

  Future<GameDetailModel> fetchGameDetail({required int id}) async {
    final query = IGDBQueryBuilder()             // unchanged
        .fields(IGDBConfig.standardGameFields)
        .where('id = $id')
        .limit(1)
        .build();

    final response = await _gameDetailApiService.fetchGameDetail(query);

    return response.first;
  }
}
```

### lib/features/featured/data/repositories/featured_repository_impl.dart

```dart
@Injectable(as: FeaturedRepository)
class FeaturedRepositoryImpl
    with BaseRepositoryMixin
    implements FeaturedRepository {
  final FeaturedLocalDatasource _localDatasource;
  final FeaturedApiService _featuredApiService;

  FeaturedRepositoryImpl(
    this._localDatasource,
    this._featuredApiService,
  );

  // _gameFields, every IGDBQueryBuilder chain, the sorting, the 7-then-14 day
  // retry, the critics top-up and every catch block stay exactly as they are.
  // Only the five call sites change, all in this shape:
  //   final games = await _featuredApiService.fetchGames(query);
}
```

## TEST FILES

### test/mocks/release_date_mock.dart (new)
- `mockReleaseDate` — one `ReleaseDate` with a real epoch, human string and category
- `mockReleaseDatesJson` — the raw IGDB array shape, `List<Map<String, dynamic>>`

### test/mocks/game_mock.dart
- adds `mockGamesJson` — `mockListGames` as a raw JSON array

### test/mocks/game_detail_response_mock.dart
- adds `mockGameDetailJson` — a one-element raw JSON array
- adds `mockEmptyGameDetailJson` — an empty array, for the preserved crash path

### test/mocks/error_mock.dart
- adds `mockFunctionException` — `FunctionException(status: 502, details: {'error': ...})`

### test/api/supabase/supabase_igdb_client_test.dart (new — mocks `SupabaseClient` and `FunctionsClient`, real `SupabaseIgdbClient`)
- `'should invoke the igdb-proxy function with the endpoint and query in the body'` — captures the function name and body map
- `'should return the function response data untouched'` — a bare `List` comes back as-is, undecoded
- `'should fail rather than hang when the function does not answer within 30 seconds'` — `testWidgets`, a never-completing `Completer<FunctionResponse>().future` stub and `tester.pump(const Duration(seconds: 31))`, same shape as `supabase_connection_checker_test.dart`

### test/api/games/games_test.dart (rewrite — mocks `SupabaseIgdbClient`, real `GamesApiService` and real `GamesDataSource`)
- `'should send the games endpoint and the built query to the proxy when fetching games'` — captures the `invoke` arguments and asserts the endpoint is `games` and the query string matches the builder output exactly
- `'should send a search query with no sort clause when a search term is given'` — the search-suppresses-sort rule and the offset arithmetic survive the swap
- `'should return GamesModel with count 0 and decoded games when the proxy returns a JSON array'` — decoding a bare array into `List<Game>`
- `'should throw when the proxy reply is not a JSON array'` — never a silently empty list
- `'should throw FunctionException when the proxy call fails'` — the failure reaches the repository
- `'should send the release dates endpoint and decode into ReleaseDate when fetching release dates'` — `GamesApiService.fetchReleaseDates`

### test/api/game_detail/game_detail_test.dart (rewrite — mocks `SupabaseIgdbClient`, real `GameDetailApiService` and real `GameDetailRemoteDatasource`)
- `'should send the games endpoint and the id query to the proxy when fetching game detail'` — asserts endpoint `games` and the `where id = N` query
- `'should return the first decoded GameDetailModel when the proxy returns a JSON array'`
- `'should throw when the proxy returns an empty array'` — the pre-existing rough edge is preserved, not fixed
- `'should throw FunctionException when the proxy call fails'`

### test/repository/games/games_repository_test.dart (one appended case; existing cases untouched)
- `'should return Failure carrying the proxy status code and message when the datasource throws FunctionException'`

## Approved feedback delta

Naming-only revision from the Phase 3 gate. Nothing about the design, layering,
signatures, testing mode or step order changes. Where this delta conflicts with
`tdd.md` or with any surviving mention elsewhere, this delta wins.

- `IgdbProxyClient` is renamed `SupabaseIgdbClient`, and its file
  `lib/core/services/supabase/igdb_proxy_client.dart` is renamed
  `lib/core/services/supabase/supabase_igdb_client.dart`.
- `IgdbProxyService` is renamed `SupabaseIgdbService`, and its file
  `lib/core/services/api/igdb_proxy_service.dart` is renamed
  `lib/core/services/api/supabase_igdb_service.dart`.
- Reason: neither old name signalled that this is the Supabase-routed path that
  replaces the direct-to-IGDB Retrofit stack. `Supabase`-first also matches the
  existing `SupabasePing` / `SupabaseConnectionChecker` naming in
  `lib/core/services/supabase/`.
- Both classes carry `Supabase`, not just the client: `SupabaseIgdbService` is
  the type named in seven constructor fields and call sites across games,
  game_detail and featured, so it is where the at-a-glance signal has to live.
  `SupabaseIgdbClient` reads as the raw `functions.invoke` seam; the service
  reads as the decoding layer consuming it.
- Constructor field names follow: `igdbProxyService` → `supabaseIgdbService` in
  `GamesDataSource`, `_igdbProxyService` → `_supabaseIgdbService` in
  `GameDetailRemoteDatasource` and `FeaturedRepositoryImpl`. The service's own
  field for the client stays `_client`.
- Folders do not change. The client stays under
  `lib/core/services/supabase/`, the service stays under
  `lib/core/services/api/`. Only the two filenames change.
- `IgdbProxyConstants` in `lib/core/res/const.dart` keeps its name — it
  describes the deployed `igdb-proxy` function's contract (function name,
  endpoint names, timeout), not the Dart classes, and `functionName` stays the
  literal `'igdb-proxy'`.
- `tdd.md` still uses the old names throughout, and so do the `tdd.md`
  filenames and the `## Feature summary`, `## Data layer ### Services`,
  `## Reuse decisions` and `## Constraints` mentions. It was deliberately not
  rewritten; read the names from this delta.
- `task-brief.md` has been updated in place for the two allowlist paths and for
  every step and constraint that named the old classes or files, so the Dev
  Agent's file allowlist is correct as written.
- Test files, test paths and mock file names are unchanged; only the mocked
  type in `test/api/games/games_test.dart` and
  `test/api/game_detail/game_detail_test.dart` becomes `SupabaseIgdbClient`
  (so `@GenerateMocks([SupabaseIgdbClient])`, regenerated `*.mocks.dart`).

## Approved feedback delta 2 — timeout placement and per-feature services

Second revision round at the Phase 3 gate. Two structural decisions from the
human, both final. This delta supersedes delta 1 wherever they overlap (delta 1's
`SupabaseIgdbService` no longer exists), and supersedes `tdd.md` everywhere.
`task-brief.md` has been updated in place to match; where `task-brief.md` and
this delta still disagree, `task-brief.md` wins for the Dev Agent.

### Decision 1 — the 30-second timeout moves into `SupabaseIgdbClient.invoke`

- `SupabaseIgdbClient.invoke` now wraps its own
  `_client.functions.invoke(...)` call in
  `.timeout(IgdbProxyConstants.requestTimeout)`. No consumer applies a timeout
  any more; `invoke` is unconditionally a bounded call.
- No constructor-configurable timeout. One value exists, so the method body
  references `IgdbProxyConstants.requestTimeout` directly. Do not add a
  `Duration` constructor parameter, a default, or an override hook.
- The tdd.md design note "The 30-second timeout deliberately sits in
  `IgdbProxyService`, not in the shared `SupabaseClient`, so auth and database
  traffic keep today's behaviour" was about the third-party `SupabaseClient` SDK
  object, not our wrapper. `SupabaseIgdbClient` exists only to call the IGDB
  proxy function and nothing else injects it, so bounding its own `invoke` does
  not touch auth or database traffic. The note's intent is preserved; its
  placement conclusion is superseded.
- `IgdbProxyConstants.requestTimeout` now has exactly one reader. It stays in
  `IgdbProxyConstants` — it is part of the proxy call's contract, and
  `dart-style.md` keeps constants in a `*Constants` class regardless.
- Error mapping is unchanged. A `TimeoutException` is not a `FunctionException`,
  so it falls to `BaseRepositoryMixin`'s generic `catch` and becomes
  `ErrorType.unknown()` — the same `Failure`-rather-than-hang result the earlier
  design produced, satisfying the REQ-NC timeout criterion.
- **Test consequence, deliberate.** With the timeout inside the mocked seam, no
  test that mocks `SupabaseIgdbClient` can exercise it. The timeout case
  therefore moves out of `test/api/games/games_test.dart` into a new
  `test/api/supabase/supabase_igdb_client_test.dart`, which mocks
  `SupabaseClient` and its `FunctionsClient` directly. This is the only place in
  the run that mocks the Supabase SDK; the three feature services still never do,
  which is the seam's whole purpose. If mockito codegen cannot produce a usable
  `MockSupabaseClient`/`MockFunctionsClient` pair, the Dev Agent escalates rather
  than moving the timeout back.

### Decision 2 — one API service per feature, no shared service

- `SupabaseIgdbService` and `lib/core/services/api/supabase_igdb_service.dart`
  are dropped entirely. They are replaced by three feature-owned services, each
  `@injectable`, each injecting `SupabaseIgdbClient`, each owning its own
  array-shape check and its own decode:
  - `GamesApiService` — `lib/features/games/services/games_api_service.dart` —
    `fetchGames(String query) → Future<List<Game>>` and
    `fetchReleaseDates(String query) → Future<List<ReleaseDate>>`. Release dates
    lived in the games-feature-owned `IgdbApiService` before this run and have no
    other feature to move to, so games keeps them.
  - `GameDetailApiService` —
    `lib/features/game_detail/services/game_detail_api_service.dart` —
    `fetchGameDetail(String query) → Future<List<GameDetailModel>>`. Renamed from
    today's `GameDetailService` to carry "Api" like the others; same method name
    and return type, so `GameDetailRemoteDatasource` keeps `response.first`.
  - `FeaturedApiService` —
    `lib/features/featured/services/featured_api_service.dart` —
    `fetchGames(String query) → Future<List<Game>>`. New; featured borrowed
    `IgdbApiService` directly before this run and owns a service for the first
    time.
- Naming precedent: the codebase's own pre-run convention is per-feature
  services (`IgdbApiService` in games, `GameDetailService` in game_detail), and
  "Api" in the name is what distinguished them from local datasources.
- `SupabaseIgdbClient` stays the single shared class in
  `lib/core/services/supabase/`. It is pure transport: call the function, apply
  the timeout, return the raw data or throw. It never names a model type and
  never decodes.
- The generic `fetchList<T>({endpoint, query, fromJson})` is gone. It only
  existed because a `lib/core/` class could not import `GameDetailModel`; with
  the decode inside each feature, each service imports its own model directly.
  Games keeps a **private** `_decodeList<T>` helper because it is the one feature
  with two endpoints — it is not shared, exported, or copied into the other two.
- The three-way repeat of `if (body is! List) throw const FormatException(...)`
  is accepted, not refactored. Now that timing has moved out, what is left per
  service is the shape check plus a feature-specific decode; extracting three
  lines back into core would reintroduce the `lib/core/` → `lib/features/` import
  problem for nothing.
- Constructor field names: `gamesApiService` in `GamesDataSource` (public, as it
  is today), `_gameDetailApiService` in `GameDetailRemoteDatasource`,
  `_featuredApiService` in `FeaturedRepositoryImpl`. Each service's own field for
  the client stays `_client`.
- Registration: all three are plain `@injectable` classes, not Retrofit
  `@RestApi` abstracts. `flutter-arch.md`'s rule that "every new Retrofit service
  must be registered in `NetworkModule`" does not apply — `NetworkModule` is
  deleted in this run and nothing replaces it. DI comes from the annotation and
  the regenerated `service_locator.config.dart`.
- `lib/features/featured/services/` is a new folder. Creating it is the intended
  outcome of this decision, not an accident.

### Testing mode — re-evaluated, unchanged at `coverage`

Re-checked against the skill's first-match rule now that decode is feature-scoped.
It stays `coverage`, and the case is slightly stronger than before:

- The `coverage` trigger is "shared utility used by 3+ features".
  `SupabaseIgdbClient` is injected by `GamesApiService`, `GameDetailApiService`
  and `FeaturedApiService` — still exactly three features, unchanged by this
  revision. The shared class got smaller in line count but not narrower in blast
  radius: every IGDB read in the app goes through its one `invoke`.
- Decision 1 moved the timeout *into* that shared class, so the shared surface
  now carries more criterion-bearing logic than it did under the old split
  (function name, body shape, and the REQ-NC 30-second bound), not less.
- What changed is where the tests point, not how deep they go: the shared class
  gets its own test file, and the array-decode assertions stay in the two
  feature test files where the model types live. No test is dropped.
- `smoke` was considered and rejected: it requires "isolated with no shared
  dependencies", and all three services share `SupabaseIgdbClient`.

### `flutter-arch.md` — flagged follow-up, not in the allowlist

The line `services/ exists in games and game_detail only. IgdbApiService under
features/games/services/ is the shared IGDB client — featured injects it directly
rather than defining its own` is directly contradicted by this run. It is
**not** added to the file allowlist. Reasons:

1. `tech-ac.md ## Out of scope` already names updating `flutter-arch.md` and
   `api-contracts.md` as a documentation follow-up, and that scope call passed
   the Phase 1 gate. Pulling it back in is a scope change, not a design decision.
2. That line is not the only invalidated one. This run also kills the
   `services/api/ — NetworkModule, TwitchAuthInterceptor` tree entry, the whole
   `NetworkModule` subsection, the `HTTP networking — Dio + Retrofit` section
   including its `IgdbApiService` code sample, and the `TwitchAuthInterceptor`
   subsection. Fixing one line and leaving five stale sections makes the document
   more misleading than leaving it uniformly stale with a follow-up on it.
3. `.agents/` is git-ignored with no version history (see `CLAUDE.md`), so a
   partial edit made mid-run by the Dev Agent is not recoverable and not
   reviewable in a diff.

Follow-up to raise after this run ships: one documentation pass over
`flutter-arch.md` and `api-contracts.md` replacing the Dio/Retrofit/Twitch
sections with the Supabase-function path, and rewriting the `services/` deviation
line to the new convention — `services/` now exists in games, game_detail and
featured, each holding a plain `@injectable` `[Feature]ApiService` over the shared
`SupabaseIgdbClient`.

### `tdd.md` — left stale deliberately, not rewritten

Judged not big enough to warrant a rewrite. The change redistributes the same
responsibilities across three classes and moves one `.timeout` call up a layer;
it adds no layer, no model, no use case, no state and no UI. `tdd.md
## Layer map`, `## Models`, `## DataSources`, `## Domain/State/UI layer`,
`## Shared-code changes` (items 1 and 2) and `## Out of scope` all remain true
verbatim. Rewriting would create a third source of truth that can drift from the
delta and `task-brief.md`, which are what Dev and QA actually execute against.

Stale in `tdd.md`, superseded by this delta — read these from here, not there:

- `## Feature summary` — describes two new core classes; there is now one core
  class and three feature services, and the timeout sentence is wrong.
- `## Data layer ### Services` — the `IgdbProxyService` entry and its
  `fetchGames` / `fetchReleaseDates` / `fetchList` signatures, the
  `IgdbProxyClient` file path, and the note that `IgdbProxyClient` holds no
  timeout. Also: `GameDetailService` is not simply deleted, it is superseded by
  `GameDetailApiService` in the same folder.
- `## Data layer ### DataSources` / `### Repositories` — the injected dependency
  named in each is now the per-feature service.
- `## Reuse decisions` — the `SupabasePing` / `AuthDatasource` pattern line still
  holds for the client, but `SupabaseIgdbClient` is now itself unit-tested
  against a mocked SDK, once.
- `## Shared-code changes` closing paragraph — the timeout placement sentence, as
  set out under Decision 1 above.
- Delta 1's stale-name list still applies on top of this.

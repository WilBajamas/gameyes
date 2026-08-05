# Code Plan
Source: `.agents/week-1-task-briefs.md` item 9 (Stage 3 — Infrastructure), checklist
lines 2–3, via `.agents/runs/igdb-client-repoint-20260805/tech-ac.md`
Date: 2026-08-05

## CREATE NEW

### lib/core/services/supabase/igdb_proxy_client.dart

```dart
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Asks the igdb-proxy function one question and hands back whatever it replied
// with. It stays this thin so tests can stand in for Supabase without reaching
// the network.
@injectable
class IgdbProxyClient {
  const IgdbProxyClient(this._client);

  final SupabaseClient _client;

  Future<Object?> invoke({
    required String endpoint,
    required String query,
  }) async {
    final response = await _client.functions.invoke(
      IgdbProxyConstants.functionName,
      body: {'endpoint': endpoint, 'query': query},
    );

    return response.data;
  }
}
```

### lib/core/services/api/igdb_proxy_service.dart

```dart
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_proxy_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class IgdbProxyService {
  const IgdbProxyService(this._client);

  final IgdbProxyClient _client;

  Future<List<Game>> fetchGames(String query) => fetchList(
        endpoint: IgdbProxyConstants.gamesEndpoint,
        query: query,
        fromJson: Game.fromJson,
      );

  Future<List<ReleaseDate>> fetchReleaseDates(String query) => fetchList(
        endpoint: IgdbProxyConstants.releaseDatesEndpoint,
        query: query,
        fromJson: ReleaseDate.fromJson,
      );

  // The game detail model belongs to its own feature, which this file may not
  // import, so that caller passes its own decoder in.
  Future<List<T>> fetchList<T>({
    required String endpoint,
    required String query,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final body = await _client
        .invoke(endpoint: endpoint, query: query)
        .timeout(IgdbProxyConstants.requestTimeout);

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body.map((item) => fromJson(item as Map<String, dynamic>)).toList();
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

// ...added alongside the other constant classes:
class IgdbProxyConstants {
  static const functionName = 'igdb-proxy';
  static const gamesEndpoint = 'games';
  static const releaseDatesEndpoint = 'release_dates';

  // Same 30 seconds the direct IGDB calls used before the proxy.
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

### lib/features/games/data/datasources/games_datasource.dart

```dart
@injectable
class GamesDataSource {
  final IgdbProxyService igdbProxyService;

  const GamesDataSource(this.igdbProxyService);

  Future<GamesModel> fetchDatasourceGames({ /* unchanged */ }) async {
    final queryBuilder = IGDBQueryBuilder()      // unchanged
        .fields(IGDBConfig.standardGameFields)   // unchanged
        .limit(pageSize)                         // unchanged
        .offset((page - 1) * pageSize);          // unchanged
    // search / sort branch unchanged

    final response = await igdbProxyService.fetchGames(queryBuilder.build());

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
  final IgdbProxyService _igdbProxyService;

  GameDetailRemoteDatasource(this._igdbProxyService);

  Future<GameDetailModel> fetchGameDetail({required int id}) async {
    final query = IGDBQueryBuilder()             // unchanged
        .fields(IGDBConfig.standardGameFields)
        .where('id = $id')
        .limit(1)
        .build();

    final response = await _igdbProxyService.fetchList<GameDetailModel>(
      endpoint: IgdbProxyConstants.gamesEndpoint,
      query: query,
      fromJson: GameDetailModel.fromJson,
    );

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
  final IgdbProxyService _igdbProxyService;

  FeaturedRepositoryImpl(
    this._localDatasource,
    this._igdbProxyService,
  );

  // _gameFields, every IGDBQueryBuilder chain, the sorting, the 7-then-14 day
  // retry, the critics top-up and every catch block stay exactly as they are.
  // Only the five call sites change, all in this shape:
  //   final games = await _igdbProxyService.fetchGames(query);
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

### test/api/games/games_test.dart (rewrite — mocks `IgdbProxyClient`, real `IgdbProxyService` and real `GamesDataSource`)
- `'should send the games endpoint and the built query to the proxy when fetching games'` — captures the `invoke` arguments and asserts the endpoint is `games` and the query string matches the builder output exactly
- `'should send a search query with no sort clause when a search term is given'` — the search-suppresses-sort rule and the offset arithmetic survive the swap
- `'should return GamesModel with count 0 and decoded games when the proxy returns a JSON array'` — decoding a bare array into `List<Game>`
- `'should throw when the proxy reply is not a JSON array'` — never a silently empty list
- `'should throw FunctionException when the proxy call fails'` — the failure reaches the repository
- `'should send the release dates endpoint and decode into ReleaseDate when fetching release dates'` — `IgdbProxyService.fetchReleaseDates`
- `'should fail rather than hang when the proxy does not answer within 30 seconds'` — `testWidgets` with a never-completing stub and `tester.pump(const Duration(seconds: 31))`, same shape as `supabase_connection_checker_test.dart`

### test/api/game_detail/game_detail_test.dart (rewrite — mocks `IgdbProxyClient`, real `IgdbProxyService` and real `GameDetailRemoteDatasource`)
- `'should send the games endpoint and the id query to the proxy when fetching game detail'` — asserts endpoint `games` and the `where id = N` query
- `'should return the first decoded GameDetailModel when the proxy returns a JSON array'`
- `'should throw when the proxy returns an empty array'` — the pre-existing rough edge is preserved, not fixed
- `'should throw FunctionException when the proxy call fails'`

### test/repository/games/games_repository_test.dart (one appended case; existing cases untouched)
- `'should return Failure carrying the proxy status code and message when the datasource throws FunctionException'`

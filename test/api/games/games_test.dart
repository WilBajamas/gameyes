import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:gaming_library_assessment_flutter/core/utils/igdb_query_builder.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasources/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/services/games_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_mock.dart';
import '../../mocks/release_date_mock.dart';
import 'games_test.mocks.dart';

@GenerateMocks([SupabaseIgdbProxyService])
void main() {
  late MockSupabaseIgdbProxyService igdbProxy;
  late GamesApiService gamesApiService;
  late GamesDataSource gamesDataSource;

  setUp(() {
    igdbProxy = MockSupabaseIgdbProxyService();
    gamesApiService = GamesApiService(igdbProxy);
    gamesDataSource = GamesDataSource(gamesApiService);
  });

  tearDown(() {
    reset(igdbProxy);
  });

  test('should send the games endpoint and the built query to the proxy '
      'when fetching games', () async {
    final expectedQuery = IGDBQueryBuilder()
        .fields(IGDBConfig.standardGameFields)
        .limit(20)
        .offset(0)
        .sort('first_release_date')
        .build();

    when(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
        'query': expectedQuery,
      }),
    ).thenAnswer((_) async => mockGamesJson);

    await gamesDataSource.fetchDatasourceGames();

    verify(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
        'query': expectedQuery,
      }),
    );
  });

  test('should send a search query with no sort clause when a search term '
      'is given', () async {
    final expectedQuery = IGDBQueryBuilder()
        .fields(IGDBConfig.standardGameFields)
        .limit(20)
        .offset(20)
        .search('zelda')
        .build();

    when(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
        'query': expectedQuery,
      }),
    ).thenAnswer((_) async => mockGamesJson);

    await gamesDataSource.fetchDatasourceGames(page: 2, searchTerm: 'zelda');

    verify(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
        'query': expectedQuery,
      }),
    );
  });

  test('should return GamesModel with count 0 and decoded games when the '
      'proxy returns a JSON array', () async {
    when(igdbProxy.invoke(any)).thenAnswer((_) async => mockGamesJson);

    final result = await gamesDataSource.fetchDatasourceGames();

    expect(result, GamesModel(count: 0, results: mockListGames));
  });

  test('should throw when the proxy reply is not a JSON array', () async {
    when(
      igdbProxy.invoke(any),
    ).thenAnswer((_) async => {'unexpected': 'shape'});

    expect(
      () => gamesDataSource.fetchDatasourceGames(),
      throwsA(isA<FormatException>()),
    );
  });

  test('should throw DioException when the proxy call fails', () async {
    when(igdbProxy.invoke(any)).thenAnswer((_) async => throw mockDioException);

    expect(
      () => gamesDataSource.fetchDatasourceGames(),
      throwsA(isA<DioException>()),
    );
  });

  test('should send the release dates endpoint and decode into ReleaseDate '
      'when fetching release dates', () async {
    const query = 'fields date,human,category; where id = 1;';

    when(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.releaseDatesEndpoint,
        'query': query,
      }),
    ).thenAnswer((_) async => mockReleaseDatesJson);

    final result = await gamesApiService.fetchReleaseDates(query);

    expect(result, [mockReleaseDate, mockReleaseDate]);
    verify(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.releaseDatesEndpoint,
        'query': query,
      }),
    );
  });
}

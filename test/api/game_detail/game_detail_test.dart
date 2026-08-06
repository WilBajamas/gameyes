import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:gaming_library_assessment_flutter/core/utils/igdb_query_builder.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/services/game_detail_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_detail_response_mock.dart';
import 'game_detail_test.mocks.dart';

@GenerateMocks([SupabaseIgdbClient])
void main() {
  late MockSupabaseIgdbClient igdbClient;
  late GameDetailApiService gameDetailApiService;
  late GameDetailRemoteDatasource gameDetailDatasource;

  setUp(() {
    igdbClient = MockSupabaseIgdbClient();
    gameDetailApiService = GameDetailApiService(igdbClient);
    gameDetailDatasource = GameDetailRemoteDatasource(gameDetailApiService);
  });

  tearDown(() {
    reset(igdbClient);
  });

  test('should send the games endpoint and the id query to the proxy when '
      'fetching game detail', () async {
    final expectedQuery = IGDBQueryBuilder()
        .fields(IGDBConfig.standardGameFields)
        .where('id = 87')
        .limit(1)
        .build();

    when(
      igdbClient.invoke(
        endpoint: SupabaseIgdbProxyConstants.gamesEndpoint,
        query: expectedQuery,
      ),
    ).thenAnswer((_) async => mockGameDetailJson);

    await gameDetailDatasource.fetchGameDetail(id: 87);

    verify(
      igdbClient.invoke(
        endpoint: SupabaseIgdbProxyConstants.gamesEndpoint,
        query: expectedQuery,
      ),
    );
  });

  test('should return the first decoded GameDetailModel when the proxy '
      'returns a JSON array', () async {
    when(
      igdbClient.invoke(
        endpoint: anyNamed('endpoint'),
        query: anyNamed('query'),
      ),
    ).thenAnswer((_) async => mockGameDetailJson);

    final result = await gameDetailDatasource.fetchGameDetail(id: 1);

    expect(result, mockGameDetailResponse);
  });

  test('should throw when the proxy returns an empty array', () async {
    when(
      igdbClient.invoke(
        endpoint: anyNamed('endpoint'),
        query: anyNamed('query'),
      ),
    ).thenAnswer((_) async => mockEmptyGameDetailJson);

    expect(
      () => gameDetailDatasource.fetchGameDetail(id: 1),
      throwsA(isA<StateError>()),
    );
  });

  test('should throw FunctionException when the proxy call fails', () async {
    when(
      igdbClient.invoke(
        endpoint: anyNamed('endpoint'),
        query: anyNamed('query'),
      ),
    ).thenAnswer((_) async => throw mockFunctionException);

    expect(
      () => gameDetailDatasource.fetchGameDetail(id: 1),
      throwsA(isA<FunctionException>()),
    );
  });
}

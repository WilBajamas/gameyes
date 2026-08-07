import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:gaming_library_assessment_flutter/core/utils/igdb_query_builder.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/services/game_detail_api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_detail_response_mock.dart';
import 'game_detail_test.mocks.dart';

@GenerateMocks([SupabaseIgdbProxyService])
void main() {
  late MockSupabaseIgdbProxyService igdbProxy;
  late GameDetailApiService gameDetailApiService;
  late GameDetailRemoteDatasource gameDetailDatasource;

  setUp(() {
    igdbProxy = MockSupabaseIgdbProxyService();
    gameDetailApiService = GameDetailApiService(igdbProxy);
    gameDetailDatasource = GameDetailRemoteDatasource(gameDetailApiService);
  });

  tearDown(() {
    reset(igdbProxy);
  });

  test('should send the games endpoint and the id query to the proxy when '
      'fetching game detail', () async {
    final expectedQuery = IGDBQueryBuilder()
        .fields(IGDBConfig.standardGameFields)
        .where('id = 87')
        .limit(1)
        .build();

    when(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
        'query': expectedQuery,
      }),
    ).thenAnswer((_) async => mockGameDetailJson);

    await gameDetailDatasource.fetchGameDetail(id: 87);

    verify(
      igdbProxy.invoke({
        'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
        'query': expectedQuery,
      }),
    );
  });

  test('should return the first decoded GameDetailModel when the proxy '
      'returns a JSON array', () async {
    when(igdbProxy.invoke(any)).thenAnswer((_) async => mockGameDetailJson);

    final result = await gameDetailDatasource.fetchGameDetail(id: 1);

    expect(result, mockGameDetailResponse);
  });

  test('should throw when the proxy returns an empty array', () async {
    when(
      igdbProxy.invoke(any),
    ).thenAnswer((_) async => mockEmptyGameDetailJson);

    expect(
      () => gameDetailDatasource.fetchGameDetail(id: 1),
      throwsA(isA<StateError>()),
    );
  });

  test('should throw DioException when the proxy call fails', () async {
    when(igdbProxy.invoke(any)).thenAnswer((_) async => throw mockDioException);

    expect(
      () => gameDetailDatasource.fetchGameDetail(id: 1),
      throwsA(isA<DioException>()),
    );
  });
}

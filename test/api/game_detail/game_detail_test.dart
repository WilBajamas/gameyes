import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../mocks/game_detail_response_mock.dart';
import '../../mocks/game_response_mock.dart';

void main() {
  late DioAdapter dioAdapter;
  late Dio dio;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com'));

    // GetIt.I.registerSingleton(mockDioService);

    dioAdapter = DioAdapter(
      dio: dio,
      matcher: const FullHttpRequestMatcher(),
    );
  });

  test('fetches game detail response successfully', () async {
    const path = '/games/87';

    dioAdapter.onGet(
      path,
      (server) => server.reply(
        201,
        mockGameDetailResponse,
        delay: const Duration(seconds: 1),
      ),
    );

    final response = await dio.get(path);

    final gamesResponse =
        GameDetailResponse.fromJson(response.data as Map<String, dynamic>);

    expect(response.statusCode, 201);
    expect(gamesResponse, isA<GameDetailResponse>());
  });

  test('fetches game detail response failed', () async {
    const path = '/games/87';

    dioAdapter.onGet(
      path,
      (server) => server.throws(
        404,
        DioException(
          requestOptions: RequestOptions(
            path: path,
          ),
        ),
      ),
    );

    expect(() async => await dio.get(path), throwsA(isA<DioException>()));
  });
}

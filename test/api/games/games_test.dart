import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../mocks/game_response_mock.dart';

void main() {
  late DioAdapter dioAdapter;
  late Dio dio;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com'));

    // GetIt.I.registerSingleton(mockDioService);

    dioAdapter = DioAdapter(
      dio: dio,
    );
  });

  test('fetches games response successfully', () async {
    const path = '/games';

    dioAdapter.onGet(
      path,
      (server) => server.reply(
        201,
        mockGamesResponse,
        delay: const Duration(seconds: 1),
      ),
    );

    final response = await dio.get(path);

    final gamesResponse =
        GamesResponse.fromJson(response.data as Map<String, dynamic>);

    expect(response.statusCode, 201);
    expect(gamesResponse, isA<GamesResponse>());
  });

  test('fetches games response failed', () async {
    const path = '/games';

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

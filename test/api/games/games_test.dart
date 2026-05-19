import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
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

    dioAdapter.onPost(
      path,
      (server) => server.reply(
        201,
        mockGamesResponse,
        delay: const Duration(seconds: 1),
      ),
    );

    final response = await dio.post(path);

    final list = (response.data as List)
        .map((i) => Game.fromJson(i as Map<String, dynamic>))
        .toList();

    expect(response.statusCode, 201);
    expect(list, isA<List<Game>>());
  });

  test('fetches games response failed', () async {
    const path = '/games';

    dioAdapter.onPost(
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

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasources/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/repositories/games_repository_impl.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/repositories/games_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_response_mock.dart';
import 'games_repository_test.mocks.dart';

@GenerateMocks([GamesDataSource])
void main() {
  late GamesRepository gamesRepository;
  late GamesDataSource gamesDataSource;

  setUp(() {
    provideDummy<GamesModel>(mockGamesResponse);
    provideDummy<Result<GameListEntity>>(Success(mockGamesResponse.toEntity()));
    gamesDataSource = MockGamesDataSource();
    gamesDataSource = MockGamesDataSource();

    GetIt.I.registerSingleton(gamesDataSource);

    gamesRepository = GamesRepositoryImpl(gamesDataSource);
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gamesDataSource);
  });

  test(
    'should return Success(GameListEntity) when datasource fetch is successful',
    () async {
      when(
        gamesDataSource.fetchDatasourceGames(),
      ).thenAnswer((_) async => mockGamesResponse);

      final result = await gamesRepository.fetchGames();

      expect(result, isA<Success<GameListEntity>>());
      expect(
        (result as Success<GameListEntity>).value,
        mockGamesResponse.toEntity(),
      );
      verify(gamesDataSource.fetchDatasourceGames());
    },
  );

  test(
    'should return Failure(ErrorType) when datasource fetch fails',
    () async {
      when(gamesDataSource.fetchDatasourceGames()).thenAnswer(
        (_) async => throw DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await gamesRepository.fetchGames();

      expect(result, isA<Failure<GameListEntity>>());
      expect(
        (result as Failure<GameListEntity>).error,
        mockConnectionTimeoutError,
      );
      verify(gamesDataSource.fetchDatasourceGames());
    },
  );

  test('should return Failure carrying the proxy status code and message '
      'when the datasource throws FunctionException', () async {
    when(
      gamesDataSource.fetchDatasourceGames(),
    ).thenAnswer((_) async => throw mockFunctionException);

    final result = await gamesRepository.fetchGames();

    expect(result, isA<Failure<GameListEntity>>());
    expect(
      (result as Failure<GameListEntity>).error,
      ErrorType.functionError(exception: mockFunctionException),
    );
    verify(gamesDataSource.fetchDatasourceGames());
  });
}

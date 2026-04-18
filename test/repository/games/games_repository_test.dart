import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
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
    gamesDataSource = MockGamesDataSource();

    GetIt.I.registerSingleton(gamesDataSource);

    gamesRepository = GamesRepositoryImpl(gamesDataSource);
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gamesDataSource);
  });

  test('should return Right(GamesResponse) when datasource fetch is successful',
      () async {
    when(gamesDataSource.fetchDatasourceGames())
        .thenAnswer((_) async => mockGamesResponse);

    final result = await gamesRepository.fetchGames();

    expect(result, Right(mockGamesResponse));
    verify(gamesDataSource.fetchDatasourceGames());
  });

  test('should return Left(ErrorType) when datasource fetch fails', () async {
    when(gamesDataSource.fetchDatasourceGames())
        .thenAnswer((_) async => mockResponseError);

    final result = await gamesRepository.fetchGames();

    expect(result, Left(mockResponseError));
    verify(gamesDataSource.fetchDatasourceGames());
  });
}

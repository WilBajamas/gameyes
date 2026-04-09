import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/repositories/games_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/use_case/fetch_games_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_response_mock.dart';
import 'fetch_games_use_case_test.mocks.dart';

@GenerateMocks([GamesRepository])
void main() {
  late GamesRepository gamesRepository;
  late FetchGamesUseCase fetchGamesUsecase;

  setUp(() {
    gamesRepository = MockGamesRepository();

    GetIt.I.registerSingleton(gamesRepository);

    fetchGamesUsecase = FetchGamesUseCase(gamesRepository);
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gamesRepository);
  });

  test(
      // ignore: lines_longer_than_80_chars
      'fetchGamesUsecase call function onSuccess callback should have been called when repository fetch is successful',
      () async {
    when(
      gamesRepository.fetchGames(
        page: 1,
        dateRange: '',
        ordering: '-null',
      ),
    ).thenAnswer((_) async => Right(mockGamesResponse));

    final result = await fetchGamesUsecase.call(
      page: 1,
    );

    expect(result, Right(mockGamesResponse));
    verify(
      gamesRepository.fetchGames(
        page: 1,
        dateRange: '',
        ordering: '-null',
      ),
    );
  });

  test(
      // ignore: lines_longer_than_80_chars
      'fetchGamesUsecase call function onFailure callback should have been called when repository fetch has failed',
      () async {
    when(
      gamesRepository.fetchGames(
        page: 1,
        dateRange: '',
        ordering: '-null',
      ),
    ).thenAnswer((_) async => Left(mockResponseError));

    final result = await fetchGamesUsecase.call(
      page: 1,
    );

    expect(result, Left(mockResponseError));
    verify(
      gamesRepository.fetchGames(
        page: 1,
        dateRange: '',
        ordering: '-null',
      ),
    );
  });
}

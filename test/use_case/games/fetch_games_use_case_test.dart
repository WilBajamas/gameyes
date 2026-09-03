import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/repositories/games_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/use_cases/fetch_games_use_case.dart';
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
    provideDummy<Result<GameListEntity>>(Success(mockGamesResponse.toEntity()));
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
          searchTerm: anyNamed('searchTerm'),
          dateRange: anyNamed('dateRange'),
          platforms: anyNamed('platforms'),
          genres: anyNamed('genres'),
          ordering: anyNamed('ordering'),
        ),
      ).thenAnswer((_) async => Success(mockGamesResponse.toEntity()));

      final result = await fetchGamesUsecase.call(page: 1);

      expect(result, isA<Success<GameListEntity>>());
      expect(
        (result as Success<GameListEntity>).value,
        mockGamesResponse.toEntity(),
      );
      verify(
        gamesRepository.fetchGames(
          page: 1,
          searchTerm: anyNamed('searchTerm'),
          dateRange: anyNamed('dateRange'),
          platforms: anyNamed('platforms'),
          genres: anyNamed('genres'),
          ordering: anyNamed('ordering'),
        ),
      );
    },
  );

  test(
    // ignore: lines_longer_than_80_chars
    'fetchGamesUsecase call function onFailure callback should have been called when repository fetch has failed',
    () async {
      when(
        gamesRepository.fetchGames(
          page: 1,
          searchTerm: anyNamed('searchTerm'),
          dateRange: anyNamed('dateRange'),
          platforms: anyNamed('platforms'),
          genres: anyNamed('genres'),
          ordering: anyNamed('ordering'),
        ),
      ).thenAnswer((_) async => Failure(mockResponseError));

      final result = await fetchGamesUsecase.call(page: 1);

      expect(result, isA<Failure<GameListEntity>>());
      expect((result as Failure<GameListEntity>).error, mockResponseError);
      verify(
        gamesRepository.fetchGames(
          page: 1,
          searchTerm: anyNamed('searchTerm'),
          dateRange: anyNamed('dateRange'),
          platforms: anyNamed('platforms'),
          genres: anyNamed('genres'),
          ordering: anyNamed('ordering'),
        ),
      );
    },
  );
}

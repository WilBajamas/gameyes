import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/use_case/fetch_games_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/date_time_mock.dart';
import '../../mocks/game_genre_mock.dart';
import '../../mocks/game_platform_mock.dart';
import '../../mocks/game_response_mock.dart';
import 'games_bloc_test.mocks.dart';

@GenerateMocks([GamesRepository, FetchGamesUseCase])
void main() {
  late GamesRepository gamesRepository;
  late FetchGamesUseCase fetchGamesUseCase;
  late GamesBloc gamesBloc;

  setUp(() {
    gamesRepository = MockGamesRepository();
    fetchGamesUseCase = MockFetchGamesUseCase();

    GetIt.I.registerSingleton(gamesRepository);
    GetIt.I.registerSingleton(fetchGamesUseCase);

    gamesBloc = GamesBloc();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gamesRepository);
    reset(fetchGamesUseCase);
  });

  test('initial state is empty GamesState', () {
    expect(
      gamesBloc.state,
      const GamesState(),
    );

    expect(
      gamesBloc.state.status,
      GamesStatus.initial,
    );
  });

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits empty GamesState with initial status followed by GamesState with success when GamesFetched event is called',
    setUp: () async {
      when(
        gamesRepository.fetchGames(
          searchTerm: 'test search',
          dateRange: mockDateTimeRange,
          ordering: '-${GameOrdering.rating.name}',
          platforms: mockGamePlatformsName,
          genres: mockGameGenresNames,
          page: 1,
        ),
      ).thenAnswer((_) async => Right(mockGamesResponse));

      // when(
      //   fetchGamesUseCase(
      //     searchTerm: 'test search',
      //     dateFrom: mockDateTimeBefore,
      //     dateTo: mockDateTimeAfter,
      //     ordering: GameOrdering.rating,
      //     platforms: mockGamePlatforms,
      //     genres: mockGameGenres,
      //     page: 1,
      //     onFailure: (e) => null,
      //     onSuccess: (r) => r,
      //   ),
      // ).thenAnswer((_) async => Future<void>);
    },
    build: () => gamesBloc,
    act: (bloc) async => bloc.add(
      GamesFetched(
        searchTerm: 'test search',
        dateFrom: mockDateTimeBefore,
        dateTo: mockDateTimeAfter,
        platforms: mockGamePlatforms,
        ordering: GameOrdering.rating,
        genres: mockGameGenres,
        ascending: false,
      ),
    ),
    expect: () => [
      const GamesState(status: GamesStatus.loading),
      GamesState(
        status: GamesStatus.success,
        response: mockGamesResponse,
        games: mockGamesResponse.results!,
      ),
    ],
  );
}

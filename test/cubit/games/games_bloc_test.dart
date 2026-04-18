import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/use_cases/fetch_games_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/date_time_mock.dart';
import '../../mocks/error_mock.dart';
import '../../mocks/game_genre_mock.dart';
import '../../mocks/game_platform_mock.dart';
import '../../mocks/game_response_mock.dart';
import 'games_bloc_test.mocks.dart';

@GenerateMocks([FetchGamesUseCase])
void main() {
  late FetchGamesUseCase fetchGamesUseCase;
  late GamesBloc gamesBloc;

  setUp(() {
    fetchGamesUseCase = MockFetchGamesUseCase();

    GetIt.I.registerSingleton(fetchGamesUseCase);

    gamesBloc = GamesBloc(fetchGamesUseCase);
  });

  tearDown(() {
    GetIt.instance.reset();
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
        fetchGamesUseCase.call(
          searchTerm: 'test search',
          dateFrom: mockDateTimeBefore,
          dateTo: mockDateTimeAfter,
          ordering: GameOrdering.rating,
          platforms: mockGamePlatforms,
          genres: mockGameGenres,
          page: 1,
        ),
      ).thenAnswer((_) async => Right(mockGamesResponse));
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

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits empty GamesState with initial status followed by GamesState with failed when GamesFetched event is called',
    setUp: () async {
      when(
        fetchGamesUseCase.call(
          searchTerm: 'test search',
          dateFrom: mockDateTimeBefore,
          dateTo: mockDateTimeAfter,
          ordering: GameOrdering.rating,
          platforms: mockGamePlatforms,
          genres: mockGameGenres,
          page: 1,
        ),
      ).thenAnswer((_) async => Left(mockResponseError));
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
      GamesState(status: GamesStatus.failed, error: mockResponseError),
    ],
  );
}

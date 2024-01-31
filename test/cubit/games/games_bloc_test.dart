import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/date_time_mock.dart';
import '../../mocks/error_mock.dart';
import '../../mocks/game_platform_mock.dart';
import '../../mocks/game_response_mock.dart';
import '../../mocks/games_state_mock.dart';
import 'games_bloc_test.mocks.dart';

@GenerateMocks([GamesRepository])
void main() {
  late GamesRepository gamesRepository;
  late GamesBloc gamesBloc;

  setUp(() {
    gamesRepository = MockGamesRepository();

    GetIt.I.registerSingleton(gamesRepository);

    gamesBloc = GamesBloc();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gamesRepository);
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
    'emits empty GamesState with initial status followed by GamesState with success when GamesFetched event is called with resetPage is true',
    setUp: () {
      when(
        gamesRepository.fetchGames(
          searchTerm: 'test search',
          ordering: GameOrdering.rating,
          platforms: mockListGamePlatform,
          page: 1,
          dateFrom: mockDateTimeBefore,
          dateTo: mockDateTimeAfter,
        ),
      ).thenAnswer((_) async => Right(mockGamesResponse));
    },
    build: () => gamesBloc,
    act: (bloc) async => bloc.add(
      GamesFetched(
        resetPage: true,
        searchTerm: 'test search',
        dateFrom: mockDateTimeBefore,
        dateTo: mockDateTimeAfter,
        platforms: mockListGamePlatform,
        ordering: GameOrdering.rating,
      ),
    ),
    expect: () => [
      const GamesState(status: GamesStatus.initial),
      GamesState(
        status: GamesStatus.success,
        response: mockGamesResponse,
        games: mockGamesResponse.results!,
      ),
    ],
  );

  blocTest<GamesBloc, GamesState>(
    // ignore: lines_longer_than_80_chars
    'emits GamesState with success with response games added to existing games when GamesFetched event is called with resetPage is false',
    seed: () => mockExistingGamesState,
    setUp: () {
      when(
        gamesRepository.fetchGames(
          searchTerm: 'test search',
          ordering: GameOrdering.rating,
          platforms: mockListGamePlatform,
          page: 2,
          dateFrom: mockDateTimeBefore,
          dateTo: mockDateTimeAfter,
        ),
      ).thenAnswer((_) async => Right(mockGamesResponse));
    },
    build: () => gamesBloc,
    act: (bloc) async => bloc.add(
      GamesFetched(
        resetPage: false,
        searchTerm: 'test search',
        dateFrom: mockDateTimeBefore,
        dateTo: mockDateTimeAfter,
        platforms: mockListGamePlatform,
        ordering: GameOrdering.rating,
      ),
    ),
    expect: () => [
      GamesState(
        status: GamesStatus.success,
        games: mockExistingGamesState.games..addAll(mockGamesResponse.results!),
        response: mockGamesResponse,
      ),
    ],
  );

  blocTest(
    // ignore: lines_longer_than_80_chars
    'returns nothing when previous response has no next page',
    setUp: () {
      when(
        gamesRepository.fetchGames(
          searchTerm: 'test search',
          ordering: GameOrdering.rating,
          platforms: mockListGamePlatform,
          page: 1,
          dateFrom: mockDateTimeBefore,
          dateTo: mockDateTimeAfter,
        ),
      ).thenAnswer((_) async => Right(mockGamesResponse));
    },
    build: () => gamesBloc,
    act: (bloc) async => bloc.add(
      GamesFetched(
        resetPage: false,
        searchTerm: 'test search',
        dateFrom: mockDateTimeBefore,
        dateTo: mockDateTimeAfter,
        platforms: mockListGamePlatform,
        ordering: GameOrdering.rating,
      ),
    ),
    expect: () => [],
  );

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits  GamesState with failure status when GamesFetched event is called with resetPage is true',
    setUp: () {
      when(
        gamesRepository.fetchGames(
          searchTerm: 'test search',
          ordering: GameOrdering.rating,
          platforms: mockListGamePlatform,
          page: 1,
          dateFrom: mockDateTimeBefore,
          dateTo: mockDateTimeAfter,
        ),
      ).thenAnswer((_) async => Left(mockResponseError));
    },
    build: () => gamesBloc,
    act: (bloc) async => bloc.add(
      GamesFetched(
        resetPage: true,
        searchTerm: 'test search',
        dateFrom: mockDateTimeBefore,
        dateTo: mockDateTimeAfter,
        platforms: mockListGamePlatform,
        ordering: GameOrdering.rating,
      ),
    ),
    expect: () => [
      const GamesState(status: GamesStatus.initial),
      const GamesState(status: GamesStatus.failure),
    ],
  );
}

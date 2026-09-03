import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_state.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/game_response_mock.dart';
import 'games_bloc_test.mocks.dart';

void main() {
  test(
    'reaches GamesStatus.empty when a fetch succeeds with no games',
    () async {
      provideDummy<Result<GameListEntity>>(
        Success(mockGamesResponseEmptyResults.toEntity()),
      );

      final fetchGamesUseCase = MockFetchGamesUseCase();
      when(
        fetchGamesUseCase.call(
          page: anyNamed('page'),
          searchTerm: anyNamed('searchTerm'),
          dateFrom: anyNamed('dateFrom'),
          dateTo: anyNamed('dateTo'),
          platforms: anyNamed('platforms'),
          genres: anyNamed('genres'),
          ordering: anyNamed('ordering'),
        ),
      ).thenAnswer(
        (_) async => Success(mockGamesResponseEmptyResults.toEntity()),
      );

      final bloc = GamesBloc(fetchGamesUseCase);

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<GamesState>((state) => state.status == GamesStatus.empty),
        ),
      );

      await bloc.close();
    },
  );

  test(
    'GamesFiltersCleared resets the filter state before refetching',
    () async {
      provideDummy<Result<GameListEntity>>(
        Success(mockGamesResponse.toEntity()),
      );

      final fetchGamesUseCase = MockFetchGamesUseCase();
      when(
        fetchGamesUseCase.call(
          page: anyNamed('page'),
          searchTerm: anyNamed('searchTerm'),
          dateFrom: anyNamed('dateFrom'),
          dateTo: anyNamed('dateTo'),
          platforms: anyNamed('platforms'),
          genres: anyNamed('genres'),
          ordering: anyNamed('ordering'),
        ),
      ).thenAnswer((_) async => Success(mockGamesResponse.toEntity()));

      final bloc = GamesBloc(fetchGamesUseCase);

      bloc.add(GamesFetched(searchTerm: 'zzzz', genres: {GameGenre.shooter}));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<GamesState>(
            (state) => state.filterState.searchTerm == 'zzzz',
          ),
        ),
      );

      bloc.add(const GamesFiltersCleared());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<GamesState>(
            (state) =>
                state.filterState.searchTerm == null &&
                state.filterState.genres.isEmpty &&
                state.filterState.platforms.isEmpty,
          ),
        ),
      );

      await bloc.close();
    },
  );
}

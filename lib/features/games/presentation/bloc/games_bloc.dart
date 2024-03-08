import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/use_case/fetch_games_use_case.dart';
import 'package:injectable/injectable.dart';

part 'games_event.dart';
part 'games_state.dart';

@injectable
class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final _fetchGamesUsecase = injection.getIt<FetchGamesUseCase>();

  GamesBloc() : super(const GamesState()) {
    on<GamesFetched>(_onFetchGames, transformer: droppable());
    on<GamesNextPage>(_onFetchNextPage, transformer: droppable());
  }

  Future<void> _onFetchGames(
    GamesFetched event,
    Emitter<GamesState> emit,
  ) async {
    emit(
      const GamesState(
        status: GamesStatus.loading,
      ),
    );
    
    await _fetchGamesUsecase(
      page: 1,
      searchTerm: event.searchTerm,
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      platforms: event.platforms,
      genres: event.genres,
      ordering: event.ordering,
      onFailure: (error) =>
          emit(state.copyWith(status: GamesStatus.failed, error: error)),
      onSuccess: (response) => emit(
        state.copyWith(
          status: GamesStatus.success,
          response: response,
          games: response.results,
        ),
      ),
    );
  }

  Future<void> _onFetchNextPage(
    GamesNextPage event,
    Emitter<GamesState> emit,
  ) async {
    if (state.response?.next == null || state.response?.currentPage == null) {
      return;
    }

    emit(state.copyWith(nextPageStatus: GamesNextPageStatus.loading));

    await _fetchGamesUsecase(
      page: state.response!.currentPage! + 1,
      searchTerm: event.searchTerm,
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      platforms: event.platforms,
      genres: event.genres,
      ordering: event.ordering,
      onSuccess: (response) => emit(
        state.copyWith(
          nextPageStatus: GamesNextPageStatus.initial,
          response: response,
          games: List.of(state.games)..addAll(response.results!),
        ),
      ),
      onFailure: (error) => emit(
        state.copyWith(
          nextPageError: error,
          nextPageStatus: GamesNextPageStatus.failed,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/use_case/fetch_games_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../filter/presentation/cubit/filter_cubit.dart';

part 'games_event.dart';
part 'games_state.dart';

@injectable
class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final FetchGamesUseCase _fetchGamesUseCase;

  GamesBloc(this._fetchGamesUseCase) : super(const GamesState()) {
    on<GamesFetched>(_onFetchGames, transformer: droppable());
    on<GamesNextPage>(_onFetchNextPage, transformer: droppable());

    add(const GamesFetched());
  }

  void scrolledBottom({bool isBottom = false}) {
    if (isBottom && state.nextPageStatus != GamesNextPageStatus.failed) {
      add(const GamesNextPage());
    }
  }

  Future<void> _onFetchGames(
    GamesFetched event,
    Emitter<GamesState> emit,
  ) async {
    final filter = FilterState(
      searchTerm: event.searchTerm ?? state.filterState.searchTerm,
      dateFrom: event.dateFrom ?? state.filterState.dateFrom,
      dateTo: event.dateTo ?? state.filterState.dateTo,
      platforms: event.platforms ?? state.filterState.platforms,
      ordering: event.ordering ?? state.filterState.ordering,
      genres: event.genres ?? state.filterState.genres,
    );

    emit(
      state.copyWith(
        status: GamesStatus.loading,
        filterState: filter,
      ),
    );

    final result = await _fetchGames(
      1,
      filter,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: GamesStatus.failed,
          error: error,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: GamesStatus.success,
          response: response,
          games: response.results,
          filterState: filter,
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

    final result = await _fetchGames(
      state.response!.currentPage! + 1,
      state.filterState,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          nextPageError: error,
          nextPageStatus: GamesNextPageStatus.failed,
        ),
      ),
      (response) => emit(
        state.copyWith(
          nextPageStatus: GamesNextPageStatus.initial,
          response: response,
          games: List.of(state.games)..addAll(response.results!),
        ),
      ),
    );
  }

  Future<Either<ErrorType, GamesResponse>> _fetchGames(
    int page,
    FilterState filter,
  ) =>
      _fetchGamesUseCase(
        page: page,
        searchTerm: filter.searchTerm,
        dateFrom: filter.dateFrom,
        dateTo: filter.dateTo,
        platforms: filter.platforms,
        genres: filter.genres,
        ordering: filter.ordering,
      );
}

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubits/filter_state.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/use_cases/fetch_games_use_case.dart';
import 'package:injectable/injectable.dart';

import 'games_state.dart';

part 'games_event.dart';

@injectable
class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final FetchGamesUseCase _fetchGamesUseCase;

  GamesBloc(this._fetchGamesUseCase) : super(const GamesState()) {
    on<GamesFetched>(_onFetchGames, transformer: droppable());
    on<GamesFiltersCleared>(_onClearFilters, transformer: droppable());
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

    emit(state.copyWith(status: GamesStatus.loading, filterState: filter));

    final result = await _fetchGames(1, filter);

    final newState = switch (result) {
      Success(value: final response) => state.copyWith(
        status: response.items.isEmpty
            ? GamesStatus.empty
            : GamesStatus.success,
        response: response,
        games: response.items,
        currentPage: 1,
        filterState: filter,
      ),
      Failure(error: final error) => state.copyWith(
        status: GamesStatus.failed,
        error: error,
      ),
    };

    emit(newState);
  }

  Future<void> _onClearFilters(
    GamesFiltersCleared event,
    Emitter<GamesState> emit,
  ) async {
    const filter = FilterState();

    emit(state.copyWith(status: GamesStatus.loading, filterState: filter));

    final result = await _fetchGames(1, filter);

    final newState = switch (result) {
      Success(value: final response) => state.copyWith(
        status: response.items.isEmpty
            ? GamesStatus.empty
            : GamesStatus.success,
        response: response,
        games: response.items,
        currentPage: 1,
        filterState: filter,
      ),
      Failure(error: final error) => state.copyWith(
        status: GamesStatus.failed,
        error: error,
      ),
    };

    emit(newState);
  }

  Future<void> _onFetchNextPage(
    GamesNextPage event,
    Emitter<GamesState> emit,
  ) async {
    if (state.response?.nextUrl == null) {
      return;
    }

    emit(state.copyWith(nextPageStatus: GamesNextPageStatus.loading));

    final result = await _fetchGames(state.currentPage + 1, state.filterState);

    final newState = switch (result) {
      Success(value: final response) => state.copyWith(
        nextPageStatus: GamesNextPageStatus.initial,
        response: response,
        currentPage: state.currentPage + 1,
        games: List.of(state.games)..addAll(response.items),
      ),
      Failure(error: final error) => state.copyWith(
        nextPageError: error,
        nextPageStatus: GamesNextPageStatus.failed,
      ),
    };

    emit(newState);
  }

  Future<Result<GameListEntity>> _fetchGames(int page, FilterState filter) =>
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

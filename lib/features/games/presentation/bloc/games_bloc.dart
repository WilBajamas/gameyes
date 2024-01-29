import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';

part 'games_event.dart';
part 'games_state.dart';

@injectable
class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final _gamesRepository = injection.getIt<GamesRepository>();

  GamesBloc() : super(const GamesState()) {
    on<GamesFetched>(_onGamesFetched, transformer: droppable());
  }

  Future<void> _onGamesFetched(
    GamesFetched event,
    Emitter<GamesState> emit,
  ) async {
    if (event.resetPage) {
      emit(const GamesState());
    } else if (state.response?.next == null) {
      return;
    }

    final nextPage = state.status == GamesStatus.initial
        ? 1
        : state.response!.currentPage! + 1;

    final games = await _gamesRepository.fetchGames(
      page: nextPage,
      searchTerm: event.searchTerm,
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      ordering: event.ordering,
      platforms: event.platforms,
    );

    games.fold(
      (error) {
        emit(state.copyWith(status: GamesStatus.failure));
      },
      (response) {
        emit(
          response.results!.isEmpty
              ? state.copyWith(
                  response: response,
                  status: GamesStatus.success,
                )
              : state.copyWith(
                  status: GamesStatus.success,
                  games: List.of(state.games)..addAll(response.results!),
                  response: response,
                ),
        );
      },
    );
  }
}

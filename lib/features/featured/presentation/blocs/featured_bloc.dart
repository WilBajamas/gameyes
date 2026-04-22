import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/featured_tag.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/fetch_featured_use_case.dart';
import 'package:injectable/injectable.dart';

import 'featured_state.dart';

part 'featured_event.dart';

@injectable
class FeaturedBloc extends Bloc<FeaturedEvent, FeaturedState> {
  final FetchFeaturedUseCase _fetchFeaturedUseCase;

  FeaturedBloc(this._fetchFeaturedUseCase) : super(const FeaturedState()) {
    on<FeaturedFetched>(_onFetchFeatured, transformer: droppable());
    on<FeaturedNextPage>(_onFetchNextPage, transformer: droppable());

    add(const FeaturedFetched(tag: FeaturedTag.newAndTrending));
  }

  void scrolledBottom({bool isBottom = false}) {
    if (isBottom && state.nextPageStatus != FeaturedNextPageStatus.failed) {
      add(const FeaturedNextPage());
    }
  }

  Future<void> _onFetchFeatured(
    FeaturedFetched event,
    Emitter<FeaturedState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FeaturedStatus.loading,
        games: const <GameEntity>[],
        nextPageStatus: FeaturedNextPageStatus.initial,
      ),
    );

    final result = await _fetchFeaturedUseCase(
      page: 1,
      tag: event.tag ?? state.tag,
      platforms: event.platforms ?? state.platformsSelected,
    );

    final newState = switch (result) {
      Success(value: final response) => state.copyWith(
          tag: event.tag ?? state.tag,
          status: FeaturedStatus.success,
          response: response,
          games: response.items,
          platformsSelected: event.platforms ?? state.platformsSelected,
        ),
      Failure(error: final error) => state.copyWith(
          tag: event.tag ?? state.tag,
          status: FeaturedStatus.failed,
          error: error,
          platformsSelected: event.platforms ?? state.platformsSelected,
        ),
    };

    emit(newState);
  }

  Future<void> _onFetchNextPage(
    FeaturedNextPage event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state.response?.nextUrl == null || state.response?.currentPage == null) {
      return;
    }

    emit(state.copyWith(nextPageStatus: FeaturedNextPageStatus.loading));

    final result = await _fetchFeaturedUseCase(
      page: state.response!.currentPage! + 1,
      tag: state.tag,
      platforms: state.platformsSelected,
    );

    final newState = switch (result) {
      Success(value: final response) => state.copyWith(
          nextPageStatus: FeaturedNextPageStatus.initial,
          response: response,
          games: List.of(state.games)..addAll(response.items),
        ),
      Failure(error: final error) => state.copyWith(
          nextPageError: error,
          nextPageStatus: FeaturedNextPageStatus.failed,
        ),
    };

    emit(newState);
  }
}

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/core/enums/featured_tag.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_case/fetch_featured_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

part 'featured_event.dart';

part 'featured_state.dart';

@injectable
class FeaturedBloc extends Bloc<FeaturedEvent, FeaturedState> {
  final _fetchFeaturedUseCase = injection.getIt<FetchFeaturedUseCase>();

  FeaturedBloc() : super(const FeaturedState()) {
    on<FeaturedFetched>(_onFetchFeatured, transformer: droppable());
    on<FeaturedNextPage>(_onFetchNextPage, transformer: droppable());

    add(const FeaturedFetched(tag: FeaturedTag.newAndTrending));
  }

  Future<void> _onFetchFeatured(
    FeaturedFetched event,
    Emitter<FeaturedState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FeaturedStatus.loading,
        games: const <Game>[],
        nextPageStatus: FeaturedNextPageStatus.initial,
      ),
    );

    await _fetchFeaturedUseCase(
      page: 1,
      tag: event.tag ?? state.tag,
      platforms: event.platforms ?? state.platformsSelected,
      onFailure: (error) => emit(
        state.copyWith(
          tag: event.tag ?? state.tag,
          status: FeaturedStatus.failed,
          error: error,
          platformsSelected: event.platforms ?? state.platformsSelected,
        ),
      ),
      onSuccess: (response) => emit(
        state.copyWith(
          tag: event.tag ?? state.tag,
          status: FeaturedStatus.success,
          response: response,
          games: response.results,
          platformsSelected: event.platforms,
        ),
      ),
    );
  }

  Future<void> _onFetchNextPage(
    FeaturedNextPage event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state.response?.next == null || state.response?.currentPage == null) {
      return;
    }

    emit(state.copyWith(nextPageStatus: FeaturedNextPageStatus.loading));

    await _fetchFeaturedUseCase(
      page: state.response!.currentPage! + 1,
      tag: state.tag,
      platforms: state.platformsSelected,
      onSuccess: (response) => emit(
        state.copyWith(
          nextPageStatus: FeaturedNextPageStatus.initial,
          response: response,
          games: List.of(state.games)..addAll(response.results!),
        ),
      ),
      onFailure: (error) => emit(
        state.copyWith(
          nextPageError: error,
          nextPageStatus: FeaturedNextPageStatus.failed,
        ),
      ),
    );
  }
}

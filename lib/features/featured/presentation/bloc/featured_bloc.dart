import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_case/fetch_featured_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

part 'featured_event.dart';
part 'featured_state.dart';

@injectable
class FeaturedBloc extends Bloc<FeaturedEvent, FeaturedState> {
  final _fetchFeaturedUsecase = injection.getIt<FetchFeaturedUseCase>();

  FeaturedBloc() : super(const FeaturedState()) {
    on<FeaturedFetched>(_onFetchFeatured, transformer: droppable());
    on<FeaturedNextPage>(_onFetchNextPage, transformer: droppable());
  }

  Future<void> _onFetchFeatured(
    FeaturedFetched event,
    Emitter<FeaturedState> emit,
  ) async {
    emit(
      FeaturedState(
        tag: event.tag,
        status: FeaturedStatus.loading,
      ),
    );

    await _fetchFeaturedUsecase(
      page: 1,
      tag: event.tag,
      platforms: event.platforms,
      onFailure: (error) =>
          emit(state.copyWith(status: FeaturedStatus.failed, error: error)),
      onSuccess: (response) => emit(
        state.copyWith(
          status: FeaturedStatus.success,
          response: response,
          games: response.results,
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

    await _fetchFeaturedUsecase(
      page: state.response!.currentPage! + 1,
      tag: state.tag,
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

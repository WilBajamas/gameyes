import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

part 'featured_event.dart';
part 'featured_state.dart';

@injectable
class FeaturedBloc extends Bloc<FeaturedEvent, FeaturedState> {
  final _featuredRepository = injection.getIt<FeaturedRepository>();

  FeaturedBloc() : super(const FeaturedState()) {
    on<FeaturedFetched>(_onFetchFeatured, transformer: droppable());
  }

  Future<void> _onFetchFeatured(
    FeaturedFetched event,
    Emitter<FeaturedState> emit,
  ) async {
    late final Either<ErrorType, GamesResponse> response;

    emit(
      FeaturedState(
        tag: event.tag,
        status: FeaturedStatus.loading,
      ),
    );

    switch (event.tag) {
      case FeaturedTag.newAndTrending:
        response = await _featuredRepository.fetchFeatured(
          ordering: GameOrdering.added,
          dateFrom: DateTime(DateTime.now().year),
          dateTo: DateTime.now().getDateTimeLater(yearsLater: 1),
        );
        break;
      case FeaturedTag.newReleases:
        response = await _featuredRepository.fetchFeatured(
          ordering: GameOrdering.released,
          dateFrom: DateTime.now().getDateTimeBefore(yearsLater: 1),
          dateTo: DateTime.now(),
        );
        break;
      case FeaturedTag.bestOfTheYear:
        response = await _featuredRepository.fetchFeatured(
          ordering: GameOrdering.added,
          dateFrom: DateTime(DateTime.now().year),
          dateTo: DateTime(DateTime.now().year, 12, 31),
        );
        break;
      case FeaturedTag.bestMetacritic:
        response = await _featuredRepository.fetchFeatured(
          ordering: GameOrdering.metacritic,
        );
        break;
      case FeaturedTag.allTimeTop100:
        response = await _featuredRepository.fetchFeatured(
          ordering: GameOrdering.added,
        );
        break;
    }

    response.fold(
      (error) =>
          emit(state.copyWith(status: FeaturedStatus.failed, error: error)),
      (response) => emit(
        state.copyWith(
          status: FeaturedStatus.success,
          response: response,
          games: response.results,
        ),
      ),
    );
  }
}

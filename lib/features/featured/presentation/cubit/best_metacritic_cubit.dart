import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:injectable/injectable.dart';

part 'best_metacritic_state.dart';

@injectable
class BestMetacriticCubit extends Cubit<BestMetacriticState> {
  final _featuredRepository = injection.getIt<FeaturedRepository>();

  BestMetacriticCubit() : super(const BestMetacriticState());

  void fetchBestMetacritic() async {
    emit(state.copyWith(status: BestMetacriticStatus.loading));

    final bestMetacritic = await _featuredRepository.fetchBestMetacritic();

    bestMetacritic.fold(
      (errorType) => emit(
        state.copyWith(status: BestMetacriticStatus.failed, error: errorType),
      ),
      (gamesResponse) {
        if (gamesResponse.results != null &&
            gamesResponse.results!.isNotEmpty) {
          emit(
            state.copyWith(
              status: BestMetacriticStatus.success,
              games: gamesResponse,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: BestMetacriticStatus.empty,
            ),
          );
        }
      },
    );
  }
}

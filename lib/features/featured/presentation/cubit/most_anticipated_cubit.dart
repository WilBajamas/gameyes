import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:injectable/injectable.dart';

part 'most_anticipated_state.dart';

@injectable
class MostAnticipatedCubit extends Cubit<MostAnticipatedState> {
  final _featuredRepository = injection.getIt<FeaturedRepository>();

  MostAnticipatedCubit() : super(const MostAnticipatedState());

  void fetchMostAnticipated() async {
    emit(state.copyWith(status: MostAnticipatedStatus.loading));

    final mostAnticipated = await _featuredRepository.fetchMostAnticipated();

    mostAnticipated.fold(
      (errorType) => emit(
        state.copyWith(status: MostAnticipatedStatus.failed, error: errorType),
      ),
      (gamesResponse) {
        if (gamesResponse.results != null &&
            gamesResponse.results!.isNotEmpty) {
          emit(
            state.copyWith(
              status: MostAnticipatedStatus.success,
              games: gamesResponse,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: MostAnticipatedStatus.empty,
            ),
          );
        }
      },
    );
  }
}

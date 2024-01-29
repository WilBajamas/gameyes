import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:injectable/injectable.dart';

part 'latest_releases_state.dart';

@injectable
class LatestReleasesCubit extends Cubit<LatestReleasesState> {
  final _featuredRepository = injection.getIt<FeaturedRepository>();

  LatestReleasesCubit() : super(const LatestReleasesState());

  void fetchLatestReleases() async {
    emit(state.copyWith(status: LatestReleasesStatus.loading));

    final bestMetacritic = await _featuredRepository.fetchLatestReleases();

    bestMetacritic.fold(
      (errorType) => emit(
        state.copyWith(status: LatestReleasesStatus.failed, error: errorType),
      ),
      (gamesResponse) {
        if (gamesResponse.results != null &&
            gamesResponse.results!.isNotEmpty) {
          emit(
            state.copyWith(
              status: LatestReleasesStatus.success,
              games: gamesResponse,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: LatestReleasesStatus.empty,
            ),
          );
        }
      },
    );
  }
}

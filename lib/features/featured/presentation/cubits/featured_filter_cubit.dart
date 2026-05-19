import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:injectable/injectable.dart';

import 'featured_filter_state.dart';

@injectable
class FeaturedFilterCubit extends Cubit<FeaturedFilterState> {
  FeaturedFilterCubit(
      {@factoryParam required Set<GamePlatform> initialPlatforms})
      : super(const FeaturedFilterState()) {
    emit(state.copyWith(tempPlatformsSelected: initialPlatforms));
  }

  void selectPlatform(GamePlatform platform) {
    final tempSelectionState = Set<GamePlatform>.from(
      state.tempPlatformsSelected,
    );

    if (tempSelectionState.contains(platform)) {
      tempSelectionState.remove(platform);
    } else {
      tempSelectionState.add(platform);
    }

    emit(state.copyWith(tempPlatformsSelected: tempSelectionState));
  }

  void setPlatforms() => emit(
        state.copyWith(
          platformsSelected: state.tempPlatformsSelected,
        ),
      );
}

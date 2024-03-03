import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:injectable/injectable.dart';

part 'featured_filter_state.dart';

@injectable
class FeaturedFilterCubit extends Cubit<FeaturedFilterState> {
  FeaturedFilterCubit() : super(const FeaturedFilterState());

  void selectPlatform(GamePlatfom platform) {
    final currentSelectionState =
        Set<GamePlatfom>.from(state.platformsSelected);

    if (currentSelectionState.contains(platform)) {
      currentSelectionState.remove(platform);
    } else {
      currentSelectionState.add(platform);
    }

    emit(state.copyWith(currentSelectionState));
  }
}

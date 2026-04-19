import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:injectable/injectable.dart';

import 'filter_state.dart';

@injectable
class FilterCubit extends Cubit<FilterState> {
  FilterCubit({@factoryParam required FilterState initialState})
      : super(const FilterState()) {
    emit(initialState);
  }

  void changeSelectionValue({
    Set<GamePlatform>? platforms,
    Set<GameGenre>? genres,
    GameOrdering? ordering,
    String? searchTerm,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? ascending,
  }) {
    emit(
      state.copyWith(
        // ordering: ordering,
        // platforms: platforms,
        // genres: genres,
        searchTerm: searchTerm,
        dateFrom: dateFrom,
        dateTo: dateTo,
        // ascending: ascending,
      ),
    );
  }

  void selectPlatform(GamePlatform platform) {
    final currentSelectionState = Set<GamePlatform>.from(state.platforms);

    if (currentSelectionState.contains(platform)) {
      currentSelectionState.remove(platform);
    } else {
      currentSelectionState.add(platform);
    }

    emit(state.copyWith(platforms: currentSelectionState));
  }

  void selectGenre(GameGenre genre) {
    final currentSelectionState = Set<GameGenre>.from(state.genres);

    if (currentSelectionState.contains(genre)) {
      currentSelectionState.remove(genre);
    } else {
      currentSelectionState.add(genre);
    }

    emit(state.copyWith(genres: currentSelectionState));
  }

  void updateSearchTerm(String searchTerm) =>
      emit(state.copyWith(searchTerm: searchTerm));
}

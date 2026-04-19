import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';

part 'filter_state.freezed.dart';

@freezed
sealed class FilterState with _$FilterState {
  const factory FilterState({
    @Default(GameOrdering.released) GameOrdering ordering,
    @Default(<GamePlatform>{}) Set<GamePlatform> platforms,
    @Default(<GameGenre>{}) Set<GameGenre> genres,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchTerm,
    @Default(false) bool ascending,
  }) = _FilterState;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';

part 'featured_filter_state.freezed.dart';

@freezed
sealed class FeaturedFilterState with _$FeaturedFilterState {
  const factory FeaturedFilterState({
    @Default(<GamePlatform>{}) Set<GamePlatform> platformsSelected,
    @Default(<GamePlatform>{}) Set<GamePlatform> tempPlatformsSelected,
  }) = _FeaturedFilterState;
}

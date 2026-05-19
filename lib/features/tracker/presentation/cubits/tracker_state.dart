import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';

part 'tracker_state.freezed.dart';

@freezed
sealed class TrackerState with _$TrackerState {
  const factory TrackerState({
    @Default(SavedGameFilterTag.recentlyChanged) SavedGameFilterTag tag,
    String? searchTerm,
  }) = _TrackerState;
}

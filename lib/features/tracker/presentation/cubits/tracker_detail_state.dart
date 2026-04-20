import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

part 'tracker_detail_state.freezed.dart';

@freezed
sealed class TrackerDetailState with _$TrackerDetailState {
  const factory TrackerDetailState({SavedGame? game}) = _TrackerDetailState;
}

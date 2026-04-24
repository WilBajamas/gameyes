import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';

part 'tracker_detail_state.freezed.dart';

@freezed
sealed class TrackerDetailState with _$TrackerDetailState {
  const factory TrackerDetailState({TrackerSavedGameEntity? game}) =
      _TrackerDetailState;
}

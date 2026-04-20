import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';

part 'task_state.freezed.dart';

@freezed
sealed class TaskState with _$TaskState {
  const factory TaskState({SavedGameTask? task}) = _TaskState;
  const factory TaskState.removeStepFailed({SavedGameTask? task}) =
      RemoveStepFailed;
  const factory TaskState.removeStepSuccess({SavedGameTask? task}) =
      RemoveStepSuccess;
}

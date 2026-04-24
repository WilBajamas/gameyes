import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart';

part 'task_state.freezed.dart';

@freezed
sealed class TaskState with _$TaskState {
  const factory TaskState({TrackerTaskEntity? task}) = _TaskState;
  const factory TaskState.removeStepFailed({TrackerTaskEntity? task}) =
      RemoveStepFailed;
  const factory TaskState.removeStepSuccess({TrackerTaskEntity? task}) =
      RemoveStepSuccess;
}

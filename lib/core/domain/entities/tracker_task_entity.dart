import 'package:freezed_annotation/freezed_annotation.dart';
import 'tracker_task_step_entity.dart';

part 'tracker_task_entity.freezed.dart';

@freezed
sealed class TrackerTaskEntity with _$TrackerTaskEntity {
  const factory TrackerTaskEntity({
    required int id,
    int? savedGameId,
    int? gameId,
    String? title,
    String? description,
    bool? completed,
    String? timeToComplete,
    bool? pinned,
    @Default(0) int currentStepIndex,
    @Default([]) List<TrackerTaskStepEntity> steps,
    @Default(false) bool setReminder,
  }) = _TrackerTaskEntity;
}

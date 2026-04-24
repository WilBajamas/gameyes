import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracker_task_step_entity.freezed.dart';

@freezed
sealed class TrackerTaskStepEntity with _$TrackerTaskStepEntity {
  const factory TrackerTaskStepEntity({
    required String id,
    int? taskId,
    int? number,
    String? title,
    String? description,
    String? image,
  }) = _TrackerTaskStepEntity;
}

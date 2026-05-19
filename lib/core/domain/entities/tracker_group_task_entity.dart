import 'package:freezed_annotation/freezed_annotation.dart';
import 'tracker_task_entity.dart';

part 'tracker_group_task_entity.freezed.dart';

@freezed
sealed class TrackerGroupTaskEntity with _$TrackerGroupTaskEntity {
  const factory TrackerGroupTaskEntity({
    required int id,
    int? gameId,
    String? title,
    String? description,
    @Default([]) List<TrackerTaskEntity> tasks,
  }) = _TrackerGroupTaskEntity;
}

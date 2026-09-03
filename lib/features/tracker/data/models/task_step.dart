import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_step_entity.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

part 'task_step.g.dart';

@embedded
class TaskStep {
  String id = const Uuid().v4();

  int? taskId;

  int? number;

  String? title;

  String? description;

  String? image;

  TrackerTaskStepEntity toEntity() => TrackerTaskStepEntity(
    id: id,
    taskId: taskId,
    number: number,
    title: title,
    description: description,
    image: image,
  );
}

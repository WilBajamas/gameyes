import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:isar_community/isar.dart';

part 'saved_game_task.g.dart';

@collection
class SavedGameTask {
  Id id = Isar.autoIncrement;

  int? savedGameId;

  int? gameId;

  String? title;

  String? description;

  bool? completed;

  String? timeToComplete;

  bool? pinned;

  int currentStepIndex = 0;

  List<TaskStep>? steps;

  bool setReminder = false;

  @Backlink(to: 'tasks')
  final groupTask = IsarLink<GroupTask>();

  TrackerTaskEntity toEntity() => TrackerTaskEntity(
    id: id,
    savedGameId: savedGameId,
    gameId: gameId,
    title: title,
    description: description,
    completed: completed,
    timeToComplete: timeToComplete,
    pinned: pinned,
    currentStepIndex: currentStepIndex,
    steps: steps?.map((e) => e.toEntity()).toList() ?? [],
    setReminder: setReminder,
  );
}

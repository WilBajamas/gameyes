import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_group_task_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:isar_community/isar.dart';

part 'group_task.g.dart';

@collection
class GroupTask {
  Id id = Isar.autoIncrement;

  int? gameId;

  String? title;

  String? description;

  GroupTask({this.gameId, this.title, this.description});

  final tasks = IsarLinks<SavedGameTask>();

  @Backlink(to: 'groupTasks')
  final savedGame = IsarLink<SavedGame>();

  TrackerGroupTaskEntity toEntity() => TrackerGroupTaskEntity(
    id: id,
    gameId: gameId,
    title: title,
    description: description,
    tasks: tasks.map((e) => e.toEntity()).toList(),
  );
}

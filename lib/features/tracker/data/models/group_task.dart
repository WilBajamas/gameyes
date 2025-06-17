import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:isar/isar.dart';

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
}

import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  int? gameId;

  String? title;

  String? description;

  bool? completed;

  String? timeToComplete;

  bool? pinned;

  int? currentStep;

  @Backlink(to: 'tasks')
  final groupTask = IsarLink<GroupTask>();
}

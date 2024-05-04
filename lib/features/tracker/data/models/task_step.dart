import 'package:isar/isar.dart';

part 'task_step.g.dart';

@embedded
class TaskStep {
  bool isCurrent = false;

  int? number;

  String? title;

  String? description;

  String? image;
}

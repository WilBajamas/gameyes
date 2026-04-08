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
}

import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';

abstract interface class TrackerDetailRepository {
  Future<void> setPlatform({
    required GamePlatform platform,
    required int savedGameId,
  });

  Future<void> createGroupTask({
    required String title,
    required String description,
    required int id,
  });

  Stream<SavedGame?> savedGameDetailStream({required int savedGameId});

  Stream<Task?> taskStream({required int taskId});

  Future<void> removeGroupTask({
    required int savedGameId,
    required int groupTaskId,
  });

  Future<void> createTask({
    required int savedGameId,
    required int groupTaskId,
  });

  Future<void> addStep({
    required int taskId,
    required String title,
    required String description,
    required int stepNumber,
    String? image,
  });

  Future<void> removeStep({
    required int taskId,
    required TaskStep step,
  });
}

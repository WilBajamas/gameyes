import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_step_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';

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

  Stream<SavedGameTask?> taskStream({required int taskId});

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

  Future<bool> removeStep({
    required int taskId,
    required TrackerTaskStepEntity step,
  });

  Future<void> editStep({
    required int taskId,
    required String stepId,
    required String title,
    required String description,
    required int stepNumber,
    String? image,
  });

  Future<void> changeCurrentStep({required int taskId, required int stepIndex});
}

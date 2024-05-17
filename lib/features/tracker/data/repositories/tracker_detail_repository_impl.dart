import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackerDetailRepository)
class TrackerDetailRepositoryImpl implements TrackerDetailRepository {
  final _gameLocalDatasource = getIt<GameLocalDatasource>();

  @override
  Future<void> setPlatform({
    required GamePlatform platform,
    required int savedGameId,
  }) =>
      _gameLocalDatasource.setPlatform(
        platform: platform,
        savedGameId: savedGameId,
      );

  @override
  Future<void> createGroupTask({
    required String title,
    required String description,
    required int id,
  }) =>
      _gameLocalDatasource.createGroupTask(
        title: title,
        description: description,
        id: id,
      );

  @override
  Stream<SavedGame?> savedGameDetailStream({required int savedGameId}) =>
      _gameLocalDatasource.listenToSavedGame(savedGameId: savedGameId);

  @override
  Future<void> removeGroupTask({
    required savedGameId,
    required int groupTaskId,
  }) =>
      _gameLocalDatasource.removeGroupTask(
        savedGameId: savedGameId,
        groupTaskId: groupTaskId,
      );

  @override
  Future<void> createTask({
    required int savedGameId,
    required int groupTaskId,
  }) =>
      _gameLocalDatasource.createTaskInGroup(
        groupTaskId: groupTaskId,
        savedGameId: savedGameId,
      );

  @override
  Future<void> addStep({
    required int taskId,
    required String title,
    required String description,
    required int stepNumber,
    String? image,
  }) {
    final step = TaskStep()
      ..title = title
      ..description = description
      ..image = image
      ..isCurrent = stepNumber == 1
      ..number = stepNumber;

    return _gameLocalDatasource.addStep(
      taskId: taskId,
      step: step,
    );
  }

  @override
  Future<void> removeStep({required int taskId, required TaskStep step}) =>
      _gameLocalDatasource.removeStep(taskId: taskId, step: step);

  @override
  Stream<Task?> taskStream({required int taskId}) =>
      _gameLocalDatasource.listenToTask(taskId: taskId);

  @override
  Future<void> editStep({
    required int taskId,
    required String stepId,
    required String title,
    required String description,
    required int stepNumber,
    String? image,
  }) =>
      _gameLocalDatasource.editStep(
        taskId: taskId,
        stepId: stepId,
        title: title,
        description: description,
        stepNumber: stepNumber,
      );
}

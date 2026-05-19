import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_step_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackerDetailRepository)
class TrackerDetailRepositoryImpl implements TrackerDetailRepository {
  final GameLocalDatasource _gameLocalDatasource;

  TrackerDetailRepositoryImpl(this._gameLocalDatasource);

  @override
  Future<void> setPlatform({
    required PlatformEntity platform,
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
  Stream<TrackerSavedGameEntity?> savedGameDetailStream({
    required int savedGameId,
  }) =>
      _gameLocalDatasource
          .listenToSavedGame(savedGameId: savedGameId)
          .map((model) => model?.toEntity());

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
      ..number = stepNumber;

    return _gameLocalDatasource.addStep(
      taskId: taskId,
      step: step,
    );
  }

  @override
  Future<bool> removeStep({
    required int taskId,
    required TrackerTaskStepEntity step,
  }) async {
    // Mapping entity back to model for the technical layer
    final modelStep = TaskStep()..id = step.id;

    return await _gameLocalDatasource.removeStep(
      taskId: taskId,
      step: modelStep,
    );
  }

  @override
  Stream<TrackerTaskEntity?> taskStream({required int taskId}) =>
      _gameLocalDatasource
          .listenToTask(taskId: taskId)
          .map((model) => model?.toEntity());

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

  @override
  Future<void> changeCurrentStep({
    required int taskId,
    required int stepIndex,
  }) =>
      _gameLocalDatasource.changeCurrentStep(
        taskId: taskId,
        stepIndex: stepIndex,
      );
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

part 'task_state.dart';

@injectable
class TaskCubit extends Cubit<TaskState> {
  final TrackerDetailRepository _trackerDetailRepository;
  StreamSubscription? taskStreamSubscription;

  TaskCubit(
      {@factoryParam required SavedGameTask? task,
      required TrackerDetailRepository trackerDetailRepository})
      : _trackerDetailRepository = trackerDetailRepository,
        super(const TaskState()) {
    if (task case final task?) {
      setTask(task: task);
      listenToTask(taskId: task.id);
    }
  }

  void setTask({required SavedGameTask task}) => emit(TaskState(task: task));

  void listenToTask({required int taskId}) {
    taskStreamSubscription?.cancel();
    final stream = _trackerDetailRepository
        .taskStream(taskId: taskId)
        .listen((task) => emit(TaskState(task: task)));

    taskStreamSubscription = stream;
  }

  void addStep({
    required int taskId,
    required String title,
    required String description,
    required int stepNumber,
    String? image,
  }) async {
    await _trackerDetailRepository.addStep(
      taskId: taskId,
      title: title,
      description: description,
      stepNumber: stepNumber,
      image: image,
    );
  }

  void editStep({
    required int taskId,
    required String stepId,
    required String title,
    required String description,
    required int stepNumber,
    String? image,
  }) =>
      _trackerDetailRepository.editStep(
        taskId: taskId,
        stepId: stepId,
        title: title,
        description: description,
        stepNumber: stepNumber,
      );

  void removeStep({required TaskStep step}) async {
    await _trackerDetailRepository
        .removeStep(
          taskId: state.task!.id,
          step: step,
        )
        .then(
          (removed) => removed
              ? emit(RemoveStepSuccess(existingTask: state.task!))
              : emit(RemoveStepFailed(existingTask: state.task!)),
        );
  }

  void setCurrentStep({required int stepIndex}) => _trackerDetailRepository
      .changeCurrentStep(taskId: state.task!.id, stepIndex: stepIndex);
}

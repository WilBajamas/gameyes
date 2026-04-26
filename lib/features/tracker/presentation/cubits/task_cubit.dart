import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_step_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

import 'task_state.dart';

@injectable
class TaskCubit extends Cubit<TaskState> {
  final TrackerDetailRepository _trackerDetailRepository;
  StreamSubscription? taskStreamSubscription;

  TaskCubit(
      {@factoryParam required TrackerTaskEntity? task,
      required TrackerDetailRepository trackerDetailRepository,})
      : _trackerDetailRepository = trackerDetailRepository,
        super(const TaskState()) {
    if (task case final task?) {
      setTask(task: task);
      listenToTask(taskId: task.id);
    }
  }

  void setTask({required TrackerTaskEntity task}) =>
      emit(TaskState(task: task));

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
        image: image,
      );

  void removeStep({required TrackerTaskStepEntity step}) async {
    await _trackerDetailRepository
        .removeStep(
          taskId: state.task!.id,
          step: step,
        )
        .then(
          (removed) => removed
              ? emit(TaskState.removeStepSuccess(task: state.task!))
              : emit(TaskState.removeStepFailed(task: state.task!)),
        );
  }

  void setCurrentStep({required int stepIndex}) => _trackerDetailRepository
      .changeCurrentStep(taskId: state.task!.id, stepIndex: stepIndex);
}

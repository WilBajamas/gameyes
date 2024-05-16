import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

part 'task_state.dart';

@injectable
class TaskCubit extends Cubit<TaskState> {
  final _trackerDetailRepository = getIt<TrackerDetailRepository>();
  StreamSubscription? taskStreamSubscription;

  TaskCubit() : super(const TaskState());

  void setTask({required Task task}) => emit(TaskState(task: task));

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

  void removeStep({required int taskId, required TaskStep step}) async =>
      await _trackerDetailRepository.removeStep(taskId: taskId, step: step);
}

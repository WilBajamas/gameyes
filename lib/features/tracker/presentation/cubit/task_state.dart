part of 'task_cubit.dart';

class TaskState extends Equatable {
  final SavedGameTask? task;

  const TaskState({this.task});

  @override
  List<Object?> get props => [task];
}

class RemoveStepFailed extends TaskState {
  final SavedGameTask existingTask;

  const RemoveStepFailed({required this.existingTask})
      : super(task: existingTask);
}

class RemoveStepSuccess extends TaskState {
  final SavedGameTask existingTask;

  const RemoveStepSuccess({required this.existingTask})
      : super(task: existingTask);
}

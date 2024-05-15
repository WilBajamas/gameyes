part of 'task_cubit.dart';

class TaskState extends Equatable {
  final Task? task;

  const TaskState({this.task});

  @override
  List<Object?> get props => [task];
}

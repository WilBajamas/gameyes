import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_pop_up_button.dart';
import 'package:gaming_library_assessment_flutter/widgets/horizontal_separator.dart';
import 'package:gaming_library_assessment_flutter/widgets/task_item.dart';

class GroupTaskItem extends StatelessWidget {
  final GroupTask groupTask;

  const GroupTaskItem({required this.groupTask, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleAndCheckbox(
              groupTask: groupTask,
            ),
            const SizedBox(height: 4),
            Text(
              groupTask.description ?? '-',
              style: context.themeData.textTheme.bodySmall,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            if (groupTask.tasks.isNotEmpty) const HorizontalSeparator(),
            if (groupTask.tasks.isNotEmpty) const SizedBox(height: 12),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: groupTask.tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskItem(
                    task: groupTask.tasks.toList()[index],
                    groupTaskTitle: groupTask.title,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleAndCheckbox extends StatelessWidget {
  final GroupTask groupTask;

  const _TitleAndCheckbox({required this.groupTask});

  String _getTaskCompletion() {
    final tasks = groupTask.tasks.toList();
    final tasksCompleted = tasks.where((t) => t.completed == true);

    if (tasks.isNotEmpty) {
      return '$tasksCompleted/$tasksCompleted';
    }

    return '-/-';
  }

  void _onPopUpItemClicked(BuildContext context, String selection) {
    if (selection == context.localisations.add_task) {}

    if (selection == context.localisations.remove) {
      context
          .read<TrackerDetailCubit>()
          .removeGroupTask(groupTaskId: groupTask.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            groupTask.title ?? '-',
            style: context.themeData.textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          _getTaskCompletion(),
          style: context.themeData.textTheme.titleMedium,
        ),
        const SizedBox(
          width: 8,
        ),
        // ignore: lines_longer_than_80_chars
        DefaultPopUpButton(
          items: [
            context.localisations.add_task,
            context.localisations.remove,
          ],
          onItemClicked: (String selection) =>
              _onPopUpItemClicked(context, selection),
        ),
      ],
    );
  }
}

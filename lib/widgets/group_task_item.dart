import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_pop_up_button.dart';
import 'package:gaming_library_assessment_flutter/widgets/horizontal_separator.dart';
import 'package:gaming_library_assessment_flutter/widgets/task_item.dart';

class GroupTaskItem extends StatelessWidget {
  final GroupTask groupTask;

  const GroupTaskItem({required this.groupTask, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleAndCheckbox(
              groupTaskTitle: groupTask.title ?? '-',
            ),
            const SizedBox(height: 4),
            Text(
              groupTask.description ?? '-',
              style: context.themeData.textTheme.bodySmall,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            const HorizontalSeparator(),
            const SizedBox(height: 12),
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
  final String groupTaskTitle;

  const _TitleAndCheckbox({required this.groupTaskTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            groupTaskTitle,
            style: context.themeData.textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          '3/3',
          style: context.themeData.textTheme.titleMedium,
        ),
        const SizedBox(
          width: 8,
        ),
        DefaultPopUpButton(
          items: [
            context.localisations.add_task,
            context.localisations.remove,
          ],
          onItemClicked: (String s) {},
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:go_router/go_router.dart';

class TaskItem extends StatelessWidget {
  final bool showGroupTask;
  final Task task;
  final String? groupTaskTitle;

  const TaskItem({
    required this.task,
    this.groupTaskTitle = '-',
    this.showGroupTask = false,
    super.key,
  });

  (String, String) taskStep(List<TaskStep> steps) {
    final int stepNumber = steps.indexWhere((s) => s.isCurrent == true) + 1;
    final String? stepTitle = steps.firstWhere((s) => s.isCurrent).title;

    return (stepNumber.toString(), stepTitle ?? '-');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () => context.pushNamed(RouteConstants.taskDetail),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.themeData.colorScheme.background,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '-',
                      // task.title ?? '-',
                      style: context.themeData.textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Checkbox(
                    value: true,
                    onChanged: (isChecked) {},
                    shape: const CircleBorder(),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kColorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        // taskStep(task.steps!).$1,
                        style: context.themeData.textTheme.bodySmall!
                            .copyWith(color: kColorScheme.background),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'task step',
                    // taskStep(task.steps!).$2,
                    style: context.themeData.textTheme.bodySmall,
                  ),
                ],
              ),
              if (showGroupTask) const SizedBox(height: 8),
              if (showGroupTask && groupTaskTitle != null)
                Text(
                  groupTaskTitle!,
                  style: context.themeData.textTheme.labelSmall!
                      .copyWith(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

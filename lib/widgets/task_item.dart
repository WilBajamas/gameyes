import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:go_router/go_router.dart';

class TaskItem extends StatelessWidget {
  final bool showGroupTask;
  final SavedGameTask task;
  final String? groupTaskTitle;

  const TaskItem({
    required this.task,
    this.groupTaskTitle = '-',
    this.showGroupTask = false,
    super.key,
  });

  (String, String)? taskStep() {
    final steps = task.steps;
    final currentStepNumber = task.currentStepIndex;
    if (steps != null && steps.isNotEmpty) {
      final String? stepTitle = steps[currentStepNumber].title;
      return ((currentStepNumber + 1).toString(), stepTitle ?? '-');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () => context.pushNamed(
        RouteConstants.taskDetail,
        extra: (task.id, task),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.themeData.colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _TaskContent(task: task),
              if (taskStep() case final step?) _StepsRow(step: step),
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

class _TaskContent extends StatelessWidget {
  const _TaskContent({
    required this.task,
  });

  final SavedGameTask task;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            task.title ?? '-',
            style: context.themeData.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Transform.scale(
          scale: 1.15,
          child: Checkbox(
            value: true,
            onChanged: (isChecked) {},
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }
}

class _StepsRow extends StatelessWidget {
  const _StepsRow({
    required this.step,
  });

  final (String, String) step;

  @override
  Widget build(BuildContext context) {
    final (number, title) = step;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kColorScheme.primary,
          ),
          child: Center(
            child: Text(
              number,
              style: context.themeData.textTheme.bodySmall!
                  .copyWith(color: kColorScheme.background),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: context.themeData.textTheme.bodySmall,
        ),
      ],
    );
  }
}

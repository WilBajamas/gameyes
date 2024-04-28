import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:go_router/go_router.dart';

class TaskItem extends StatelessWidget {
  final bool showGroupTask;

  const TaskItem({this.showGroupTask = false, super.key});

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
                      'Task',
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
              if (showGroupTask) const SizedBox(height: 8),
              if (showGroupTask)
                Text(
                  'Task Group',
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

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Task',
            style: context.themeData.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Task Group',
            style: context.themeData.textTheme.labelSmall!
                .copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

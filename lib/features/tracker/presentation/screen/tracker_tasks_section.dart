import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/group_task_item.dart';

class TrackerTasksSection extends StatelessWidget {
  const TrackerTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const GroupTaskItem(
          groupTaskTitle: 'Game builds',
        );
      },
    );
  }
}

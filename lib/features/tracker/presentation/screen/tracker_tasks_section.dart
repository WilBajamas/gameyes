import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/group_task_dialog.dart';
import 'package:gaming_library_assessment_flutter/widgets/group_task_item.dart';

class TrackerTasksSection extends StatelessWidget {
  const TrackerTasksSection({super.key});

  // Add extra item if list size is not at maximum (10)
  final int listSize = 4;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      itemCount: listSize,
      itemBuilder: (context, index) {
        if (index == listSize - 1 && index != 9) {
          return const _TrackerAddGroupButton();
        } else if (index == 9) {
          return null;
        } else {
          return const GroupTaskItem(
            groupTaskTitle: 'Game builds',
          );
        }
      },
    );
  }
}

class _TrackerAddGroupButton extends StatefulWidget {
  const _TrackerAddGroupButton();

  @override
  State<_TrackerAddGroupButton> createState() => _TrackerAddGroupButtonState();
}

class _TrackerAddGroupButtonState extends State<_TrackerAddGroupButton> {
  void showAddGroupTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const GroupTaskDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: OutlinedButton(
        onPressed: () => showAddGroupTaskDialog(context),
        child: Text(context.localisations.add_group_task),
      ),
    );
  }
}

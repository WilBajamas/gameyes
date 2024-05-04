import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/group_task_dialog.dart';
import 'package:gaming_library_assessment_flutter/widgets/group_task_item.dart';

class TrackerTasksSection extends StatelessWidget {
  const TrackerTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackerDetailCubit, TrackerDetailState>(
      builder: (context, state) {
        final groups = state.game!.groupTasks.toList();
        final int listSize = groups.length + 1;

        return Column(
          children: [
            if (groups.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  context.localisations.no_group_task_created,
                  style: context.themeData.textTheme.bodySmall,
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                itemCount: listSize,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == listSize - 1 && index != 9) {
                    return const _TrackerAddGroupButton();
                  } else if (index == 9) {
                    return null;
                  } else {
                    return GroupTaskItem(
                      groupTask: groups[index],
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrackerAddGroupButton extends StatelessWidget {
  const _TrackerAddGroupButton();

  void showAddGroupTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GroupTaskDialog(
        onCreatedClicked: (title, description) => context
            .read<TrackerDetailCubit>()
            .addGroupTask(title: title, description: description),
      ),
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

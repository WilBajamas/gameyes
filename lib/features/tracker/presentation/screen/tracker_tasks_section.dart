import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_outlined_button.dart';
import 'package:gaming_library_assessment_flutter/widgets/add_content_dialog.dart';
import 'package:gaming_library_assessment_flutter/widgets/group_task_item.dart';

import '../../../../generated/l10n.dart';

class TrackerTasksSection extends StatelessWidget {
  const TrackerTasksSection({super.key});

  void showAddGroupTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddContentDialog(
        dialogTitleAndSnackBarTitle: (
          S.current.add_group_task,
          S.current.group_task_created
        ),
        onCreatedClicked: (title, description) => context
            .read<TrackerDetailCubit>()
            .addGroupTask(title: title, description: description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackerDetailCubit, TrackerDetailState>(
      builder: (context, state) {
        final groups = state.game!.groupTasks.toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            children: [
              const _GroupTaskLimitWarning(),
              if (groups.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    S.current.no_group_task_created,
                    style: context.themeData.textTheme.bodySmall,
                  ),
                ),
              ...groups.map(
                (group) => GroupTaskItem(
                  groupTask: group,
                ),
              ),
              if (groups.isEmpty || groups.length < 10)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 14),
                  child: DefaultOutlinedButton(
                    onPressed: () => showAddGroupTaskDialog(context),
                    text: S.current.add_group_task,
                    icon: Icons.add,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _GroupTaskLimitWarning extends StatelessWidget {
  const _GroupTaskLimitWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kColorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: kColorScheme.primary,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              S.current.only_10_group_tasks_allowed,
              style: context.themeData.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

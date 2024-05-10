import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
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

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
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
                        context.localisations.only_10_group_tasks_allowed,
                        style: context.themeData.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
              if (groups.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    context.localisations.no_group_task_created,
                    style: context.themeData.textTheme.bodySmall,
                  ),
                ),
              ...groups.map(
                (group) => GroupTaskItem(
                  groupTask: group,
                ),
              ),
              if (groups.isEmpty || groups.length < 10)
                const Padding(
                  padding: EdgeInsets.only(bottom: 14),
                  child: _TrackerAddGroupButton(),
                ),
            ],
          ),
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
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => showAddGroupTaskDialog(context),
          child: Text(context.localisations.add_group_task),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_detail_state.dart';
import 'package:gaming_library_assessment_flutter/widgets/task_item.dart';

import '../../../../generated/l10n.dart';

class TrackerGameDetailSection extends StatelessWidget {
  const TrackerGameDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shrinkWrap: true,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BlocBuilder<TrackerDetailCubit, TrackerDetailState>(
            builder: (context, state) {
              return _PlatformSelector(game: state.game!);
            },
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _TasksPinned(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PlatformSelector extends StatelessWidget {
  final TrackerSavedGameEntity game;
  const _PlatformSelector({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  // ignore: lines_longer_than_80_chars
                  '${S.current.platforms} (${S.current.select_platforms})',
                  style: context.themeData.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.topLeft,
              child:
                  BlocSelector<
                    TrackerDetailCubit,
                    TrackerDetailState,
                    TrackerSavedGameEntity?
                  >(
                    selector: (state) => state.game,
                    builder: (context, state) {
                      return Wrap(
                        spacing: 8,
                        children: (state?.availablePlatforms ?? []).map((
                          platform,
                        ) {
                          final selected =
                              state?.platforms?.any(
                                (p) => p.id == platform.id,
                              ) ??
                              false;
                          return ChoiceChip(
                            label: platform.platformLogo?.url != null
                                ? Image.network(
                                    platform.platformLogo!.url!,
                                    height: 20,
                                    color: selected
                                        ? kColorScheme.surface
                                        : kColorScheme.onSurface,
                                    errorBuilder:
                                        (context, error, stackTrace) => Text(
                                          platform.abbreviation.isNotEmpty
                                              ? platform.abbreviation
                                              : platform.name,
                                          style: TextStyle(
                                            color: selected
                                                ? kColorScheme.surface
                                                : kColorScheme.onSurface,
                                          ),
                                        ),
                                  )
                                : Text(
                                    platform.abbreviation.isNotEmpty
                                        ? platform.abbreviation
                                        : platform.name,
                                    style: TextStyle(
                                      color: selected
                                          ? kColorScheme.surface
                                          : kColorScheme.onSurface,
                                    ),
                                  ),
                            side: const BorderSide(color: Colors.transparent),
                            selected: selected,
                            showCheckmark: false,
                            onSelected: (selected) => context
                                .read<TrackerDetailCubit>()
                                .setPlatform(platform: platform),
                          );
                        }).toList(),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasksPinned extends StatelessWidget {
  const _TasksPinned();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: BlocBuilder<TrackerDetailCubit, TrackerDetailState>(
          builder: (context, state) {
            final tasks = context.read<TrackerDetailCubit>().getPinnedTasks();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.tasks_pinned,
                  style: context.themeData.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (tasks.isEmpty)
                  Text(
                    S.current.no_pinned_tasks_desc,
                    style: context.themeData.textTheme.bodySmall,
                  ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskItem(task: tasks[index], showGroupTask: true),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/legend_indicator.dart';
import 'package:gaming_library_assessment_flutter/widgets/task_item.dart';

class TrackerGameDetailSection extends StatelessWidget {
  const TrackerGameDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shrinkWrap: true,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _TaskCompletionProgress(),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _PlatformSelector(),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _TasksInProgress(),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class _TaskCompletionProgress extends StatelessWidget {
  const _TaskCompletionProgress();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.3,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localisations.task_statuses,
                style: context.themeData.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          centerSpaceRadius: double.infinity,
                          sections: [
                            PieChartSectionData(value: 25, color: Colors.blue),
                            PieChartSectionData(
                              value: 25,
                              color: Colors.yellow,
                            ),
                            PieChartSectionData(
                              value: 25,
                              color: Colors.orange,
                            ),
                            PieChartSectionData(value: 25, color: Colors.green),
                            PieChartSectionData(
                              value: 25,
                              color: Colors.blueGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LegendIndicator(
                          color: Colors.blue,
                          text: context.localisations.done,
                        ),
                        LegendIndicator(
                          color: Colors.yellow,
                          text: context.localisations.inProgress,
                        ),
                        LegendIndicator(
                          color: Colors.orange,
                          text: context.localisations.missed,
                        ),
                        LegendIndicator(
                          color: Colors.green,
                          text: context.localisations.rageQuit,
                        ),
                        LegendIndicator(
                          color: Colors.blueGrey,
                          text: context.localisations.improve,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformSelector extends StatelessWidget {
  const _PlatformSelector();

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
                  '${context.localisations.platforms} (${context.localisations.select_platforms})',
                  style: context.themeData.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 8,
                children: GamePlatform.values
                    .map(
                      (e) => ChoiceChip.elevated(
                        label: Image.asset(
                          'assets/images/${e.assetName}',
                          height: 20,
                        ),
                        side: const BorderSide(color: Colors.transparent),
                        selected: false,
                        showCheckmark: false,
                        disabledColor: Colors.white,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasksInProgress extends StatelessWidget {
  const _TasksInProgress();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localisations.tasks_in_progress,
              style: context.themeData.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: TaskItem(
                    showGroupTask: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

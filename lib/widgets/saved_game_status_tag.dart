import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

enum Status {
  completed(Colors.green),
  onHold(Colors.deepOrange),
  toBuy(Colors.blue),
  notStarted(Colors.blueAccent),
  ragedQuit(Colors.red),
  inProgress(Colors.yellow);

  final Color color;

  const Status(this.color);
}

class SavedGameStatusTag extends StatelessWidget {
  final Status status;
  const SavedGameStatusTag({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    String tagTitle() => switch (status) {
          Status.completed => context.localisations.completed,
          Status.onHold => context.localisations.onHold,
          Status.toBuy => context.localisations.toBuy,
          Status.ragedQuit => context.localisations.rageQuit,
          Status.inProgress => context.localisations.inProgress,
          Status.notStarted => context.localisations.not_started,
        };

    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: status.color,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Center(
        child: AutoSizeText(tagTitle()),
      ),
    );
  }
}

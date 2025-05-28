import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

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
          Status.completed => S.current.completed,
          Status.onHold => S.current.onHold,
          Status.toBuy => S.current.toBuy,
          Status.ragedQuit => S.current.rageQuit,
          Status.inProgress => S.current.inProgress,
          Status.notStarted => S.current.not_started,
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

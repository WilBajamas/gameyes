import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

import '../generated/l10n.dart';

class DefaultAlertDialog extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;

  const DefaultAlertDialog({
    super.key,
    required this.title,
    this.description,
    this.onPositivePressed,
    this.onNegativePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: description != null
          ? Text(description!, style: context.themeData.textTheme.bodySmall)
          : null,
      actions: [
        TextButton(
          child: Text(S.current.ok),
          onPressed: () {
            if (onPositivePressed case final pressed?) pressed();
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(S.current.cancel),
          onPressed: () {
            if (onNegativePressed case final pressed?) pressed();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

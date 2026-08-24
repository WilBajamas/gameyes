import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/primary_button.dart';

class DestructiveActionPair extends StatelessWidget {
  const DestructiveActionPair({
    super.key,
    required this.destructiveLabel,
    required this.safeLabel,
    required this.onDestructive,
    required this.onSafe,
  });

  final String destructiveLabel;
  final String safeLabel;
  final VoidCallback onDestructive;
  final VoidCallback onSafe;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;

    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: PrimaryButton(
            label: safeLabel,
            onPressed: onSafe,
            backgroundColor: colors.ink08,
            labelColor: colors.ink,
          ),
        ),
        Expanded(
          child: PrimaryButton(
            label: destructiveLabel,
            onPressed: onDestructive,
            backgroundColor: colors.errorStrong,
            labelColor: colors.ink,
          ),
        ),
      ],
    );
  }
}

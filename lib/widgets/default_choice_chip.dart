import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class DefaultChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function() onSelected;

  const DefaultChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        color: isSelected
            ? context.themeData.colorScheme.background
            : context.themeData.colorScheme.primary,
      ),
    );
  }
}

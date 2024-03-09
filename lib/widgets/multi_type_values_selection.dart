import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/interface/selection.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_choice_chip.dart';

class MultiTypeValuesSelection<T extends EnumSelection>
    extends StatelessWidget {
  final Set<T> selectedItems;
  final Set<T> selections;
  final Function(T) onSelect;
  final String title;

  const MultiTypeValuesSelection({
    super.key,
    required this.selectedItems,
    required this.title,
    required this.onSelect,
    required this.selections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.themeData.textTheme.displaySmall,
        ),
        const SizedBox(height: 2),
        Wrap(
          spacing: 4,
          children: selections.map(
            (type) {
              return DefaultChoiceChip(
                label: type.valueName,
                isSelected: selectedItems.contains(type),
                onSelected: () => onSelect(type),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

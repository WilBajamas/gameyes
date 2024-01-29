import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_choice_chip.dart';

class TypeValuesSelection<T> extends StatelessWidget {
  const TypeValuesSelection({
    required this.title,
    required this.typeSelection,
    required this.typeList,
    required this.onTypeSelected,
    Key? key,
  }) : super(key: key);

  final T? typeSelection;
  final List<T> typeList;
  final String title;

  final Function(T type) onTypeSelected;

  String getTypeNames(T type) {
    if (type is GamesPlatform) {
      return type.name; // Access properties of GamesPlatform
    } else if (type is GameOrdering) {
      return type.name.toUpperCase(); // Handle other types differently
    } else {
      return type.toString();
    }
  }

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
          direction: Axis.horizontal,
          spacing: 5,
          children: typeList.map(
            (type) {
              return DefaultChoiceChip(
                label: getTypeNames(type),
                isSelected: this.typeSelection == type,
                onSelected: () => onTypeSelected(type),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class GameDetailSectionPoint extends StatelessWidget {
  final String title;
  final String? value;

  const GameDetailSectionPoint({
    Key? key,
    required this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.themeData.textTheme.bodyMedium!,
        ),
        Text(
          value ?? '-',
          style: context.themeData.textTheme.bodyLarge,
        ),
      ],
    );
  }
}

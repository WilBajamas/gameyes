import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class CustomNavigationDestination extends StatelessWidget {
  final IconData iconData;
  final String label;

  const CustomNavigationDestination({
    super.key,
    required this.iconData,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(iconData, color: context.themeData.colorScheme.primary),
      selectedIcon: Icon(
        iconData,
        color: Colors.grey[100],
      ),
      label: label,
    );
  }
}

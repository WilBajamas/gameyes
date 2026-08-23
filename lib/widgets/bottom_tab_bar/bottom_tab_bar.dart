import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar_cell.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Material(
      color: tokens.color.surfaceTabChrome,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        minimum: const EdgeInsets.only(bottom: 22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
          child: Row(
            children: [
              for (final destination in BottomTabBarDestination.values)
                Expanded(
                  child: BottomTabBarCell(
                    destination: destination,
                    selected: destination.index == selectedIndex,
                    onPressed: () => onDestinationSelected(destination.index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

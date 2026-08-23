import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar_cap.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart';

class BottomTabBarCellContent extends StatelessWidget {
  const BottomTabBarCellContent({
    super.key,
    required this.destination,
    required this.selected,
  });

  final BottomTabBarDestination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final tabLabel = tokens.typography.tabLabel;

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        end: selected ? tokens.color.accentIndigo : tokens.color.ink55,
      ),
      duration: tokens.motion.resolve(context, tokens.motion.stateChange),
      curve: tokens.motion.standard,
      builder: (context, color, _) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          BottomTabBarCap(selected: selected),
          Icon(destination.icon, size: 20, color: color),
          Text(
            tabLabel.format(destination.label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tabLabel.style.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

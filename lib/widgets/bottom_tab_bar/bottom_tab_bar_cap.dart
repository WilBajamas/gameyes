import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class BottomTabBarCap extends StatelessWidget {
  const BottomTabBarCap({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AnimatedContainer(
      width: 18,
      height: 3,
      duration: tokens.motion.resolve(context, tokens.motion.stateChange),
      curve: tokens.motion.standard,
      decoration: BoxDecoration(
        color: selected ? tokens.color.accentIndigo : Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radius.full),
      ),
    );
  }
}

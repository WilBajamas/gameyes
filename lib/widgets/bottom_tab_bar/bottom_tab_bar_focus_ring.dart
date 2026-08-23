import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class BottomTabBarFocusRing extends StatelessWidget {
  const BottomTabBarFocusRing({
    super.key,
    required this.focused,
    required this.child,
  });

  final bool focused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: focused ? tokens.color.green : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(tokens.radius.sm),
      ),
      child: child,
    );
  }
}

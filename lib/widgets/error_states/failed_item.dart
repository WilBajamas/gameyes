import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_dot.dart';

class FailedItem extends StatelessWidget {
  const FailedItem({
    super.key,
    required this.semanticsLabel,
    required this.child,
  });

  final String semanticsLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Stack(
      children: [
        DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            border: Border.all(color: tokens.color.errorLine),
            borderRadius: BorderRadius.circular(tokens.radius.lg),
          ),
          child: Opacity(opacity: 0.55, child: child),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Semantics(
            container: true,
            label: semanticsLabel,
            child: const ErrorDot(size: 20, glyph: Icons.priority_high),
          ),
        ),
      ],
    );
  }
}

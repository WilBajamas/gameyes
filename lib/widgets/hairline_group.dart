import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class HairlineGroup extends StatelessWidget {
  const HairlineGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final tokens = context.tokens;

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.lg),
      child: ColoredBox(
        color: tokens.color.surfaceRaised,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0)
                Divider(height: 1, thickness: 1, color: tokens.color.hairline),
              children[index],
            ],
          ],
        ),
      ),
    );
  }
}

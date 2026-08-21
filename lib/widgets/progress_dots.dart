import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ProgressDots extends StatelessWidget {
  const ProgressDots({
    super.key,
    required this.count,
    required this.activeIndex,
  }) : assert(count >= 1, 'A progress row needs at least one dot.'),
       assert(
         activeIndex >= 0 && activeIndex < count,
         'The active dot must be one of the dots being drawn.',
       );

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: List.generate(
        count,
        (index) => _Dot(active: index == activeIndex),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: active ? 22 : 5,
      height: 5,
      decoration: BoxDecoration(
        color: active ? tokens.color.ink : tokens.color.ink12,
        borderRadius: BorderRadius.circular(tokens.radius.pill),
      ),
    );
  }
}

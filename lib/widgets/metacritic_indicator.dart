import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class MetacriticIndicator extends StatelessWidget {
  final int? score;
  final double size;

  const MetacriticIndicator({Key? key, this.score, this.size = 40})
      : super(key: key);

  Color _criticColor() {
    if (score! <= 33) {
      return Colors.red;
    } else if (score! <= 66) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        score != null ? _criticColor() : context.themeData.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        shape: BoxShape.circle,
        color: context.themeData.scaffoldBackgroundColor,
      ),
      height: size,
      width: size,
      child: Center(
        child: Text(
          score != null ? score.toString() : StringConstants.na,
          style: context.themeData.textTheme.titleMedium,
        ),
      ),
    );
  }
}

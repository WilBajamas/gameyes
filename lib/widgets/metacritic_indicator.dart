import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class MetacriticIndicator extends StatelessWidget {
  final int? score;

  const MetacriticIndicator({Key? key, this.score}) : super(key: key);

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
        color: Colors.white,
      ),
      height: 40,
      width: 40,
      child: Center(
        child: Text(
          score != null ? score.toString() : StringConstants.na,
          style: context.themeData.textTheme.titleMedium,
        ),
      ),
    );
  }
}

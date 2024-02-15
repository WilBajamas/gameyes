import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class HorizontalSeparator extends StatelessWidget {
  const HorizontalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: context.screenWidth,
      height: 1,
    );
  }
}

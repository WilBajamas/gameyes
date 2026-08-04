import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class LogoPlaceholder extends StatelessWidget {
  const LogoPlaceholder({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.ink12,
          border: Border.all(color: tokens.color.ink24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text('LOGO', style: tokens.typography.microLabel.style),
        ),
      ),
    );
  }
}

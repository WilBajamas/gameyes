import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/button_press_scale.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.labelColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ButtonPressScale(
      onPressed: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? tokens.color.green,
          borderRadius: BorderRadius.circular(tokens.radius.sm),
        ),
        child: Text(
          label,
          style: tokens.typography.meta.style.copyWith(
            color: labelColor ?? tokens.color.inkDark,
          ),
        ),
      ),
    );
  }
}

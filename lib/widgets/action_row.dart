import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/button_press_scale.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({
    super.key,
    required this.label,
    required this.markAsset,
    required this.fill,
    required this.enabled,
    required this.loading,
    required this.loadingLabel,
    required this.onPressed,
  });

  final String label;
  final String markAsset;
  final Color fill;
  final bool enabled;
  final bool loading;
  final String loadingLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      enabled: enabled,
      child: IgnorePointer(
        ignoring: !enabled,
        child: ButtonPressScale(
          onPressed: onPressed,
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(tokens.radius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    markAsset,
                    width: 20,
                    height: 20,
                    semanticLabel: label,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      label,
                      style: tokens.typography.body.style.copyWith(
                        color: tokens.color.ink70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (loading) ...[
                    const SizedBox(width: 10),
                    SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: loadingLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

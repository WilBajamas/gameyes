import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ButtonPressScale extends StatefulWidget {
  const ButtonPressScale({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  State<ButtonPressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<ButtonPressScale> {
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return FocusableActionDetector(
      onShowFocusHighlight: (focused) => setState(() => _focused = focused),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: tokens.motion.resolve(context, tokens.motion.stateChange),
          curve: tokens.motion.screenTransitionCurve,
          child: Container(
            decoration: _focused
                ? BoxDecoration(
                    border: Border.all(color: tokens.color.green, width: 2),
                    borderRadius: BorderRadius.circular(tokens.radius.sm),
                  )
                : null,
            padding: _focused ? const EdgeInsets.all(2) : null,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

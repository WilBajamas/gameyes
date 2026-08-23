import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar_cell_content.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar_focus_ring.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart';

class BottomTabBarCell extends StatefulWidget {
  const BottomTabBarCell({
    super.key,
    required this.destination,
    required this.selected,
    required this.onPressed,
  });

  final BottomTabBarDestination destination;
  final bool selected;
  final VoidCallback onPressed;

  @override
  State<BottomTabBarCell> createState() => _BottomTabBarCellState();
}

class _BottomTabBarCellState extends State<BottomTabBarCell> {
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return MergeSemantics(
      child: Semantics(
        selected: widget.selected,
        label: MaterialLocalizations.of(context).tabLabel(
          tabIndex: widget.destination.index + 1,
          tabCount: BottomTabBarDestination.values.length,
        ),
        child: Tooltip(
          message: widget.destination.label,
          excludeFromSemantics: true,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
            onFocusChange: (focused) => setState(() => _focused = focused),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: AnimatedScale(
                scale: _pressed ? 0.97 : 1,
                duration: tokens.motion.resolve(
                  context,
                  tokens.motion.stateChange,
                ),
                curve: tokens.motion.standard,
                child: BottomTabBarFocusRing(
                  focused: _focused,
                  child: BottomTabBarCellContent(
                    destination: widget.destination,
                    selected: widget.selected,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

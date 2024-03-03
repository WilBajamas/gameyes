import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';

class ScrolledNavigationBar extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ScrolledNavigationBar({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State createState() => _ScrolledNavigationBarState();
}

class _ScrolledNavigationBarState extends State<ScrolledNavigationBar> {
  bool _isVisible = true;
  final _scrollChangeNotifier = getIt.get<ScrollNotifier>();

  @override
  void initState() {
    super.initState();
    _scrollChangeNotifier.addListener(_listen);
  }

  void _listen() {
    final scrollingForward = _scrollChangeNotifier.scrolledForward;

    if (scrollingForward && !_isVisible) {
      setState(() => _isVisible = true);
    } else if (!scrollingForward && _isVisible) {
      setState(() => _isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: widget.duration,
        height:
            _isVisible ? 80 + context.bottomPadding : 0,
        child: Wrap(children: [widget.child]),
      );
}

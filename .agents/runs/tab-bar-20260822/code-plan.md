# Code Plan
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.4 — Tab bar; `system-foundation-specs.md` §3.2 "Tab bar" row; `home-screen-design-conventions.md` §6
Date: 2026-08-22

## CREATE NEW

### lib/widgets/bottom_tab_bar.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

import '../generated/l10n.dart';

enum _TabDestination {
  featured(Icons.featured_play_list_outlined),
  games(Icons.gamepad_outlined),
  tracker(Icons.format_list_numbered_rtl),
  browse(Icons.search_outlined),
  settings(Icons.settings_outlined);

  const _TabDestination(this.icon);

  final IconData icon;

  String get label => switch (this) {
    _TabDestination.featured => S.current.featured,
    _TabDestination.games => S.current.games,
    _TabDestination.tracker => S.current.tracker,
    _TabDestination.browse => S.current.browse,
    _TabDestination.settings => S.current.settings,
  };
}

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Material(
      color: tokens.color.surfaceTabChrome,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        minimum: const EdgeInsets.only(bottom: 22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
          child: Row(
            children: [
              for (final destination in _TabDestination.values)
                Expanded(
                  child: _TabDestinationCell(
                    destination: destination,
                    selected: destination.index == selectedIndex,
                    onPressed: () => onDestinationSelected(destination.index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabDestinationCell extends StatefulWidget {
  const _TabDestinationCell({
    required this.destination,
    required this.selected,
    required this.onPressed,
  });

  final _TabDestination destination;
  final bool selected;
  final VoidCallback onPressed;

  @override
  State<_TabDestinationCell> createState() => _TabDestinationCellState();
}

class _TabDestinationCellState extends State<_TabDestinationCell> {
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final tabLabel = tokens.typography.tabLabel;
    final label = widget.destination.label;
    final duration = tokens.motion.resolve(context, tokens.motion.stateChange);
    final contentColor = widget.selected ? colors.accentIndigo : colors.ink55;

    return MergeSemantics(
      child: Semantics(
        selected: widget.selected,
        label: MaterialLocalizations.of(context).tabLabel(
          tabIndex: widget.destination.index + 1,
          tabCount: _TabDestination.values.length,
        ),
        child: Tooltip(
          message: label,
          excludeFromSemantics: true,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (pressed) =>
                setState(() => _pressed = pressed),
            onFocusChange: (focused) => setState(() => _focused = focused),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: AnimatedScale(
                scale: _pressed ? 0.97 : 1,
                duration: duration,
                curve: tokens.motion.standard,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _focused ? colors.green : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(tokens.radius.sm),
                  ),
                  child: TweenAnimationBuilder<Color?>(
                    tween: ColorTween(end: contentColor),
                    duration: duration,
                    curve: tokens.motion.standard,
                    builder: (context, color, _) => Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: [
                        AnimatedContainer(
                          width: 18,
                          height: 3,
                          duration: duration,
                          curve: tokens.motion.standard,
                          decoration: BoxDecoration(
                            color: widget.selected
                                ? colors.accentIndigo
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              tokens.radius.full,
                            ),
                          ),
                        ),
                        Icon(widget.destination.icon, size: 20, color: color),
                        Text(
                          tabLabel.format(label),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tabLabel.style.copyWith(color: color),
                        ),
                      ],
                    ),
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
```

Notes for the reviewer, not for the file (the file carries no comments):

- `Material` is both the flat `surfaceTabChrome` fill (C14) and the ink host
  `InkWell` needs; `elevation: 0` + transparent `surfaceTintColor` keeps any
  elevation overlay off the surface.
- `SafeArea(minimum: bottom 22)` reserves `max(liveInset, 22)` **and** removes the
  bottom padding from its subtree, so a descendant sees zero (C19). Nothing else
  in the tree applies that inset.
- `MergeSemantics` collapses the cell into one node: the visible `Text` supplies
  the name once, `Semantics.label` adds the localized position, `selected` adds the
  state, the `Icon` carries no `semanticLabel` and the `Tooltip` is excluded
  (C8, C9, C10).
- The cap keeps its 18×3 box on every destination and only swaps colour, so the
  column never reflows on a selection change (C16).
- `tokens.motion.resolve` returns `Duration.zero` under reduced motion, which
  makes both the cap and the colour tween settle instantly (C22).

## MODIFY EXISTING

### lib/features/home/presentation/screens/home_screen.dart

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar.dart';

// ...

      builder: (context, child) {
        return Scaffold(
          bottomNavigationBar: BottomTabBar(
            selectedIndex: context.tabsRouter.activeIndex,
            onDestinationSelected: context.tabsRouter.setActiveIndex,
          ),
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final notifier = getIt.get<ScrollNotifier>();
              // ... unchanged, stays exactly as it is (FOLLOW-UP-1) ...
              return false;
            },
            child: child,
          ),
        );
      },
```

The `navigation_destination.dart`, `scrolled_navigation_bar.dart` and
`generated/l10n.dart` imports go; `service_locator.dart` and
`scroll_notifier.dart` stay, because the body's `NotificationListener` still
uses them.

### lib/widgets/scrolled_navigation_bar.dart

DELETE — whole file.

### lib/widgets/navigation_destination.dart

DELETE — whole file.

## TEST FILES

### test/widget/components/bottom_tab_bar_test.dart

Twelve tests, one file. Pump inside `MaterialApp(theme: buildDarkTheme(), ...)`
with `S.delegate` and the `GlobalMaterialLocalizations` delegates, as
`stat_pill_test.dart` does; a `Scaffold` with the bar as `bottomNavigationBar`.
No mocks, no `getIt` registration and no `setUpAll` token resolution.

- `'shows every destination label and glyph whichever destination is selected'`
  — the five labels and the five outline icons are all findable with the first
  destination selected and again with the last (C1, C7, C18 identity).
- `'reports the tapped destination index once per tap'` — tapping a
  destination's label, its glyph and its empty padded area each report that same
  index exactly once (C2).
- `'moves the selected state to the destination the caller supplies'` — rebuilt
  with a new index, only that destination's semantics node is selected; a tap
  alone leaves the selected node where it was (C3, C4, C8).
- `'announces the destination name once with its localized tab position'` — the
  merged node's label contains the destination name a single time alongside the
  platform's tab-position phrasing (C9, C10).
- `'shows the destination label as a tooltip on long press without reporting a
  selection'` (C11).
- `'reports the destination reached by keyboard traversal when it is activated'`
  — tab forward to the third destination and activate it; index 2 comes back,
  proving both order and pointer-free activation (C12).
- `'keeps all five destinations while the body scrolls with no scroll state
  registered'` — nothing registered in `getIt`, drag a scrollable body up and
  down, all five still there (C5). **Read `tdd.md`'s FOLLOW-UP-1 note before
  changing this one.**
- `'fills the bar with the surfaceTabChrome token'` — the separation mechanism is
  the colour, so the colour is the assertion (C14).
- `'tints the selected destination and its cap with accentIndigo and the rest
  with ink55'` — glyph, label and cap colour in both states, cap present on all
  five and transparent on the four unselected (C15, C16 colour half, C18
  colour-driven glyph). No size, radius or position assertion — those are the
  manual checks.
- `'consumes the bottom safe-area inset so its content sees none'` — pumped with
  a non-zero bottom inset, a widget inside the bar reads a zero bottom inset;
  the bar also builds with the inset at zero (C19). Asserts consumption, not a
  measurement.
- `'renders every destination without overflow in zh at a raised text scale'` —
  no exception, five destinations still present, label capped to one line with an
  ellipsis (C21).
- `'settles a selection change with no running animation under reduced motion'`
  — with `disableAnimations` on, a new index settles in a single pump (C22).

Not tested, deliberately: C17's size and weight, C13's press treatment, C19's
and C20's measurements, C16's geometry, C18's stroke — all dimension or painted
appearance, which this project checks manually. C17's testable half (the label
is not uppercased) is already covered by the first test's literal label finders,
and C6 is covered by the constructor surface — see `task-brief.md ## Testing
mode`.

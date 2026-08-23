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

## Approved feedback delta

Recorded 2026-08-23 after the Phase 3 human review. **Authoritative over
everything above it wherever the two conflict.** No acceptance criterion changes —
all twenty-two stand as written, and every decision not named here is unchanged.
Because the delta moves and renames every created file, `tdd.md` and
`task-brief.md` have also been corrected in place (file allowlist, implementation
plan, and the paragraphs that named the old flat-file shape); the rest of both
files stands.

### 1. The destination cell is split into four classes

`_TabDestinationCell` was doing six jobs in ~85 lines. It becomes four widgets,
each with one nameable job:

- `BottomTabBarCell` — one destination's interaction and accessibility shell.
  Stateful, owns the press and focus flags; carries the semantics node, the
  tooltip, the `InkWell`, the 44 minimum and the press scale.
- `BottomTabBarFocusRing` — draws the green outline when focused, and reserves
  its space when not.
- `BottomTabBarCellContent` — the cap-glyph-label column, colour-animated by
  selection.
- `BottomTabBarCap` — the 18x3 indigo cap above the glyph.

### 2. The component moves to a module folder

`lib/widgets/bottom_tab_bar/`, with `BottomTabBar` at the module root, one file
per split class, and the destination enum under `enum/` — the same shape as
`game_card/`, `completion_ring/` and `countdown/`.

This **reverses** the "Flat file, not a module folder" decision in
`tdd.md ## Design decisions`. That reasoning rested on the module having a single
public class plus little else; revision 1 undoes that premise, so the folder is
now the right shape.

**The enum is INTERNAL here, and that is deliberate.** In the other three modules
the enum under `enum/` is public API — a caller must pass `GameCardSize`,
`CompletionRingSize` or `CountdownForm`. Here the caller passes an `int` and gets
an `int` back (C2, C3, C6), so `BottomTabBarDestination` is something no caller
ever names, and `enum/` holds a type that is invisible outside the folder. The
folder shape is kept anyway, as the human's explicit call for consistency across
the four component modules. Recorded so a future reader does not mistake it for an
accidental inconsistency and "fix" it.

The four split classes are Dart-public for the same reason — they cross file
boundaries inside the module — but they are **module-internal** and are not
imported from outside the folder, exactly as `GameCardFooter` and
`CountdownDigitRow` are.

### 3. `Expanded` stays — settled, not an open question

The human asked why not `MainAxisAlignment.spaceEvenly`. `Expanded` is kept, and
`tdd.md ## Design decisions` now records why, so nobody "simplifies" it later:
equal-width tap targets with no dead gaps between the cells, the 44 minimum
without extra per-cell width constraints, stable layout in `zh` and under text
scaling with the label ellipsizing in a fixed slot, even cap spacing across the
five destinations, and it is what Material's own `NavigationBar` uses internally.

### 4. `.claude/skills/flutter-widgets/SKILL.md` joins the allowlist — catalogue rows only

This run deletes `scrolled_navigation_bar.dart` and `navigation_destination.dart`
while the catalogue still lists both, which would leave it describing widgets that
no longer exist. Items 2.1, 2.2 and 2.3 each updated that catalogue in-run, so
this restores consistency rather than setting a precedent. This **reverses** the
"not in Dev's allowlist" bullet in `tdd.md ## Out of scope`.

**Catalogue table rows only. No rule text, no new prose section, nothing outside
the table.** Delete these two rows:

| `NavigationDestination` | `navigation_destination.dart` | Bottom nav destination item |
| `ScrolledNavigationBar` | `scrolled_navigation_bar.dart` | Navigation bar that hides on scroll |

and add, in their place:

| `BottomTabBar` | `bottom_tab_bar/bottom_tab_bar.dart` | Static bottom tab chrome: onyx `surfaceTabChrome` fill, five fixed destinations at equal width, each an outline 20px glyph over an always-visible 10/500 label, plus an 18x3 fully-rounded cap above the glyph — indigo glyph, label and cap on the selected destination, ink-55 and a transparent cap on the other four. Reserves the live bottom safe-area inset with a 22 fallback and consumes it. Caller-driven: takes a selected index, reports the tapped index, holds no selection of its own and reads no scroll state. Multi-file module — `BottomTabBar` is the only public surface; the cell, focus ring, cap, content and the destination enum beside it are internal and are not imported from outside the folder. Adds no spacing of its own |

### Revised skeleton — replaces `## CREATE NEW` above

#### lib/widgets/bottom_tab_bar/enum/bottom_tab_bar_destination.dart

```dart
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';

enum BottomTabBarDestination {
  featured(Icons.featured_play_list_outlined),
  games(Icons.gamepad_outlined),
  tracker(Icons.format_list_numbered_rtl),
  browse(Icons.search_outlined),
  settings(Icons.settings_outlined);

  const BottomTabBarDestination(this.icon);

  final IconData icon;

  String get label => switch (this) {
    BottomTabBarDestination.featured => S.current.featured,
    BottomTabBarDestination.games => S.current.games,
    BottomTabBarDestination.tracker => S.current.tracker,
    BottomTabBarDestination.browse => S.current.browse,
    BottomTabBarDestination.settings => S.current.settings,
  };
}
```

The `l10n` import becomes a package import rather than the relative
`../generated/l10n.dart` the flat file used — the module now sits two levels down,
and `completion_ring.dart` and `countdown_digit_row.dart` both take the package
import.

#### lib/widgets/bottom_tab_bar/bottom_tab_bar_cap.dart

```dart
class BottomTabBarCap extends StatelessWidget {
  const BottomTabBarCap({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AnimatedContainer(
      width: 18,
      height: 3,
      duration: tokens.motion.resolve(context, tokens.motion.stateChange),
      curve: tokens.motion.standard,
      decoration: BoxDecoration(
        color: selected ? tokens.color.accentIndigo : Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radius.full),
      ),
    );
  }
}
```

#### lib/widgets/bottom_tab_bar/bottom_tab_bar_focus_ring.dart

```dart
class BottomTabBarFocusRing extends StatelessWidget {
  const BottomTabBarFocusRing({
    super.key,
    required this.focused,
    required this.child,
  });

  final bool focused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: focused ? tokens.color.green : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(tokens.radius.sm),
      ),
      child: child,
    );
  }
}
```

The border and the 2px padding are present in both states, so taking focus never
reflows the cell, and the ring is drawn inside the cell's own bounds so the bar's
edge cannot clip it (C12).

#### lib/widgets/bottom_tab_bar/bottom_tab_bar_cell_content.dart

```dart
class BottomTabBarCellContent extends StatelessWidget {
  const BottomTabBarCellContent({
    super.key,
    required this.destination,
    required this.selected,
  });

  final BottomTabBarDestination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final tabLabel = tokens.typography.tabLabel;

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        end: selected ? tokens.color.accentIndigo : tokens.color.ink55,
      ),
      duration: tokens.motion.resolve(context, tokens.motion.stateChange),
      curve: tokens.motion.standard,
      builder: (context, color, _) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          BottomTabBarCap(selected: selected),
          Icon(destination.icon, size: 20, color: color),
          Text(
            tabLabel.format(destination.label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tabLabel.style.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
```

The `Icon` still takes no `semanticLabel` (C10). The cap is a child here rather
than a branch, so the column's three slots are always occupied and a selection
change cannot reflow the row (C16).

#### lib/widgets/bottom_tab_bar/bottom_tab_bar_cell.dart

```dart
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
            onHighlightChanged: (pressed) =>
                setState(() => _pressed = pressed),
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
```

Composition order is unchanged from the flat version — semantics outside the
tooltip, outside the ink well, outside the 44 constraint, outside the press scale
— so nothing about C2, C8, C9, C10, C11, C12, C13 or C20 moves. Only the class
boundaries are new.

#### lib/widgets/bottom_tab_bar/bottom_tab_bar.dart

```dart
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
              for (final destination in BottomTabBarDestination.values)
                Expanded(
                  child: BottomTabBarCell(
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
```

Public API is exactly what it was: `selectedIndex` in, index out. The five
`Expanded` children stay — see delta item 3.

Every file in the module carries **no comments at all**, imports its siblings by
package path
(`package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/...`), and
reads its own tokens through `context.tokens`.

### One-line change in `## MODIFY EXISTING`

`home_screen.dart`'s import becomes
`package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar.dart`.
Everything else in that section — the `BottomTabBar(...)` call, the retained
`NotificationListener` and its `ScrollNotifier` write, the two deletions — is
unchanged.

### Test plan: unchanged

Still **twelve tests in one file** at
`test/widget/components/bottom_tab_bar_test.dart`, asserting exactly what is
listed under `## TEST FILES` above. The split adds no tests: the four new classes
are module-internal, not public contract, and every behaviour they own is already
observable through `BottomTabBar`. No dimension, gap, radius, offset or position
assertion; colour assertions name a token; never a golden test.

### Explicitly unchanged by this delta

The dropped scroll-hide decision and FOLLOW-UP-1's orphan list; the 3px cap
exception; the label-paired glyph finding; both old files DELETED rather than
`@Deprecated`; `SafeArea(minimum:)` giving `max(inset, 22)`; keeping
`MaterialLocalizations.tabLabel`, `Semantics(selected:)`, `Tooltip` and the
ink-suppressed `InkWell`; not reusing `ButtonPressScale`; C6 getting no dedicated
widget test; and `tdd.md`'s note that C5's test loses its meaning once
FOLLOW-UP-1 removes `ScrollNotifier`.

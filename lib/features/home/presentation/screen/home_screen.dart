import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/navigation_destination.dart';
import 'package:gaming_library_assessment_flutter/widgets/scrolled_navigation_bar.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ScrolledNavigationBar(
        child: NavigationBar(
          onDestinationSelected: (index) {
            _goBranch(index);
            setState(() => tabIndex = index);
          },
          selectedIndex: tabIndex,
          destinations: [
            CustomNavigationDestination(
              iconData: Icons.featured_play_list,
              label: S.current.featured,
            ),
            CustomNavigationDestination(
              iconData: Icons.gamepad,
              label: S.current.games,
            ),
            CustomNavigationDestination(
              iconData: Icons.format_list_numbered_rtl_rounded,
              label: S.current.tracker,
            ),
            CustomNavigationDestination(
              iconData: Icons.search,
              label: S.current.browse,
            ),
            CustomNavigationDestination(
              iconData: Icons.settings,
              label: S.current.settings,
            ),
          ],
        ),
      ),
      body: widget.navigationShell,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/navigation_destination.dart';
import 'package:gaming_library_assessment_flutter/widgets/scrolled_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

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
              iconData: Icons.newspaper,
              label: context.localisations.featured,
            ),
            CustomNavigationDestination(
              iconData: Icons.gamepad,
              label: context.localisations.games,
            ),
            CustomNavigationDestination(
              iconData: Icons.search,
              label: context.localisations.browse,
            ),
          ],
        ),
      ),
      body: widget.navigationShell,
    );
  }
}

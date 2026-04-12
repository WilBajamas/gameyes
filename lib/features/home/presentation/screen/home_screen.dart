import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/widgets/navigation_destination.dart';
import 'package:gaming_library_assessment_flutter/widgets/scrolled_navigation_bar.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [
        FeaturedRoute(),
        GamesRoute(),
        TrackerRoute(),
        BrowseRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        return Scaffold(
          bottomNavigationBar: ScrolledNavigationBar(
            child: NavigationBar(
              onDestinationSelected: (index) =>
                  context.tabsRouter.setActiveIndex(index),
              selectedIndex: context.tabsRouter.activeIndex,
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
          body: child,
        );
      },
    );
  }
}

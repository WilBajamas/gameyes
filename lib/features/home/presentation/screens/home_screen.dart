import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/bottom_tab_bar/bottom_tab_bar.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          bottomNavigationBar: BottomTabBar(
            selectedIndex: context.tabsRouter.activeIndex,
            onDestinationSelected: context.tabsRouter.setActiveIndex,
          ),
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final notifier = getIt.get<ScrollNotifier>();
              if (notification.direction == ScrollDirection.forward &&
                  !notifier.scrolledForward) {
                notifier.isScrolled = ScrollDirection.forward;
              } else if (notification.direction == ScrollDirection.reverse &&
                  notifier.scrolledForward) {
                notifier.isScrolled = ScrollDirection.reverse;
              }

              return false;
            },
            child: child,
          ),
        );
      },
    );
  }
}

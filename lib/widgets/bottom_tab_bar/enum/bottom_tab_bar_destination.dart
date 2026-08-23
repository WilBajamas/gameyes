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

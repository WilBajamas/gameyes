import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';

enum BottomTabBarDestination {
  featured(Icons.featured_play_list_outlined),
  library(Icons.collections_bookmark_outlined),
  browse(Icons.search_outlined),
  feed(Icons.dynamic_feed_outlined),
  settings(Icons.settings_outlined);

  const BottomTabBarDestination(this.icon);

  final IconData icon;

  String get label => switch (this) {
    BottomTabBarDestination.featured => S.current.featured,
    BottomTabBarDestination.library => S.current.library,
    BottomTabBarDestination.browse => S.current.browse,
    BottomTabBarDestination.feed => S.current.feed,
    BottomTabBarDestination.settings => S.current.settings,
  };
}

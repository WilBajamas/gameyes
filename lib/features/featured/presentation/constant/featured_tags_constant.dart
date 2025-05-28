import 'package:flutter/material.dart';

import '../../../../core/enums/featured_tag.dart';
import '../../../../generated/l10n.dart';

List<(FeaturedTag, String, IconData)> featuredFilters = [
  (FeaturedTag.newAndTrending, S.current.new_and_trending, Icons.trending_up),
  (FeaturedTag.newReleases, S.current.new_releases_30_days, Icons.new_releases),
  (
    FeaturedTag.bestOfTheYear,
    S.current.best_of_the_year,
    Icons.reviews,
  ),
  (
    FeaturedTag.bestMetacritic,
    S.current.best_metacritic,
    Icons.fast_rewind,
  ),
  (
    FeaturedTag.allTimeTop100,
    S.current.all_time_top_100,
    Icons.thumb_up_sharp,
  ),
];

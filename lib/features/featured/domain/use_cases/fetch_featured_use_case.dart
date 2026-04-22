import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/featured_tag.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchFeaturedUseCase {
  final FeaturedRepository _repository;

  FetchFeaturedUseCase(this._repository);

  Future<Result<GameListEntity>> call({
    required int page,
    required FeaturedTag tag,
    Set<GamePlatform>? platforms,
  }) async {
    final feature = _getFeaturedValues(tag);

    final dateFromString = feature.$2.getFormattedStringFromDateTime() ?? '';
    final dateToString = feature.$3?.getFormattedStringFromDateTime() ?? '';

    final dateRangeQuery =
        // ignore: lines_longer_than_80_chars
        '$dateFromString${dateFromString.isNotEmpty && dateToString.isNotEmpty ? ',' : ''}$dateToString';

    final gameOrderingQuery =
        feature.$1.map((ordering) => '-${ordering.name}').join(',');

    String getGamePlatformQuery() {
      if (platforms == null || platforms.isEmpty) return '';

      Set<int> allPlatformIds =
          platforms.fold<Set<int>>({}, (acc, p) => acc..addAll(p.ids));

      return allPlatformIds.join(',');
    }

    return _repository.fetchGames(
      page: page,
      dateRange: dateRangeQuery,
      orderings: gameOrderingQuery,
      platforms:
          getGamePlatformQuery().isNotEmpty ? getGamePlatformQuery() : null,
    );
  }
}

(List<GameOrdering>, DateTime?, DateTime?) _getFeaturedValues(
  FeaturedTag tag,
) =>
    switch (tag) {
      FeaturedTag.newAndTrending => (
          [
            GameOrdering.added,
            GameOrdering.rating,
            GameOrdering.metacritic,
          ],
          DateTime(DateTime.now().year),
          DateTime.now().getDateTimeLater(yearsLater: 1)
        ),
      FeaturedTag.newReleases => (
          [GameOrdering.released],
          DateTime.now().getDateTimeBefore(daysBefore: 30),
          DateTime.now()
        ),
      FeaturedTag.bestOfTheYear => (
          [GameOrdering.added],
          DateTime(DateTime.now().year),
          DateTime(DateTime.now().year, 12, 31)
        ),
      FeaturedTag.bestMetacritic => ([GameOrdering.metacritic], null, null),
      FeaturedTag.allTimeTop100 => ([GameOrdering.added], null, null),
    };

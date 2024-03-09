import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/featured_tag.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchFeaturedUseCase {
  final FeaturedRepository _repository = getIt<FeaturedRepository>();

  Future<void> call({
    required int page,
    required FeaturedTag tag,
    required Function(GamesResponse) onSuccess,
    required Function(ErrorType) onFailure,
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

    final response = await _repository.fetchGames(
      page: page,
      dateRange: dateRangeQuery,
      orderings: gameOrderingQuery,
      platforms:
          getGamePlatformQuery().isNotEmpty ? getGamePlatformQuery() : null,
    );

    response.fold(onFailure, onSuccess);
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

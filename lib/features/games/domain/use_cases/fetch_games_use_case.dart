import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/repositories/games_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchGamesUseCase {
  final GamesRepository _repository;

  const FetchGamesUseCase(this._repository);

  Future<Result<GamesResponse>> call({
    required int page,
    String? searchTerm,
    DateTime? dateFrom,
    DateTime? dateTo,
    Set<GamePlatform>? platforms,
    Set<GameGenre>? genres,
    GameOrdering? ordering,
    bool ascending = false,
  }) async {
    final dateFromString = dateFrom.getFormattedStringFromDateTime() ?? '';
    final dateToString = dateTo.getFormattedStringFromDateTime() ?? '';

    final dateRangeQuery =
        (dateFromString.isNotEmpty && dateToString.isNotEmpty)
            ? '$dateFromString,$dateToString'
            : dateFromString.isNotEmpty
                ? dateFromString
                : dateToString;

    final gameOrderingQuery = ascending ? ordering?.name : '-${ordering?.name}';

    String? getGamePlatformQuery() {
      if (platforms == null || platforms.isEmpty) return null;

      final allPlatformIds = platforms.expand((p) => p.ids).toSet();

      return allPlatformIds.isNotEmpty ? allPlatformIds.join(',') : null;
    }

    return await _repository.fetchGames(
      page: page,
      searchTerm: searchTerm,
      dateRange: dateRangeQuery.isNotEmpty ? dateRangeQuery : null,
      ordering: gameOrderingQuery,
      platforms: getGamePlatformQuery(),
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchGamesUseCase {
  final _repository = getIt<GamesRepository>();

  Future<Either<ErrorType, GamesResponse>> call({
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
        // ignore: lines_longer_than_80_chars
        '$dateFromString${dateFromString.isNotEmpty && dateToString.isNotEmpty ? ',' : ''}$dateToString';

    final gameOrderingQuery = ascending ? ordering?.name : '-${ordering?.name}';

    String getGamePlatformQuery() {
      if (platforms == null || platforms.isEmpty) return '';

      Set<int> allPlatformIds =
          platforms.fold<Set<int>>({}, (acc, p) => acc..addAll(p.ids));

      return allPlatformIds.join(',');
    }

    return await _repository.fetchGames(
      page: page,
      searchTerm: searchTerm,
      dateRange: dateRangeQuery,
      ordering: gameOrderingQuery,
      platforms:
          getGamePlatformQuery().isNotEmpty ? getGamePlatformQuery() : null,
    );
  }
}

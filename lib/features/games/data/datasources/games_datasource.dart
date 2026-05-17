import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/igdb_query_builder.dart';
import 'package:injectable/injectable.dart';

import '../../services/games_service.dart';

@injectable
class GamesDataSource {
  final GamesServices _gamesServices;

  const GamesDataSource(this._gamesServices);

  Future<GamesModel> fetchDatasourceGames({
    int page = 1,
    int pageSize = 20,
    String? searchTerm,
    String? dateRange,
    String? orderings,
    String? platforms,
    String? genres,
  }) async {
    final queryBuilder = IGDBQueryBuilder()
        .fields(IGDBConfig.standardGameFields)
        .limit(pageSize)
        .offset((page - 1) * pageSize);

    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryBuilder.search(searchTerm);
    } else {
      queryBuilder.sort('first_release_date');
    }

    // Note: Converting RAWG-style filters to IGDB where-clauses will require more logic.
    // For now, we apply the basic query.

    final response = await _gamesServices.fetchGames(queryBuilder.build());

    // We manually wrap the IGDB list into the old GamesModel for backward compatibility
    return GamesModel(
      count: 0, // IGDB doesn't return total count in the same request easily
      results: response,
    );
  }
}

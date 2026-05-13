import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';
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
  }) async =>
      await _gamesServices.fetchGames(
        'dummy_query',
      );
}

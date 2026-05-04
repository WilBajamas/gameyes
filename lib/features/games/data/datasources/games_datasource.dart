import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/retrofit_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GamesDataSource {
  final RetrofitService _retrofitService;

  const GamesDataSource(this._retrofitService);

  Future<GamesModel> fetchDatasourceGames({
    int page = 1,
    int pageSize = 20,
    String? searchTerm,
    String? dateRange,
    String? orderings,
    String? platforms,
    String? genres,
  }) async =>
      await _retrofitService.fetchGames(
        page,
        pageSize,
        dateRange,
        orderings,
        searchTerm,
        platforms,
        genres,
      );
}

import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GamesDataSource {
  final DioService _dioService;

  const GamesDataSource(this._dioService);

  Future<GamesResponse> fetchDatasourceGames({
    int page = 1,
    int pageSize = 20,
    String? searchTerm,
    String? dateRange,
    String? orderings,
    String? platforms,
    String? genres,
  }) async =>
      await _dioService.retrofitService.fetchGames(
        page,
        pageSize,
        dateRange,
        orderings,
        searchTerm,
        platforms,
        genres,
      );
}

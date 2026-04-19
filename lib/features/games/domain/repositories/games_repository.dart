import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';

abstract class GamesRepository {
  Future<Result<GamesResponse>> fetchGames({
    int page,
    String? searchTerm,
    String? dateRange,
    String? platforms,
    String? genres,
    String? ordering,
  });
}

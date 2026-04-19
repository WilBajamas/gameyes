import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';

abstract interface class FeaturedRepository {
  Future<Result<GamesResponse>> fetchGames({
    required int page,
    String? dateRange,
    String? orderings,
    String? platforms,
  });
}

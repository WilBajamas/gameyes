import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';

abstract interface class FeaturedRepository {
  Future<Result<GameListEntity>> fetchGames({
    required int page,
    String? dateRange,
    String? orderings,
    String? platforms,
  });
}

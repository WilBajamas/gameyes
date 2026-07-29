import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';

abstract interface class GamesRepository {
  Future<Result<GameListEntity>> fetchGames({
    int page,
    String? searchTerm,
    String? dateRange,
    String? platforms,
    String? genres,
    String? ordering,
  });
}

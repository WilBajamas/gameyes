import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_detail_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

abstract class GameDetailRepository {
  Future<Result<GameDetailEntity>> fetchGameDetail({
    required int id,
  });

  Future<void> saveGame({required SavedGame game});

  Future<void> unsaveGame({required int id});

  Future<SavedGame?> getSavedGame({required int id});
}

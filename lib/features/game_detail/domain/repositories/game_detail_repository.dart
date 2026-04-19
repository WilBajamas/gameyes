import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

// TODO: Change to correct CLEAN architecture
// TODO: for local & remote - [GameDetailRepository]
abstract class GameDetailRepository {
  Future<Result<GameDetailResponse>> fetchGameDetail({
    required int id,
  });

  Future<void> saveGame({required SavedGame game});

  Future<void> unsaveGame({required int id});

  Future<SavedGame?> getSavedGame({required int id});
}

import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

abstract interface class TrackerDetailRepository {
  Future<SavedGame?> setPlatform({
    required GamePlatform platform,
    required int gameId,
  });

  Future<SavedGame?> createGroupTask({
    required String title,
    required String description,
    required int id,
  });
}

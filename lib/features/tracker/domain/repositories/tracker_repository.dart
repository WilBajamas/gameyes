import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

abstract interface class TrackerRepository {
  Future<List<TrackerSavedGameEntity>> getSavedGames();

  Stream<List<SavedGame>> savedGamesStream(
    SavedGameFilterTag tag,
    String? searchTerm,
  );

  Stream<List<SavedGame>> searchGamesStream(String term);

  Future<void> removeSavedGame(int id);
}

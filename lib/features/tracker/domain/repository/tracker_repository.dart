import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

abstract interface class TrackerRepository {
  Future<List<SavedGame?>> getSavedGames();

  Stream<List<SavedGame>> savedGamesStream();
}

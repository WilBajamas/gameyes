import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import '../entities/library_snapshot_entity.dart';
import '../entities/genre_preferences_entity.dart';
import '../entities/countdown_game_entity.dart';

export '../entities/library_snapshot_entity.dart';
export '../entities/genre_preferences_entity.dart';
export '../entities/countdown_game_entity.dart';

abstract interface class FeaturedRepository {
  Future<Result<LibrarySnapshotEntity>> getLibrarySnapshot();
  Future<Result<CountdownGameEntity>> getCountdownGame();
  Future<Result<List<GameEntity>>> getOutThisWeekGames(bool forceExtendWindow);
  Future<Result<List<GameEntity>>> getCriticsChoiceGames(
    List<int> genrePreferences,
  );
  Future<Result<void>> saveGenrePreferences(List<int> genreIds, bool isSkipped);
  Future<Result<GenrePreferencesEntity>> getGenrePreferences();
}

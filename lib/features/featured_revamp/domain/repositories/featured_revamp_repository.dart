import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import '../entities/library_snapshot_entity.dart';
import '../entities/genre_preferences_entity.dart';

export '../entities/library_snapshot_entity.dart';
export '../entities/genre_preferences_entity.dart';

abstract class FeaturedRevampRepository {
  Future<Result<LibrarySnapshotEntity>> getLibrarySnapshot();
  Future<Result<GameEntity?>> getCountdownGame();
  Future<Result<List<GameEntity>>> getOutThisWeekGames(bool forceExtendWindow);
  Future<Result<List<GameEntity>>> getCriticsChoiceGames(
    List<int> genrePreferences,
  );
  Future<Result<void>> saveGenrePreferences(
    List<int> genreIds,
    bool isSkipped,
  );
  Future<Result<GenrePreferencesEntity>> getGenrePreferences();
}

import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/play_session_log.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class FeaturedLocalDatasource {
  final GameLocalStorageService _localStorage;
  final SharedPreferences _sharedPreferences;

  static const _genreIdsKey = 'featured_genre_ids';
  static const _skippedKey = 'featured_genre_skipped';

  FeaturedLocalDatasource(
    this._localStorage,
    this._sharedPreferences,
  );

  Future<Isar> _getDb() async {
    return await _localStorage.dbInstance;
  }

  Future<int> countSavedGames() async {
    final isar = await _getDb();
    return isar.savedGames.count();
  }

  Future<Set<int>> getOwnedGameIds() async {
    final isar = await _getDb();
    final games = await isar.savedGames.where().findAll();
    return games.map((g) => g.gameId).whereType<int>().toSet();
  }

  Future<List<SavedGame>> getWishlistedGames() async {
    final isar = await _getDb();
    return isar.savedGames.filter().isWishlistedEqualTo(true).findAll();
  }

  Future<List<SavedGame>> getNowPlayingGames() async {
    final isar = await _getDb();
    return isar.savedGames
        .filter()
        .statusEqualTo('Playing')
        .sortByDateModifiedDesc()
        .findAll();
  }

  Future<double> getThisWeekPlayHours() async {
    final isar = await _getDb();
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final logs = await isar.playSessionLogs
        .filter()
        .timestampGreaterThan(cutoff)
        .findAll();
    double total = 0.0;
    for (final log in logs) {
      final hours = log.hoursPlayed;
      if (hours != null) {
        total += hours;
      }
    }
    return total;
  }

  Future<void> saveGenrePreferences(List<int> genreIds, bool isSkipped) async {
    final stringIds = genreIds.map((id) => id.toString()).toList();
    await _sharedPreferences.setStringList(_genreIdsKey, stringIds);
    await _sharedPreferences.setBool(_skippedKey, isSkipped);
  }

  Future<GenrePreferencesEntity?> getSavedGenrePreferences() async {
    final stringIds = _sharedPreferences.getStringList(_genreIdsKey);
    final isSkipped = _sharedPreferences.getBool(_skippedKey);

    if (stringIds == null || isSkipped == null) {
      return null;
    }

    final genreIds = stringIds.map((id) => int.parse(id)).toList();
    return GenrePreferencesEntity(genreIds: genreIds, isSkipped: isSkipped);
  }

  Future<List<SavedGame?>> getSavedGames() async {
    return _localStorage.getSavedGames();
  }
}

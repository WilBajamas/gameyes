import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameLocalDatasource {
  final _gameLocalStorage = getIt<GameLocalStorageService>();

  Future<void> saveGame({required SavedGame game}) =>
      _gameLocalStorage.insertGame(game);

  Future<void> unsaveGame({required int id}) =>
      _gameLocalStorage.deleteGame(id);

  Future<SavedGame?> getSavedGame({required int id}) =>
      _gameLocalStorage.getGameById(id);

  Future<List<SavedGame?>> getSavedGames() => _gameLocalStorage.getSavedGames();

  Stream<List<SavedGame>> listenToSavedGames(
    SavedGameFilterTag tag,
    String? searchTerm,
  ) =>
      _gameLocalStorage.listenToSavedGames(tag, searchTerm);

  Stream<List<SavedGame>> listenToSearchSavedGames(String term) =>
      _gameLocalStorage.listenToSearchSavedGames(term);

  Future<SavedGame?> setPlatform({
    required GamePlatform platform,
    required int gameId,
  }) async {
    final game = await _gameLocalStorage.getGameById(gameId);
    if (game != null) {
      if (game.platforms != null && game.platforms!.contains(platform)) {
        return _gameLocalStorage.removePlatform(platform, game);
      } else {
        return _gameLocalStorage.addPlatform(platform, game);
      }
    }
    return null;
  }

  Future<SavedGame?> createGroupTask({
    required String title,
    required String description,
    required int id,
  }) async {
    final game = await _gameLocalStorage.getSavedGame(id);
    if (game case final savedGame?) {
      final GroupTask groupTaskToSave = GroupTask()
        ..gameId = game.gameId
        ..title = title
        ..description = description;

      await _gameLocalStorage.createGroupTask(groupTaskToSave, savedGame);
      return await _gameLocalStorage.getSavedGame(id);
    }

    return null;
  }
}

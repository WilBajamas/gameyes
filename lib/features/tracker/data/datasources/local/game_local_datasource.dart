import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
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

  Future<void> setPlatform({
    required GamePlatform platform,
    required int savedGameId,
  }) async {
    final game = await _gameLocalStorage.getSavedGame(savedGameId);
    if (game case final savedGame?) {
      if (savedGame.platforms != null && game.platforms!.contains(platform)) {
        _gameLocalStorage.removePlatform(platform, savedGame);
      } else {
        _gameLocalStorage.addPlatform(platform, savedGame);
      }
    }
  }

  Future<void> createGroupTask({
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
    }
  }

  Stream<SavedGame?> listenToSavedGame({required int savedGameId}) =>
      _gameLocalStorage.listenToSavedGameDetail(savedGameId);

  Future<void> removeGroupTask({
    required int savedGameId,
    required int groupTaskId,
  }) =>
      _gameLocalStorage.removeGroupTask(savedGameId, groupTaskId);

  Future<void> createTaskInGroup({
    required int groupTaskId,
    required int savedGameId,
  }) async =>
      await _gameLocalStorage.createTaskInGroup(
        groupTaskId,
        savedGameId,
        Task()..title = 'New Task',
      );
}

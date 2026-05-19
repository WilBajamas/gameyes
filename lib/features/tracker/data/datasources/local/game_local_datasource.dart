import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameLocalDatasource {
  final GameLocalStorageService _gameLocalStorage;

  GameLocalDatasource(this._gameLocalStorage);

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
    required PlatformEntity platform,
    required int savedGameId,
  }) async {
    final game = await _gameLocalStorage.getSavedGame(savedGameId);
    if (game case final savedGame?) {
      final exists =
          savedGame.platforms?.any((p) => p.id == platform.id) ?? false;
      if (exists) {
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
      final GroupTask groupTaskToSave = GroupTask(
        gameId: game.gameId,
        title: title,
        description: description,
      );
      // ..gameId = game.gameId
      // ..title = title
      // ..description = description;

      await _gameLocalStorage.createGroupTask(groupTaskToSave, savedGame);
    }
  }

  Stream<SavedGame?> listenToSavedGame({required int savedGameId}) =>
      _gameLocalStorage.listenToSavedGameDetail(savedGameId);

  Stream<SavedGameTask?> listenToTask({required int taskId}) =>
      _gameLocalStorage.listenToTask(taskId);

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
        SavedGameTask()..title = 'New Task',
      );

  Future<void> addStep({
    required int taskId,
    required TaskStep step,
  }) async =>
      _gameLocalStorage.addStep(taskId, step);

  Future<bool> removeStep({
    required int taskId,
    required TaskStep step,
  }) async =>
      _gameLocalStorage.removeStep(taskId, step);

  Future<void> editStep({
    required int taskId,
    required String stepId,
    required String title,
    required String description,
    required int stepNumber,
    String? image,
  }) async {
    final oldStep = await _gameLocalStorage.getTaskStep(stepId, taskId);
    oldStep
      ..title = title
      ..description = description
      ..image = image;
    return _gameLocalStorage.editStep(taskId, stepId, oldStep);
  }

  Future<void> changeCurrentStep({
    required int taskId,
    required int stepIndex,
  }) =>
      _gameLocalStorage.changeCurrentStep(taskId, stepIndex);
}

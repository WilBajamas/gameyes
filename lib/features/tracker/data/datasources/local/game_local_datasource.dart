import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/game_local_storage.dart';
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
      _gameLocalStorage.getGame(id);

  Future<List<SavedGame?>> getSavedGames() => _gameLocalStorage.getSavedGames();

  Stream<List<SavedGame>> listenToSavedGames(SavedGameFilterTag tag) =>
      _gameLocalStorage.listenToSavedGames(tag);
}

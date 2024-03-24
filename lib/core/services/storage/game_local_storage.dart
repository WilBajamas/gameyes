import 'package:gaming_library_assessment_flutter/core/services/storage/isar_local_storage_service.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@injectable
class GameLocalStorageService extends IsarLocalStorageService {
  Future<void> insertGame(SavedGame game) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.savedGames.put(game));
  }

  Stream<List<SavedGame>> listenToSavedGames() async* {
    final isar = await db;
    yield* isar.savedGames.where().watch();
  }

  Future<List<SavedGame?>> getSavedGames({required int? gameId}) async {
    final isar = await db;
    // if (gameId == null) {
    return await isar.savedGames.filter().gameIdIsNotNull().findAll();
    // }
  }

  Future<SavedGame?> getGame(int gameId) async {
    final isar = await db;
    final existingGame =
        await isar.savedGames.filter().gameIdEqualTo(gameId).findFirst();

    return existingGame;
  }

  Future<void> deleteGame(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.savedGames.delete(id));
  }
}

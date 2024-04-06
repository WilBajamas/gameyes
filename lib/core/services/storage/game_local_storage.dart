import 'dart:async';

import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
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

  Stream<List<SavedGame>> listenToSavedGames(SavedGameFilterTag tag) async* {
    final isar = await db;
    final query = isar.savedGames.where(sort: Sort.desc);
    
    switch (tag) {
      case SavedGameFilterTag.recentlyChanged:
        yield* query.anyDateModified().watch(fireImmediately: true);

      case SavedGameFilterTag.name:
        yield* isar.savedGames.where().anyName().watch(fireImmediately: true);

      case SavedGameFilterTag.date:
        yield* query.anyDateSaved().watch(fireImmediately: true);

      case SavedGameFilterTag.playtime:
        yield* query.anyPlayTime().watch(fireImmediately: true);

      case SavedGameFilterTag.platform:
        yield* isar.savedGames.where().watch(fireImmediately: true);
    }
  }

  Future<List<SavedGame?>> getSavedGames() async {
    final isar = await db;
    return await isar.savedGames.filter().gameIdIsNotNull().findAll();
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

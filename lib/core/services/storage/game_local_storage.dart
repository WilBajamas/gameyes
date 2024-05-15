import 'dart:async';

import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/isar_local_storage_service.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

@injectable
class GameLocalStorageService extends IsarLocalStorageService {
  Future<void> insertGame(SavedGame game) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.savedGames.put(game));
  }

  Future<void> insertTask(Task task) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.tasks.put(task));
  }

  Stream<List<SavedGame>> listenToSavedGames(
    SavedGameFilterTag tag,
    String? searchTerm,
  ) async* {
    final isar = await db;
    final query = isar.savedGames.where(sort: Sort.desc);
    QueryBuilder<SavedGame, SavedGame, QAfterWhere>? tagQuery;

    switch (tag) {
      case SavedGameFilterTag.recentlyChanged:
        tagQuery = query.anyDateModified();
      case SavedGameFilterTag.name:
        tagQuery = query.anyName();

      case SavedGameFilterTag.date:
        tagQuery = query.anyDateSaved();
    }

    if (searchTerm case final term?) {
      yield* tagQuery
          .filter()
          .nameContains(term, caseSensitive: false)
          .watch(fireImmediately: true);
    } else {
      yield* tagQuery.watch(fireImmediately: true);
    }
  }

  Stream<List<SavedGame>> listenToSearchSavedGames(String term) async* {
    final isar = await db;
    final query = isar.savedGames.filter().nameContains(term);
    yield* query.watch();
  }

  Stream<SavedGame?> listenToSavedGameDetail(int savedGameId) async* {
    final isar = await db;
    yield* isar.savedGames.watchObject(savedGameId, fireImmediately: true);
  }

  Stream<Task?> listenToTask(int taskId) async* {
    final isar = await db;
    yield* isar.tasks.watchObject(taskId, fireImmediately: true);
  }

  Future<List<SavedGame?>> getSavedGames() async {
    final isar = await db;
    return await isar.savedGames.filter().gameIdIsNotNull().findAll();
  }

  Future<SavedGame?> getGameById(int gameId) async {
    final isar = await db;
    final existingGame =
        await isar.savedGames.filter().gameIdEqualTo(gameId).findFirst();

    return existingGame;
  }

  Future<SavedGame?> getSavedGame(int id) async {
    final isar = await db;
    return await isar.savedGames.get(id);
  }

  Future<void> deleteGame(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.savedGames.delete(id));
  }

  Future<GroupTask?> getGroupTask(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.groupTasks.get(id));
  }

  Future<Task?> getTask(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.tasks.get(id));
  }

  Future<void> addPlatform(
    GamePlatform platform,
    SavedGame game,
  ) async {
    final List<GamePlatform> platforms = game.platforms ?? [];

    platforms.add(platform);
    game.platforms = platforms;
    await insertGame(game);
  }

  Future<void> removePlatform(
    GamePlatform platform,
    SavedGame game,
  ) async {
    game.platforms!.remove(platform);
    await insertGame(game);
  }

  Future<void> createGroupTask(
    GroupTask groupTaskToSave,
    SavedGame game,
  ) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.groupTasks.put(groupTaskToSave);
      game.groupTasks.add(groupTaskToSave);
      game.groupTasks.save();
    });

    await insertGame(game);
  }

  Future<void> removeGroupTask(int savedGameId, int groupTaskId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.groupTasks.delete(groupTaskId);
    });

    final savedGame = await getSavedGame(savedGameId);

    await insertGame(savedGame!);
  }

  Future<void> createTaskInGroup(
    int groupTaskId,
    int savedGameId,
    Task taskToCreate,
  ) async {
    final isar = await db;
    final groupTask = await getGroupTask(groupTaskId);

    await isar.writeTxn(() async {
      await isar.tasks.put(taskToCreate);
      groupTask!.tasks.add(taskToCreate);
      groupTask.tasks.save();
    });
    final savedGame = await getSavedGame(savedGameId);

    await insertGame(savedGame!);
  }

  Future<void> addStep(int taskId, int savedGameId, TaskStep stepToAdd) async {
    final task = await getTask(taskId);

    final List<TaskStep> steps = task!.steps ?? [];
    steps.add(stepToAdd);
    task.steps = steps;

    final savedGame = await getSavedGame(savedGameId);

    await insertTask(task);
    await insertGame(savedGame!);
  }
}

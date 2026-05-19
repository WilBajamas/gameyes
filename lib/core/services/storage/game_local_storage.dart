import 'dart:async';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/isar_local_storage_service.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@injectable
class GameLocalStorageService extends IsarLocalStorageService {
  Future<void> insertGame(SavedGame game) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.savedGames.put(game));
  }

  Future<void> insertTask(SavedGameTask task) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.savedGameTasks.put(task));
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

  Stream<SavedGameTask?> listenToTask(int taskId) async* {
    final isar = await db;
    yield* isar.savedGameTasks.watchObject(taskId, fireImmediately: true);
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

  Future<SavedGameTask?> getTask(int id) async {
    final isar = await db;
    return await isar.writeTxn(() async => isar.savedGameTasks.get(id));
  }

  Future<void> addPlatform(
    PlatformEntity platform,
    SavedGame game,
  ) async {
    final List<SavedGamePlatform> platforms = game.platforms ?? [];

    platforms.add(SavedGamePlatform(
      id: platform.id,
      name: platform.name,
      abbreviation: platform.abbreviation,
      logoUrl: platform.platformLogo?.url,
    ));
    game.platforms = platforms;
    await insertGame(game);
  }

  Future<void> removePlatform(
    PlatformEntity platform,
    SavedGame game,
  ) async {
    game.platforms?.removeWhere((p) => p.id == platform.id);
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
    SavedGameTask taskToCreate,
  ) async {
    final isar = await db;
    final groupTask = await getGroupTask(groupTaskId);

    await isar.writeTxn(() async {
      await isar.savedGameTasks.put(taskToCreate);
      groupTask!.tasks.add(taskToCreate);
      groupTask.tasks.save();
    });
    final savedGame = await getSavedGame(savedGameId);

    await insertGame(savedGame!);
  }

  Future<void> addStep(int taskId, TaskStep stepToAdd) async {
    final task = await getTask(taskId);
    final savedGameId = task!.groupTask.value!.savedGame.value!.id;

    final List<TaskStep> steps =
        task.steps?.toList(growable: true) ?? List.empty(growable: true);
    steps.add(stepToAdd);
    task.steps = steps;

    final savedGame = await getSavedGame(savedGameId);

    await insertTask(task);
    await insertGame(savedGame!);
  }

  Future<bool> removeStep(
    int taskId,
    TaskStep stepToRemove,
  ) async {
    try {
      final task = await getTask(taskId);
      final savedGameId = task!.groupTask.value!.savedGame.value!.id;

      final currentSteps = task.steps!.toList(growable: true);
      currentSteps.removeWhere((s) => s.id == stepToRemove.id);
      task.steps = currentSteps;
      await insertTask(task);

      final savedGame = await getSavedGame(savedGameId);

      await insertGame(savedGame!);
      return true;
    } catch (exception) {
      return false;
    }
  }

  Future<TaskStep> getTaskStep(String stepId, int taskId) async {
    final task = await getTask(taskId);
    return task!.steps!.firstWhere((s) => s.id == stepId);
  }

  Future<void> editStep(
    int taskId,
    String stepId,
    TaskStep stepToEdit,
  ) async {
    final task = await getTask(taskId);
    final savedGameId = task!.groupTask.value!.savedGame.value!.id;

    final currentSteps = task.steps!.toList(growable: true);
    final toEditIndex = currentSteps.indexWhere((s) => s.id == stepToEdit.id);
    currentSteps[toEditIndex] = stepToEdit;
    task.steps = currentSteps;
    await insertTask(task);

    final savedGame = await getSavedGame(savedGameId);
    await insertGame(savedGame!);
  }

  Future<void> changeCurrentStep(int taskId, int stepIndex) async {
    final task = await getTask(taskId);
    final savedGameId = task!.groupTask.value!.savedGame.value!.id;

    task.currentStepIndex = stepIndex;
    await insertTask(task);

    final savedGame = await getSavedGame(savedGameId);
    await insertGame(savedGame!);
  }
}

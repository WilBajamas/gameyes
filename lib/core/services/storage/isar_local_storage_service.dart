import 'package:gaming_library_assessment_flutter/core/services/storage/i_local_storage.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarLocalStorageService implements ILocalStorage {
  late Future<Isar> db;

  IsarLocalStorageService() {
    // Ensure we're getting an existing Isar instance
    db = openDb();
  }

  @override
  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();

      //* Set schemas here
      return await Isar.open(
        [SavedGameSchema, GroupTaskSchema, TaskSchema],
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  // Removes everything from database - good for a "clear all" function in app
  void clearDb() async {
    final isar = await db;
    await isar.writeTxn(() async => isar.clear());
  }
}

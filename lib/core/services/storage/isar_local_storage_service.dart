import 'package:gaming_library_assessment_flutter/core/services/storage/i_local_storage.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/play_session_log.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarLocalStorageService implements ILocalStorage {
  late final Future<Isar> _db;

  Future<Isar> get dbInstance => _db;

  IsarLocalStorageService() {
    // Ensure we're getting an existing Isar instance
    _db = openDb();
  }

  @override
  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();

      //* Set schemas here
      return await Isar.open(
        [
          SavedGameSchema,
          GroupTaskSchema,
          SavedGameTaskSchema,
          PlaySessionLogSchema,
        ],
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  // Removes everything from database - good for a "clear all" function in app
  void clearDb() async {
    final isar = await _db;
    await isar.writeTxn(() async => isar.clear());
  }
}

import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:isar/isar.dart';

part 'saved_game.g.dart';

@collection
class SavedGame {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false, type: IndexType.value)
  String? name;

  String? imageUrl;

  int? gameId;

  String? gameSlug;

  @Index()
  DateTime? dateSaved;

  @Index(type: IndexType.value)
  String? playTime;

  bool completed = false;

  @enumerated
  List<GamePlatform>? platforms;

  final groupTasks = IsarLinks<GroupTask>();

  @Index()
  DateTime? dateModified;
}

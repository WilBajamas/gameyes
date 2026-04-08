import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:isar_community/isar.dart';

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

  bool completed = false;

  @enumerated
  List<GamePlatform>? platforms;

  final groupTasks = IsarLinks<GroupTask>();

  @Index()
  DateTime? dateModified;

  SavedGame({
    this.name,
    this.imageUrl,
    this.gameId,
    this.gameSlug,
    this.dateSaved,
    this.dateModified,
    this.platforms,
  });
}

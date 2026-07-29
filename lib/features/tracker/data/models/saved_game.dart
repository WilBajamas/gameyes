import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_logo_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/group_task.dart';
import 'package:isar_community/isar.dart';

part 'saved_game.g.dart';

@embedded
class SavedGamePlatform {
  int? id;
  String? name;
  String? abbreviation;
  String? logoUrl;

  SavedGamePlatform({
    this.id,
    this.name,
    this.abbreviation,
    this.logoUrl,
  });
}

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

  List<SavedGamePlatform>? platforms;

  List<SavedGamePlatform>? availablePlatforms;

  final groupTasks = IsarLinks<GroupTask>();

  @Index()
  DateTime? dateModified;

  String? status;
  double? hoursLogged;
  double? averageCompletionHours;
  double? manualProgressPercentage;
  bool isWishlisted = false;
  List<int>? genres;

  SavedGame({
    this.name,
    this.imageUrl,
    this.gameId,
    this.gameSlug,
    this.dateSaved,
    this.dateModified,
    this.platforms,
    this.availablePlatforms,
    this.status,
    this.hoursLogged,
    this.averageCompletionHours,
    this.manualProgressPercentage,
    this.isWishlisted = false,
    this.genres,
  });

  TrackerSavedGameEntity toEntity() => TrackerSavedGameEntity(
        id: id,
        name: name,
        imageUrl: imageUrl,
        gameId: gameId,
        gameSlug: gameSlug,
        dateSaved: dateSaved,
        completed: completed,
        platforms: platforms
                ?.map(
                  (p) => PlatformEntity(
                    id: p.id ?? 0,
                    name: p.name ?? '',
                    abbreviation: p.abbreviation ?? '',
                    platformLogo: p.logoUrl != null
                        ? PlatformLogoEntity(url: p.logoUrl)
                        : null,
                  ),
                )
                .toList() ??
            [],
        availablePlatforms: availablePlatforms
                ?.map(
                  (p) => PlatformEntity(
                    id: p.id ?? 0,
                    name: p.name ?? '',
                    abbreviation: p.abbreviation ?? '',
                    platformLogo: p.logoUrl != null
                        ? PlatformLogoEntity(url: p.logoUrl)
                        : null,
                  ),
                )
                .toList() ??
            [],
        dateModified: dateModified,
        groupTasks: groupTasks.map((e) => e.toEntity()).toList(),
      );
}

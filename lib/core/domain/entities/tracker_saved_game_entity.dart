import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'tracker_group_task_entity.dart';

part 'tracker_saved_game_entity.freezed.dart';

@freezed
sealed class TrackerSavedGameEntity with _$TrackerSavedGameEntity {
  const factory TrackerSavedGameEntity({
    required int id,
    String? name,
    String? imageUrl,
    int? gameId,
    String? gameSlug,
    DateTime? dateSaved,
    @Default(false) bool completed,
    List<GamePlatform>? platforms,
    DateTime? dateModified,
    @Default([]) List<TrackerGroupTaskEntity> groupTasks,
  }) = _TrackerSavedGameEntity;
}

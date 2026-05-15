import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_keyword_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_mode_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/release_date_entity.dart';

part 'game_entity.freezed.dart';

@freezed
sealed class GameEntity with _$GameEntity {
  const GameEntity._();

  const factory GameEntity({
    required int id,
    required String name,
    required GameCoverEntity cover,
    List<GameModeEntity>? gameModes,
    List<GameKeywordEntity>? gameKeywords,
    List<PlatformEntity>? platforms,
    List<ReleaseDateEntity>? releaseDates,
  }) = _GameEntity;
}

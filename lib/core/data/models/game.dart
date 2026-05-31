import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game_cover.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game_keyword.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game_mode.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/platform.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';

import '../../domain/entities/game_entity.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
sealed class Game with _$Game {
  const Game._();

  const factory Game({
    int? id,
    String? name,
    GameCover? cover,
    @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
    List<GameKeyword>? keywords,
    List<Platform>? platforms,
    @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates,
    @JsonKey(name: 'total_rating') double? criticScore,
    int? hypes,
    List<int>? genres,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  GameEntity toEntity() => GameEntity(
        id: id ?? 0,
        name: name ?? '',
        cover: cover?.toEntity() ?? const GameCoverEntity(),
        gameModes: gameModes?.map((e) => e.toEntity()).toList(),
        gameKeywords: keywords?.map((e) => e.toEntity()).toList(),
        platforms: platforms?.map((e) => e.toEntity()).toList(),
        releaseDates: releaseDates?.map((e) => e.toEntity()).toList(),
        criticScore: criticScore,
        hypes: hypes,
        genreIds: genres,
      );
}

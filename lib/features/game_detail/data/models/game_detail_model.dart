import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game_cover.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game_keyword.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game_mode.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/platform.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_detail_entity.dart';

part 'game_detail_model.freezed.dart';
part 'game_detail_model.g.dart';

@freezed
sealed class GameDetailModel with _$GameDetailModel {
  const GameDetailModel._();

  const factory GameDetailModel({
    int? id,
    String? name,
    String? summary,
    GameCover? cover,
    @JsonKey(name: 'game_modes') List<GameMode>? gameModes,
    List<GameKeyword>? keywords,
    List<Platform>? platforms,
    @JsonKey(name: 'release_dates') List<ReleaseDate>? releaseDates,
  }) = _GameDetailModel;

  factory GameDetailModel.fromJson(Map<String, dynamic> json) =>
      _$GameDetailModelFromJson(json);

  GameDetailEntity toEntity() => GameDetailEntity(
    id: id ?? 0,
    name: name ?? 'Unknown',
    description: summary,
    imageUrl: cover?.url,
    platforms: platforms?.map((p) => p.toEntity()).toList(),
    genres: [],
    developers: [],
  );
}

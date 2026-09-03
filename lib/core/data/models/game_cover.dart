import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

part 'game_cover.freezed.dart';
part 'game_cover.g.dart';

@freezed
sealed class GameCover with _$GameCover {
  const factory GameCover({@JsonKey(name: 'url') String? url}) = _GameCover;

  const GameCover._();

  factory GameCover.fromJson(Map<String, dynamic> json) =>
      _$GameCoverFromJson(json);

  GameCoverEntity toEntity() => GameCoverEntity(url: url.toAbsoluteImageUrl());
}

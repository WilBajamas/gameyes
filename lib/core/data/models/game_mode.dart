import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_mode_entity.dart';

part 'game_mode.freezed.dart';
part 'game_mode.g.dart';

@freezed
sealed class GameMode with _$GameMode {
  const GameMode._();

  const factory GameMode({
    int? id,
    String? name,
  }) = _GameMode;

  factory GameMode.fromJson(Map<String, dynamic> json) =>
      _$GameModeFromJson(json);

  GameModeEntity toEntity() => GameModeEntity(
        id: id ?? 0,
        name: name ?? '',
      );
}

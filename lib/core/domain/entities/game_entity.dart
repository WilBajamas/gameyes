import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';

part 'game_entity.freezed.dart';

@freezed
sealed class GameEntity with _$GameEntity {
  const GameEntity._();

  const factory GameEntity({
    required int id,
    String? name,
    String? slug,
    String? releaseDate,
    String? imageUrl,
    int? metacritic,
    List<GamePlatform>? platforms,
  }) = _GameEntity;

  bool get isHighlyRated => (metacritic ?? 0) >= 80;
}

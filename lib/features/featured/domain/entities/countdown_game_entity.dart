import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';

part 'countdown_game_entity.freezed.dart';

@freezed
sealed class CountdownGameEntity with _$CountdownGameEntity {
  const factory CountdownGameEntity({
    required GameEntity? game,
    required bool isWishlisted,
  }) = _CountdownGameEntity;
}

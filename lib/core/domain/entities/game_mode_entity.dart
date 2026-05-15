import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_mode_entity.freezed.dart';

@freezed
sealed class GameModeEntity with _$GameModeEntity {
  const factory GameModeEntity({
    required int id,
    required String name,
  }) = _GameModeEntity;
}

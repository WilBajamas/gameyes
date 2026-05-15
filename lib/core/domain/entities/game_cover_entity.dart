import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_cover_entity.freezed.dart';

@freezed
sealed class GameCoverEntity with _$GameCoverEntity {
  const factory GameCoverEntity({
    String? url,
  }) = _GameCoverEntity;
}

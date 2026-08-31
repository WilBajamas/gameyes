import 'package:freezed_annotation/freezed_annotation.dart';

part 'now_playing_game_entity.freezed.dart';

@freezed
sealed class NowPlayingGameEntity with _$NowPlayingGameEntity {
  const factory NowPlayingGameEntity({
    required String title,
    String? coverUrl,
    double? progressPercent,
    double? playtimeHours,
    // Nothing writes this yet: library_entries has no average-completion
    // column, so the card's middle progress branch cannot fire.
    double? averageCompletionHours,
  }) = _NowPlayingGameEntity;
}

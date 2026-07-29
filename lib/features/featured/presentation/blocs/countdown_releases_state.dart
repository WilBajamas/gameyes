import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';

part 'countdown_releases_state.freezed.dart';

enum CountdownReleasesStatus { initial, loading, success, failed }

@freezed
sealed class CountdownReleasesState with _$CountdownReleasesState {
  const factory CountdownReleasesState({
    @Default(CountdownReleasesStatus.initial) CountdownReleasesStatus status,
    GameEntity? countdownGame,
    @Default(<GameEntity>[]) List<GameEntity> outThisWeekGames,
    Duration? durationRemaining,
    @Default(false) bool isReleaseDay,
    String? errorMessage,
    @Default(false) bool isComingSoonLabel,
  }) = _CountdownReleasesState;
}


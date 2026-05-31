import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/repositories/featured_revamp_repository.dart';

part 'critics_grid_state.freezed.dart';

enum CriticsGridStatus { initial, loading, success, failed }

@freezed
sealed class CriticsGridState with _$CriticsGridState {
  const factory CriticsGridState({
    @Default(CriticsGridStatus.initial) CriticsGridStatus status,
    @Default(<GameEntity>[]) List<GameEntity> criticsGames,
    GenrePreferencesEntity? genrePreferencesEntity,
    String? errorMessage,
  }) = _CriticsGridState;
}

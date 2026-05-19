import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_detail_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';

part 'game_detail_state.freezed.dart';

enum GameDetailStatus { loading, success, failed }

@freezed
sealed class GameDetailState with _$GameDetailState {
  const factory GameDetailState({
    GameDetailStatus? status,
    GameDetailEntity? game,
    ErrorType? error,
    @Default(false) bool contentExpanded,
    SavedGame? savedGame,
  }) = _GameDetailState;
}

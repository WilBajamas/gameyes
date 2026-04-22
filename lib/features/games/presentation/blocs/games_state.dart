import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubits/filter_state.dart';

part 'games_state.freezed.dart';

enum GamesStatus { initial, success, failed, empty, loading }

enum GamesNextPageStatus { initial, failed, loading }

@freezed
sealed class GamesState with _$GamesState {
  const factory GamesState({
    @Default(GamesStatus.initial) GamesStatus status,
    @Default(GamesNextPageStatus.initial) GamesNextPageStatus? nextPageStatus,
    GameListEntity? response,
    @Default(<GameEntity>[]) List<GameEntity> games,
    ErrorType? error,
    ErrorType? nextPageError,
    @Default(FilterState()) FilterState filterState,
  }) = _GamesState;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubits/filter_state.dart';

part 'games_state.freezed.dart';

enum GamesStatus { initial, success, failed, empty, loading }

enum GamesNextPageStatus { initial, failed, loading }

@freezed
sealed class GamesState with _$GamesState {
  const factory GamesState({
    @Default(GamesStatus.initial) GamesStatus status,
    @Default(GamesNextPageStatus.initial) GamesNextPageStatus? nextPageStatus,
    GamesResponse? response,
    @Default(<Game>[]) List<Game> games,
    ErrorType? error,
    ErrorType? nextPageError,
    @Default(FilterState()) FilterState filterState,
  }) = _GamesState;
}

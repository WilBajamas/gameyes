import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_screenshot_entity.dart';

part 'game_screenshot_state.freezed.dart';

enum ScreenshotsStatus { loading, success, failure }

@freezed
sealed class GameScreenshotState with _$GameScreenshotState {
  const factory GameScreenshotState({
    @Default(ScreenshotsStatus.loading) ScreenshotsStatus status,
    GameScreenshotEntity? response,
    ErrorType? error,
  }) = _GameScreenshotState;
}

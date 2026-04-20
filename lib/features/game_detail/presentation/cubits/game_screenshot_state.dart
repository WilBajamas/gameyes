import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';

part 'game_screenshot_state.freezed.dart';

enum ScreenshotsStatus { loading, success, failure }

@freezed
sealed class GameScreenshotState with _$GameScreenshotState {
  const factory GameScreenshotState({
    @Default(ScreenshotsStatus.loading) ScreenshotsStatus status,
    ScreenshotResponse? response,
    ErrorType? error,
  }) = _GameScreenshotState;
}

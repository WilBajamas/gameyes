part of 'game_screenshot_cubit.dart';

enum ScreenshotsStatus { loading, success, failure }

final class GameScreenshotState extends Equatable {
  final ScreenshotsStatus status;
  final ScreenshotResponse? response;
  final ErrorType? error;

  const GameScreenshotState({
    this.status = ScreenshotsStatus.loading,
    this.response,
    this.error,
  });

  GameScreenshotState copyWith({
    ScreenshotsStatus? status,
    ScreenshotResponse? response,
    ErrorType? error,
  }) =>
      GameScreenshotState(
        status: status ?? this.status,
        response: response ?? this.response,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, response, error];
}

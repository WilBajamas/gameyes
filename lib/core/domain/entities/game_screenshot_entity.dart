import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_screenshot_entity.freezed.dart';

@freezed
sealed class GameScreenshotEntity with _$GameScreenshotEntity {
  const factory GameScreenshotEntity({
    @Default([]) List<String> imageUrls,
  }) = _GameScreenshotEntity;
}

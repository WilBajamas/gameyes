import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot.dart';

part 'screenshot_response.freezed.dart';
part 'screenshot_response.g.dart';

@freezed
sealed class ScreenshotResponse with _$ScreenshotResponse {
  const ScreenshotResponse._();

  const factory ScreenshotResponse({
    required List<Screenshot> results,
  }) = _ScreenshotResponse;

  List<String?> get imageUrls =>
      results.map((element) => element.image).toList();

  factory ScreenshotResponse.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotResponseFromJson(json);
}

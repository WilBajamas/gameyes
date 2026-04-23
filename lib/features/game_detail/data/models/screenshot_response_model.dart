import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_screenshot_entity.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot.dart';

part 'screenshot_response_model.freezed.dart';
part 'screenshot_response_model.g.dart';

@freezed
sealed class ScreenshotResponseModel with _$ScreenshotResponseModel {
  const ScreenshotResponseModel._();

  const factory ScreenshotResponseModel({
    required List<Screenshot> results,
  }) = _ScreenshotResponseModel;

  factory ScreenshotResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotResponseModelFromJson(json);

  GameScreenshotEntity toEntity() => GameScreenshotEntity(
        imageUrls: results
            .map((e) => e.image)
            .whereType<String>()
            .toList(),
      );
}

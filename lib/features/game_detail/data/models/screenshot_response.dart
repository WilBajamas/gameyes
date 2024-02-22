import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot.dart';

part 'screenshot_response.g.dart';

@JsonSerializable()
final class ScreenshotResponse extends Equatable {
  final List<Screenshot> results;

  List<String?> get imageUrls =>
      results.map((element) => element.image).toList();

  factory ScreenshotResponse.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotResponseFromJson(json);

  const ScreenshotResponse(this.results);

  Map<String, dynamic> toJson() => _$ScreenshotResponseToJson(this);

  @override
  List<Object?> get props => [results];
}

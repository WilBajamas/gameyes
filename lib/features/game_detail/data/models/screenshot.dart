import 'package:freezed_annotation/freezed_annotation.dart';

part 'screenshot.freezed.dart';
part 'screenshot.g.dart';

@freezed
sealed class Screenshot with _$Screenshot {
  const factory Screenshot({String? image}) = _Screenshot;

  factory Screenshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotFromJson(json);
}

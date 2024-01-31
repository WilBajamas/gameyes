import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'screenshot.g.dart';

@JsonSerializable()
final class Screenshot extends Equatable {
  final String? image;

  factory Screenshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotFromJson(json);

  const Screenshot(this.image);

  Map<String, dynamic> toJson() => _$ScreenshotToJson(this);

  @override
  List<Object?> get props => [image];
}

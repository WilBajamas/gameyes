import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform.freezed.dart';
part 'platform.g.dart';

@freezed
sealed class Platform with _$Platform {
  const Platform._();

  const factory Platform({
    int? id,
    String? name,
  }) = _Platform;

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);
}

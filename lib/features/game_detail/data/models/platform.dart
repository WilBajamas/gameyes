import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';

part 'platform.freezed.dart';
part 'platform.g.dart';

@freezed
sealed class Platform with _$Platform {
  const Platform._();

  const factory Platform({
    int? id,
    String? name,
  }) = _Platform;

  GamePlatform? get value {
    final platformsContainsId =
        GamePlatform.values.where((p) => p.ids.contains(id)).toList();

    if (platformsContainsId.isNotEmpty) {
      return platformsContainsId.firstWhere((_) => true);
    }

    return null;
  }

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);
}

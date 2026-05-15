import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/platform_logo.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';

part 'platform.freezed.dart';
part 'platform.g.dart';

@freezed
sealed class Platform with _$Platform {
  const Platform._();

  const factory Platform({
    int? id,
    String? name,
    String? abbreviation,
    @JsonKey(name: 'platform_logo') PlatformLogo? platformLogo,
  }) = _Platform;

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  PlatformEntity toEntity() => PlatformEntity(
        id: id ?? 0,
        name: name ?? '',
        abbreviation: abbreviation ?? '',
        platformLogo: platformLogo?.toEntity(),
      );
}

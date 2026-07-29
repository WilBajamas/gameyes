import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_logo_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

part 'platform_logo.freezed.dart';
part 'platform_logo.g.dart';

@freezed
sealed class PlatformLogo with _$PlatformLogo {
  const PlatformLogo._();

  const factory PlatformLogo({
    String? url,
  }) = _PlatformLogo;

  factory PlatformLogo.fromJson(Map<String, dynamic> json) =>
      _$PlatformLogoFromJson(json);

  PlatformLogoEntity toEntity() => PlatformLogoEntity(
        url: url.toAbsoluteImageUrl(),
      );
}


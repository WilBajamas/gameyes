import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_logo_entity.dart';

part 'platform_entity.freezed.dart';

@freezed
sealed class PlatformEntity with _$PlatformEntity {
  const factory PlatformEntity({
    required int id,
    required String name,
    required String abbreviation,
    PlatformLogoEntity? platformLogo,
  }) = _PlatformEntity;
}

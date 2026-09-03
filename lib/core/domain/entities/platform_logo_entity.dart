import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform_logo_entity.freezed.dart';

@freezed
sealed class PlatformLogoEntity with _$PlatformLogoEntity {
  const factory PlatformLogoEntity({String? url}) = _PlatformLogoEntity;
}

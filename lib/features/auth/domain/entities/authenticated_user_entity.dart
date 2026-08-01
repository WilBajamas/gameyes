import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';

part 'authenticated_user_entity.freezed.dart';

@freezed
sealed class AuthenticatedUserEntity with _$AuthenticatedUserEntity {
  const factory AuthenticatedUserEntity({
    required String id,
    SignInProvider? provider,
    String? email,
    String? displayName,
    String? avatarUrl,
  }) = _AuthenticatedUserEntity;
}

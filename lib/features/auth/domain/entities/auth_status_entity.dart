import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/authenticated_user_entity.dart';

part 'auth_status_entity.freezed.dart';

@freezed
sealed class AuthStatusEntity with _$AuthStatusEntity {
  const factory AuthStatusEntity.signedIn(AuthenticatedUserEntity user) =
      AuthSignedIn;
  const factory AuthStatusEntity.signedOut() = AuthSignedOut;
}

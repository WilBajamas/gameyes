import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/authenticated_user_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension AuthenticatedUserMapper on User {
  AuthenticatedUserEntity toEntity() {
    final details = userMetadata ?? const <String, dynamic>{};
    return AuthenticatedUserEntity(
      id: id,
      email: email,
      displayName: (details['full_name'] ?? details['name']) as String?,
      avatarUrl: details['avatar_url'] as String?,
      provider: SignInProvider.fromName(
        appMetadata['provider'] as String?,
      ),
    );
  }
}

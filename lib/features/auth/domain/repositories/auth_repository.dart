import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';

abstract interface class AuthRepository {
  Future<Result<void>> signIn(SignInProvider provider);

  Future<Result<void>> signOut();

  Stream<AuthStatusEntity> get authStatusChanges;
}

import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call(SignInProvider provider) =>
      _repository.signIn(provider);
}

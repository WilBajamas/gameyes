import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ObserveAuthStatusUseCase {
  const ObserveAuthStatusUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthStatusEntity> call() => _repository.authStatusChanges;
}

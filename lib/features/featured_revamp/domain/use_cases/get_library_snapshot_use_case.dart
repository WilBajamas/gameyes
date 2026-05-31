import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/repositories/featured_revamp_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLibrarySnapshotUseCase {
  final FeaturedRevampRepository _repository;

  GetLibrarySnapshotUseCase(this._repository);

  Future<Result<LibrarySnapshotEntity>> call() async =>
      _repository.getLibrarySnapshot();
}

import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLibrarySnapshotUseCase {
  final FeaturedRepository _repository;

  GetLibrarySnapshotUseCase(this._repository);

  Future<Result<LibrarySnapshotEntity>> call() async =>
      _repository.getLibrarySnapshot();
}

import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_counts_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchLibraryCountsUseCase {
  const FetchLibraryCountsUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryCountsEntity>> call() => _repository.fetchCounts();
}

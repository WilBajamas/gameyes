import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveGenrePreferencesUseCase {
  final FeaturedRepository _repository;

  SaveGenrePreferencesUseCase(this._repository);

  Future<Result<void>> call(
    List<int> genreIds, {
    required bool isSkipped,
  }) async =>
      _repository.saveGenrePreferences(genreIds, isSkipped);
}

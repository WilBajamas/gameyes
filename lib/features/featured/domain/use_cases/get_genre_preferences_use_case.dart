import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGenrePreferencesUseCase {
  final FeaturedRepository _repository;

  GetGenrePreferencesUseCase(this._repository);

  Future<Result<GenrePreferencesEntity>> call() async =>
      _repository.getGenrePreferences();
}

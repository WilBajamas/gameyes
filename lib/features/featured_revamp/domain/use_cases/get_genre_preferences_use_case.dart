import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/repositories/featured_revamp_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGenrePreferencesUseCase {
  final FeaturedRevampRepository _repository;

  GetGenrePreferencesUseCase(this._repository);

  Future<Result<GenrePreferencesEntity>> call() async =>
      _repository.getGenrePreferences();
}

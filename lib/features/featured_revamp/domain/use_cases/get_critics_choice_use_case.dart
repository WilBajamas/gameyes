import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/repositories/featured_revamp_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCriticsChoiceUseCase {
  final FeaturedRevampRepository _repository;

  GetCriticsChoiceUseCase(this._repository);

  Future<Result<List<GameEntity>>> call(
    List<int> genrePreferences,
  ) async =>
      _repository.getCriticsChoiceGames(genrePreferences);
}

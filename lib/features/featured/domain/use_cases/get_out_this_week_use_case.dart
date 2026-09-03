import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOutThisWeekUseCase {
  final FeaturedRepository _repository;

  GetOutThisWeekUseCase(this._repository);

  Future<Result<List<GameEntity>>> call({
    required bool forceExtendWindow,
  }) async => _repository.getOutThisWeekGames(forceExtendWindow);
}

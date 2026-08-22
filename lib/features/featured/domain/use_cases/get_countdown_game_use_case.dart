import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCountdownGameUseCase {
  final FeaturedRepository _repository;

  GetCountdownGameUseCase(this._repository);

  Future<Result<CountdownGameEntity>> call() async =>
      _repository.getCountdownGame();
}

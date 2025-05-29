import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GamesRepository)
class GamesRepositoryImpl implements GamesRepository {
  final GamesDataSource _gamesDatasource;

  const GamesRepositoryImpl(this._gamesDatasource);

  @override
  Future<Either<ErrorType, GamesResponse>> fetchGames({
    int page = 1,
    String? searchTerm,
    String? dateRange,
    String? ordering,
    String? platforms,
    String? genres,
  }) async =>
      _gamesDatasource.fetchDatasourceGames(
        page: page,
        searchTerm: searchTerm,
        dateRange: dateRange,
        orderings: ordering,
        platforms: platforms,
        genres: genres,
      );
}

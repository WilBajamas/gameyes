import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasources/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/repositories/games_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GamesRepository)
class GamesRepositoryImpl with BaseRepositoryMixin implements GamesRepository {
  final GamesDataSource _gamesDatasource;

  const GamesRepositoryImpl(this._gamesDatasource);

  @override
  Future<Result<GamesResponse>> fetchGames({
    int page = 1,
    String? searchTerm,
    String? dateRange,
    String? ordering,
    String? platforms,
    String? genres,
  }) async =>
      fetchData(
        apiCall: _gamesDatasource.fetchDatasourceGames(
          page: page,
          searchTerm: searchTerm,
          dateRange: dateRange,
          orderings: ordering,
          platforms: platforms,
          genres: genres,
        ),
      );
}

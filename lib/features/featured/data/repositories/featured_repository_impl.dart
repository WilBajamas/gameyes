import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasources/games_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeaturedRepository)
class FeaturedRepositoryImpl
    with BaseRepositoryMixin
    implements FeaturedRepository {
  final GamesDataSource _gamesDatasource;

  FeaturedRepositoryImpl(this._gamesDatasource);

  @override
  Future<Result<GameListEntity>> fetchGames({
    required int page,
    String? dateRange,
    String? orderings,
    String? platforms,
  }) async {
    final result = await fetchData<GamesModel>(
      apiCall: _gamesDatasource.fetchDatasourceGames(
        page: page,
        dateRange: dateRange,
        orderings: orderings,
        platforms: platforms,
      ),
    );

    return result.map((model) => model.toEntity());
  }
}

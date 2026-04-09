import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeaturedRepository)
class FeaturedRepositoryImpl implements FeaturedRepository {
  final GamesDataSource _gamesDatasource;

  FeaturedRepositoryImpl(this._gamesDatasource);

  @override
  Future<Either<ErrorType, GamesResponse>> fetchGames({
    required int page,
    String? dateRange,
    String? orderings,
    String? platforms,
  }) =>
      _gamesDatasource.fetchDatasourceGames(
        page: page,
        dateRange: dateRange,
        orderings: orderings,
        platforms: platforms,
      );
}

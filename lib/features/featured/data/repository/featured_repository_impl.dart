import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:injectable/injectable.dart';

@Injectable(as: FeaturedRepository)
class FeaturedRepositoryImpl implements FeaturedRepository {
  final _gamesDatasource = injection.getIt<GamesDataSource>();

  @override
  Future<Either<ErrorType, GamesResponse>> fetchBestMetacritic() {
    return _gamesDatasource.fetchGames(
      ordering: GameOrdering.metacritic.name,
      reverseOrder: true,
    );
  }

  @override
  Future<Either<ErrorType, GamesResponse>> fetchLatestReleases() async =>
      _gamesDatasource.fetchGames(
        ordering: GameOrdering.released.name,
        dateFrom: DateTime.now().getFormattedDateMonthsAgo(monthsAgo: 1),
        dateTo: DateTime.now().getFormattedDateMonthsAgo(),
        reverseOrder: true,
      );

  @override
  Future<Either<ErrorType, GamesResponse>> fetchMostAnticipated() =>
      _gamesDatasource.fetchGames(
        dateFrom: DateTime.now().getFormattedDateYearsRange(),
        dateTo:
            DateTime.now().getFormattedDateYearsRange(years: 1, after: true),
        ordering: GameOrdering.added.name,
        reverseOrder: true,
      );
}

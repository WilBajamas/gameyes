import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/games_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GamesRepository)
class GamesRepositoryImpl implements GamesRepository {
  final _gamesDatasource = injection.getIt<GamesDataSource>();

  @override
  Future<Either<ErrorType, GamesResponse>> fetchGames({
    int page = 1,
    String? searchTerm,
    DateTime? dateFrom,
    DateTime? dateTo,
    required GameOrdering ordering,
    required List<GamePlatform> platforms,
  }) {
    List<int> platformNumbers = platforms.map((p) => p.id).toList();

    //! Use [GamePlatfom] (rename)
    // if (platforms.isNotEmpty) {
    //   for (var platform in platforms) {
    //     platformNumbers.addAll(platform.ids);
    //   }
    // }

    // platformNumbers = null;

    return _gamesDatasource.fetchGames(
      page: page,
      pageSize: 20,
      searchTerm: searchTerm,
      dateFrom:
          dateFrom != null ? dateFrom.getFormattedStringFromDateTime()! : '',
      dateTo: dateTo != null ? dateTo.getFormattedStringFromDateTime()! : '',
      ordering: ordering.name,
      reverseOrder: true,
      platforms: platformNumbers,
    );
  }
}

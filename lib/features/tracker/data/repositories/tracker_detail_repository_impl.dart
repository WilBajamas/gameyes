import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackerDetailRepository)
class TrackerDetailRepositoryImpl implements TrackerDetailRepository {
  final _gameLocalDatasource = getIt<GameLocalDatasource>();

  @override
  Future<SavedGame?> setPlatform({
    required GamePlatform platform,
    required int gameId,
  }) =>
      _gameLocalDatasource.setPlatform(
        platform: platform,
        gameId: gameId,
      );

  @override
  Future<SavedGame?> createGroupTask({
    required String title,
    required String description,
    required int id,
  }) =>
      _gameLocalDatasource.createGroupTask(
        title: title,
        description: description,
        id: id,
      );
}

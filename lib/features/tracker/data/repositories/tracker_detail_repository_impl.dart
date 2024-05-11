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
  Future<void> setPlatform({
    required GamePlatform platform,
    required int savedGameId,
  }) =>
      _gameLocalDatasource.setPlatform(
        platform: platform,
        savedGameId: savedGameId,
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

  @override
  Stream<SavedGame?> savedGameDetailStream({required int savedGameId}) =>
      _gameLocalDatasource.listenToSavedGame(savedGameId: savedGameId);

  @override
  Future<void> removeGroupTask({
    required savedGameId,
    required int groupTaskId,
  }) =>
      _gameLocalDatasource.removeGroupTask(
        savedGameId: savedGameId,
        groupTaskId: groupTaskId,
      );
}

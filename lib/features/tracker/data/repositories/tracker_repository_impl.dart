import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackerRepository)
class TrackerRepositoryImpl implements TrackerRepository {
  final _gameLocalDatasource = getIt<GameLocalDatasource>();

  @override
  Future<List<SavedGame?>> getSavedGames() =>
      _gameLocalDatasource.getSavedGames();

  @override
  Stream<List<SavedGame>> savedGamesStream() =>
      _gameLocalDatasource.listenToSavedGames();
}

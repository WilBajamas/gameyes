import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackerRepository)
class TrackerRepositoryImpl implements TrackerRepository {
  final GameLocalDatasource _gameLocalDatasource;

  TrackerRepositoryImpl(this._gameLocalDatasource);

  @override
  Future<List<TrackerSavedGameEntity>> getSavedGames() async {
    final models = await _gameLocalDatasource.getSavedGames();
    return models
        .whereType<SavedGame>()
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Stream<List<TrackerSavedGameEntity>> savedGamesStream(
    SavedGameFilterTag tag,
    String? searchTerm,
  ) => _gameLocalDatasource
      .listenToSavedGames(tag, searchTerm)
      .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Future<void> removeSavedGame(int id) =>
      _gameLocalDatasource.unsaveGame(id: id);

  @override
  Stream<List<TrackerSavedGameEntity>> searchGamesStream(String term) =>
      _gameLocalDatasource
          .listenToSearchSavedGames(term)
          .map((models) => models.map((m) => m.toEntity()).toList());
}

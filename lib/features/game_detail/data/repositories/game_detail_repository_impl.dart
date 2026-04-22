import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_detail_entity.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repositories/game_detail_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GameDetailRepository)
class GameDetailRepositoryImpl
    with BaseRepositoryMixin
    implements GameDetailRepository {
  final GameDetailRemoteDatasource _gameDetailRemoteDatasource;
  final GameLocalDatasource _gameLocalDatasource;

  GameDetailRepositoryImpl(
    this._gameDetailRemoteDatasource,
    this._gameLocalDatasource,
  );

  @override
  Future<Result<GameDetailEntity>> fetchGameDetail({
    required int id,
  }) async {
    final result = await fetchData<GameDetailModel>(
      apiCall: _gameDetailRemoteDatasource.fetchGameDetail(id: id),
    );

    return result.map((model) => model.toEntity());
  }

  @override
  Future<void> saveGame({required SavedGame game}) =>
      _gameLocalDatasource.saveGame(game: game);

  @override
  Future<void> unsaveGame({required int id}) =>
      _gameLocalDatasource.unsaveGame(id: id);

  @override
  Future<SavedGame?> getSavedGame({required int id}) =>
      _gameLocalDatasource.getSavedGame(id: id);
}

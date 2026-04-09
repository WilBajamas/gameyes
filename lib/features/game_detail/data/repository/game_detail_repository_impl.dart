import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/data/datasource/base_datasource_mixin.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_detail_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/game_local_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GameDetailRepository)
class GameDetailRepositoryImpl
    with BaseDatasourceRepositoryMixin<GameDetailResponse>
    implements GameDetailRepository {
  final GameDetailRemoteDatasource _gameDetailRemoteDatasource;
  final GameLocalDatasource _gameLocalDatasource;

  GameDetailRepositoryImpl(
    this._gameDetailRemoteDatasource,
    this._gameLocalDatasource,
  );

  @override
  Future<Either<ErrorType, GameDetailResponse>> fetchGameDetail({
    required int id,
  }) =>
      fetchData(
        apiCall: _gameDetailRemoteDatasource.fetchGameDetail(id: id),
      );

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

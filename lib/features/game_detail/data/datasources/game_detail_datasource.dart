import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';
import 'package:injectable/injectable.dart';

import '../../services/game_detail_service.dart';

@injectable
class GameDetailRemoteDatasource {
  final GameDetailService _gameDetailService;

  GameDetailRemoteDatasource(this._gameDetailService);

  Future<GameDetailModel> fetchGameDetail({
    required int id,
  }) =>
      _gameDetailService.fetchGameDetail(id.toString());
}

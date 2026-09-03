import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/igdb_query_builder.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';
import 'package:injectable/injectable.dart';

import '../../services/game_detail_api_service.dart';

@injectable
class GameDetailRemoteDatasource {
  final GameDetailApiService _gameDetailApiService;

  GameDetailRemoteDatasource(this._gameDetailApiService);

  Future<GameDetailModel> fetchGameDetail({required int id}) async {
    final query = IGDBQueryBuilder()
        .fields(IGDBConfig.standardGameFields)
        .where('id = $id')
        .limit(1)
        .build();

    final response = await _gameDetailApiService.fetchGameDetail(query);

    return response.first;
  }
}

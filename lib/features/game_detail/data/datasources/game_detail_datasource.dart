import 'package:gaming_library_assessment_flutter/core/services/api/retrofit_service.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameDetailRemoteDatasource {
  final RetrofitService _retrofitService;

  GameDetailRemoteDatasource(this._retrofitService);

  Future<GameDetailModel> fetchGameDetail({
    required int id,
  }) =>
      _retrofitService.fetchGameDetail(id.toString());
}

import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameDetailRemoteDatasource {
  final DioService _dioService;

  GameDetailRemoteDatasource(this._dioService);

  Future<GameDetailResponse> fetchGameDetail({
    required int id,
  }) =>
      _dioService.retrofitService.fetchGameDetail(id.toString());
}

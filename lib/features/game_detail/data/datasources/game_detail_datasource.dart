import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameDetailDatasource {
  final _dioService = getIt<DioService>();

  Future<GameDetailResponse> fetchGameDetail({
    required int id,
  }) async =>
      await _dioService.retrofitService.fetchGameDetail(id.toString());
}

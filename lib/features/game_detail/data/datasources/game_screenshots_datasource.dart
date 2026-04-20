import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameScreenshotsDatasource {
  final DioService _dioService;

  GameScreenshotsDatasource(this._dioService);

  Future<ScreenshotResponse> fetchGameScreenshots({
    required int id,
  }) async {
    final response = await _dioService.dio.get(
      '${ConfigConstants.gamesEndpoint}/$id/${ConfigConstants.screenshotsEndpoint}',
    );

    return ScreenshotResponse.fromJson(response.data);
  }
}

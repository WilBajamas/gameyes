import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../services/game_detail_service.dart';

/// TODO: Not used - leaving it here to compile

@injectable
class GameScreenshotsDatasource {
  final GameDetailService _gameDetailService;

  GameScreenshotsDatasource(this._gameDetailService);

  Future<ScreenshotResponseModel> fetchGameScreenshots({required int id}) =>
      _gameDetailService.fetchGameScreenshots(id.toString());
}

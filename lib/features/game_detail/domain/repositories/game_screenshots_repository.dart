import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';

abstract class GameScreenshotsRepository {
  Future<Result<ScreenshotResponse>> fetchGameScreenshots({
    required int id,
  });
}

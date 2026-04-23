import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_screenshot_entity.dart';

abstract class GameScreenshotsRepository {
  Future<Result<GameScreenshotEntity>> fetchGameScreenshots({
    required int id,
  });
}

import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';

abstract class GameScreenshotsRepository {
  Future<Either<ErrorType, ScreenshotResponse>> fetchGameScreenshots({
    required String slug,
  });
}

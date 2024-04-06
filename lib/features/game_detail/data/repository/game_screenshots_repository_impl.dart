import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_screenshots_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_screenshots_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GameScreenshotsRepository)
class GameScreenshotsRepositoryImpl implements GameScreenshotsRepository {
  final _gameScreenshotsDatasource = getIt<GameScreenshotsDatasource>();

  @override
  Future<Either<ErrorType, ScreenshotResponse>> fetchGameScreenshots({
    required int id,
  }) =>
      _gameScreenshotsDatasource.fetchGameScreenshots(id: id);
}

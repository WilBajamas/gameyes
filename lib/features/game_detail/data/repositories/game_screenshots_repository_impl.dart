import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_screenshots_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repositories/game_screenshots_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GameScreenshotsRepository)
class GameScreenshotsRepositoryImpl
    with BaseRepositoryMixin
    implements GameScreenshotsRepository {
  final GameScreenshotsDatasource _gameScreenshotsDatasource;

  GameScreenshotsRepositoryImpl(this._gameScreenshotsDatasource);

  @override
  Future<Result<ScreenshotResponse>> fetchGameScreenshots({
    required int id,
  }) =>
      fetchData(
        apiCall: _gameScreenshotsDatasource.fetchGameScreenshots(id: id),
      );
}

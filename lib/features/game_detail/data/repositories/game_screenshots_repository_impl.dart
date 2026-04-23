import 'package:gaming_library_assessment_flutter/core/data/datasource/base_repository_mixin.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_screenshot_entity.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_screenshots_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response_model.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repositories/game_screenshots_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GameScreenshotsRepository)
class GameScreenshotsRepositoryImpl
    with BaseRepositoryMixin
    implements GameScreenshotsRepository {
  final GameScreenshotsDatasource _gameScreenshotsDatasource;

  GameScreenshotsRepositoryImpl(this._gameScreenshotsDatasource);

  @override
  Future<Result<GameScreenshotEntity>> fetchGameScreenshots({
    required int id,
  }) async {
    final result = await fetchData<ScreenshotResponseModel>(
      apiCall: _gameScreenshotsDatasource.fetchGameScreenshots(id: id),
    );

    return result.map((model) => model.toEntity());
  }
}

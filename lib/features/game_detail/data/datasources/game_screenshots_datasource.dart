import 'package:gaming_library_assessment_flutter/core/services/api/retrofit_service.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameScreenshotsDatasource {
  final RetrofitService _retrofitService;

  GameScreenshotsDatasource(this._retrofitService);

  Future<ScreenshotResponseModel> fetchGameScreenshots({required int id}) =>
      _retrofitService.fetchGameScreenshots(id.toString());
}

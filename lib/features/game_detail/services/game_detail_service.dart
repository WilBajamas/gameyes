import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'game_detail_service.g.dart';

@RestApi(baseUrl: ConfigConstants.igdbBaseUrl)
abstract class GameDetailService {
  factory GameDetailService(Dio dio) = _GameDetailService;

  //* Game details //
  @POST('/games')
  Future<GameDetailModel> fetchGameDetail(
    @Body() String query,
  );

  //* Game detail screenshots //
  @POST(
      '${ConfigConstants.gamesEndpoint}/{id}/${ConfigConstants.screenshotsEndpoint}')
  Future<ScreenshotResponseModel> fetchGameScreenshots(
    @Body() String query,
  );
}

import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:retrofit/http.dart';

part 'games_service.g.dart';

@RestApi(baseUrl: ConfigConstants.igdbBaseUrl)
abstract class GamesServices {
  factory GamesServices(Dio dio) = _GamesServices;

  //* Game list //
  @POST('/games')
  Future<GamesModel> fetchGames(
    @Body() String query,
  );
}

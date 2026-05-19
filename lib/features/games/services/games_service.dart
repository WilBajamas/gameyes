import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:retrofit/retrofit.dart';

part 'games_service.g.dart';

@RestApi(baseUrl: ConfigConstants.igdbBaseUrl)
abstract class GamesServices {
  factory GamesServices(Dio dio) = _GamesServices;

  //* Game list //
  @POST('/games')
  Future<List<Game>> fetchGames(
    @Body() String query,
  );
}

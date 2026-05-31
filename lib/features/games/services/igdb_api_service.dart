import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:retrofit/retrofit.dart';

part 'igdb_api_service.g.dart';

@RestApi(baseUrl: ConfigConstants.igdbBaseUrl)
abstract class IgdbApiService {
  factory IgdbApiService(Dio dio) = _IgdbApiService;

  //* Game list //
  @POST('/games')
  Future<List<Game>> fetchGames(
    @Body() String query,
  );

  //* Release dates //
  @POST('/release_dates')
  Future<List<ReleaseDate>> fetchReleaseDates(
    @Body() String query,
  );
}

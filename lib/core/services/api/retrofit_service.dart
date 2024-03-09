import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:retrofit/http.dart';

part 'retrofit_service.g.dart';

@RestApi(baseUrl: ConfigConstants.baseUrl)
abstract class RetrofitService {
  factory RetrofitService(Dio dio) = _RetrofitService;

  //* Game details //
  @GET('${ConfigConstants.gamesEndpoint}/{id}')
  Future<GameDetailResponse> fetchGameDetail(
    @Path('id') String id,
  );

  //* Game list //
  @GET(ConfigConstants.gamesEndpoint)
  Future<GamesResponse> fetchGames(
    @Query('page') int page,
    @Query('page_size') int pageSize,
    @Query('dates') String? dates,
    @Query('ordering') String? ordering,
    @Query('search') String? search,
    @Query('platforms') String? platforms,
    @Query('genres') String? genres,
  );
}

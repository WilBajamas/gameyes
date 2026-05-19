import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/services/game_detail_service.dart';
import 'package:gaming_library_assessment_flutter/features/games/services/games_service.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../res/const.dart';
import 'twitch_auth_interceptor.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio getDioInstance(TwitchAuthInterceptor interceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ConfigConstants.igdbBaseUrl,
        connectTimeout: ConfigConstants.connectTimeout,
        receiveTimeout: ConfigConstants.receiveTimeout,
        sendTimeout: ConfigConstants.sendTimeout,
      ),
    );

    dio.interceptors.add(interceptor);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    );
    return dio;
  }

  @singleton
  GamesServices getRetrofitService(Dio dio) => GamesServices(dio);

  @singleton
  GameDetailService getGameDetailService(Dio dio) => GameDetailService(dio);
}

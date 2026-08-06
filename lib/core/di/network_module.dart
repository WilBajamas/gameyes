import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../res/const.dart';
import '../services/api/twitch_auth_interceptor.dart';

// Old code, kept only so you can look at it later. Not used by the app.
// It used to also build two services here, but those are gone now.
@Deprecated(
  'Superseded by the igdb-proxy Supabase Edge Function (week 1 item 9). '
  'Kept for reference only -- not registered in DI, not used anywhere.',
)
abstract class NetworkModule {
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
}

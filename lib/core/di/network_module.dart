import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../res/const.dart';
import '../services/api/twitch_auth_interceptor.dart';

// DEPRECATED -- kept for reference only, not wired into DI, not used
// anywhere. Superseded by the igdb-proxy Supabase Edge Function (week 1
// item 9): this built the shared Dio instance for direct-to-IGDB requests
// (with TwitchAuthInterceptor attached) and registered the two Retrofit
// IGDB services. Those two services were deleted in item 9 in favour of
// SupabaseIgdbClient plus a per-feature *ApiService class -- see
// lib/core/services/supabase/ and lib/features/*/services/.
//
// Their provider methods can no longer compile as real code (the types they
// returned were deleted along with this module's old callers), so they're
// kept as a comment showing the original shape rather than dead code
// referencing types that no longer exist:
//
//   @singleton
//   IgdbApiService getIgdbApiService(Dio dio) => IgdbApiService(dio);
//
//   @singleton
//   GameDetailService getGameDetailService(Dio dio) => GameDetailService(dio);
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

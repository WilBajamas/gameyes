import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

// Old code, kept only so you can look at it later. Not used by the app.
// The real client ID and secret are gone, so the two below are fake values.
@Deprecated(
  'Superseded by the igdb-proxy Supabase Edge Function (week 1 item 9). '
  'Kept for reference only -- not registered in DI, not used anywhere.',
)
class TwitchAuthInterceptor extends QueuedInterceptor {
  static const _twitchClientId = 'REMOVED_BY_ITEM_9';
  static const _twitchClientSecret = 'REMOVED_BY_ITEM_9';

  String? _accessToken;
  final Dio _tokenDio;

  TwitchAuthInterceptor()
    : _tokenDio = Dio(
        BaseOptions(
          baseUrl: 'https://id.twitch.tv/oauth2/',
          connectTimeout: ConfigConstants.connectTimeout,
          receiveTimeout: ConfigConstants.receiveTimeout,
          sendTimeout: ConfigConstants.sendTimeout,
        ),
      );

  Future<String?> _fetchToken() async {
    try {
      final response = await _tokenDio.post(
        'token',
        queryParameters: {
          'client_id': _twitchClientId,
          'client_secret': _twitchClientSecret,
          'grant_type': 'client_credentials',
        },
      );
      if (response.statusCode == 200) {
        _accessToken = response.data['access_token'] as String?;
        return _accessToken;
      }
    } catch (e) {
      // Typically log the error in production
    }
    return null;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If we don't have a token, fetch one before continuing
    if (_accessToken == null) {
      await _fetchToken();
    }

    if (_accessToken != null) {
      options.headers['Client-ID'] = _twitchClientId;
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token might be expired, fetch a new one
      final newToken = await _fetchToken();
      if (newToken != null) {
        // Retry the original request
        try {
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newToken';

          // A fresh Dio avoids getting stuck retrying through this same
          // interceptor.
          final retryDio = Dio();
          final response = await retryDio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (retryErr) {
          if (retryErr is DioException) {
            return super.onError(retryErr, handler);
          }
        }
      }
    }
    super.onError(err, handler);
  }
}

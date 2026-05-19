import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/config/config_envied.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@singleton
class TwitchAuthInterceptor extends QueuedInterceptor {
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
        ) {
    _tokenDio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    );
  }

  Future<String?> _fetchToken() async {
    try {
      final response = await _tokenDio.post(
        'token',
        queryParameters: {
          'client_id': Env.twitchClientId,
          'client_secret': Env.twitchClientSecret,
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
      options.headers['Client-ID'] = Env.twitchClientId;
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

          // We need a fresh Dio to retry, otherwise we get stuck in interceptor loops
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

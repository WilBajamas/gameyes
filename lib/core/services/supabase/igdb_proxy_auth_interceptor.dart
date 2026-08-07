import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Signs every igdb-proxy call as the person using the app, and gives a
/// rejected call one more try with a fresh sign-in token.
class IgdbProxyAuthInterceptor extends Interceptor {
  IgdbProxyAuthInterceptor({
    required GoTrueClient auth,
    required String anonKey,
    required Dio dio,
  }) : _auth = auth,
       _anonKey = anonKey,
       _dio = dio;

  // Marks a call we have already tried again, so one rejection can never
  // turn into an endless chain of retries.
  static const _replayedKey = 'igdb_proxy_replayed';

  final GoTrueClient _auth;
  final String _anonKey;
  final Dio _dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Read fresh every time - the token changes while the app is running.
    // With nobody signed in the anon key stands in, which is what the
    // Supabase SDK sends today.
    final token = _auth.currentSession?.accessToken ?? _anonKey;
    options.headers['Authorization'] = 'Bearer $token';
    options.headers['apikey'] = _anonKey;
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final alreadyReplayed = options.extra[_replayedKey] == true;

    if (err.response?.statusCode != 401 || alreadyReplayed) {
      return handler.next(err);
    }

    try {
      final refreshed = await _auth.refreshSession();
      if (refreshed.session == null) return handler.next(err);
    } catch (_) {
      // A refresh we cannot do is not a better answer than the rejection
      // the caller already has.
      return handler.next(err);
    }

    options.extra[_replayedKey] = true;
    try {
      // Back through this same interceptor, which picks up the new token
      // in onRequest.
      handler.resolve(await _dio.fetch<Object?>(options));
    } on DioException catch (replayError) {
      handler.next(replayError);
    }
  }
}

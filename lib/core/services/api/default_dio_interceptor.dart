import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class DefaultDioInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: use envied package to store api key
    options.queryParameters['key'] = '17b1b8cb8a1b4ca3a9dd0b15504a0d02';
    super.onRequest(options, handler);
  }
}

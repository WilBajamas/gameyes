import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/config/config_envied.dart';
import 'package:injectable/injectable.dart';

@injectable
class DefaultDioInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.queryParameters['key'] = Env.apiKey;
    super.onRequest(options, handler);
  }
}

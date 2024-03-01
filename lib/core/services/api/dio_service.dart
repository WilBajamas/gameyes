import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/default_dio_interceptor.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/retrofit_service.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@singleton
class DioService {
  var dio = Dio();

  late final RetrofitService retrofitService;

  final DefaultDioInterceptor _defaultInterceptor =
      getIt<DefaultDioInterceptor>();

  DioService() {
    final options = BaseOptions(
      baseUrl: ConfigConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 5),
    );

    dio.options = options;
    dio.interceptors.add(_defaultInterceptor);
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
      ),
    );

    retrofitService = RetrofitService(dio);
  }
}

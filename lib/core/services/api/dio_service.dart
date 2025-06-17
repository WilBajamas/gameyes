import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/default_dio_interceptor.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/retrofit_service.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@singleton
class DioService {
  final Dio dio;
  late final RetrofitService retrofitService;

  DioService(DefaultDioInterceptor defaultInterceptor)
      : dio = Dio(
          BaseOptions(
            baseUrl: ConfigConstants.baseUrl,
            connectTimeout: ConfigConstants.connectTimeout,
            receiveTimeout: ConfigConstants.receiveTimeout,
            sendTimeout: ConfigConstants.sendTimeout,
          ),
        ) {
    dio.interceptors.add(defaultInterceptor);
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: kDebugMode,
        requestHeader: kDebugMode,
      ),
    );

    retrofitService = RetrofitService(dio);
  }
}

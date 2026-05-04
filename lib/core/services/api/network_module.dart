import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/retrofit_service.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../res/const.dart';
import 'default_dio_interceptor.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio getDioInstance(DefaultDioInterceptor interceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ConfigConstants.baseUrl,
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
  RetrofitService getRetrofitService(Dio dio) => RetrofitService(dio);
}

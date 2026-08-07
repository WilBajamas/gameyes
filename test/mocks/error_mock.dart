import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

FunctionException get mockFunctionException => const FunctionException(
  status: 502,
  details: {'error': 'test proxy error message'},
);

// What a failed igdb-proxy call looks like now: a bad gateway from the
// function, with the function's own error body attached.
DioException get mockDioException {
  final requestOptions = RequestOptions(
    path: SupabaseIgdbProxyConstants.functionPath,
  );

  return DioException.badResponse(
    statusCode: 502,
    requestOptions: requestOptions,
    response: Response<Map<String, Object?>>(
      statusCode: 502,
      data: const {'error': 'test proxy error message'},
      requestOptions: requestOptions,
    ),
  );
}

ErrorType get mockConnectionTimeoutError => ErrorType.connectionTimeout();
ErrorType get mockReceiveTimeoutError => ErrorType.receiveTimeout();
ErrorType get mockSendTimeoutError => ErrorType.sendTimeout();
ErrorType get mockResponseError => const ResponseError(
  message: 'test response error message',
  statusCode: 401,
);
ErrorType get mockSignInCancelledError => const ErrorType.signInCancelled();

import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

FunctionException get mockFunctionException => const FunctionException(
  status: 502,
  details: {'error': 'test proxy error message'},
);

ErrorType get mockConnectionTimeoutError => ErrorType.connectionTimeout();
ErrorType get mockReceiveTimeoutError => ErrorType.receiveTimeout();
ErrorType get mockSendTimeoutError => ErrorType.sendTimeout();
ErrorType get mockResponseError => const ResponseError(
  message: 'test response error message',
  statusCode: 401,
);
ErrorType get mockSignInCancelledError => const ErrorType.signInCancelled();

import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';

ErrorType get mockConnectionTimeoutError => ErrorType.connectionTimeout();
ErrorType get mockReceiveTimeoutError => ErrorType.receiveTimeout();
ErrorType get mockSendTimeoutError => ErrorType.sendTimeout();
ErrorType get mockResponseError => const ResponseError(
      message: 'test response error message',
      statusCode: 401,
    );

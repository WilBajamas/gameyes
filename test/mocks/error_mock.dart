import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';

ErrorType get mockConnectionTimeoutError => ConnectionTimeoutError();
ErrorType get mockReceiveTimeoutError => ReceiveTimeoutError();
ErrorType get mockSendTimeoutError => SendTimeoutError();
ErrorType get mockResponseError => const ResponseError(
      message: 'test response error message',
      statusCode: 401,
    );

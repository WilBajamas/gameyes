import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

sealed class ErrorType {
  const ErrorType();

  factory ErrorType.errorType({
    required DioException exception,
    String? message,
    String? error,
    int? statusCode,
  }) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout => ConnectionTimeoutError(),
      DioExceptionType.receiveTimeout => ReceiveTimeoutError(),
      DioExceptionType.sendTimeout => SendTimeoutError(),
      _ => ResponseError(message: message, statusCode: statusCode)
    };
  }
}

class ConnectionTimeoutError extends ErrorType {
  final String message = StringConstants.connectionTimeout;
}

class ReceiveTimeoutError extends ErrorType {
  final String message = StringConstants.connectionTimeout;
}

class SendTimeoutError extends ErrorType {
  final String message = StringConstants.connectionTimeout;
}

class UnknownError extends ErrorType {}

class ResponseError extends ErrorType {
  final String? message;
  final int? statusCode;

  const ResponseError({
    required this.message,
    required this.statusCode,
  });
}

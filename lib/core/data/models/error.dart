import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'error.freezed.dart';

@freezed
sealed class ErrorType with _$ErrorType {
  const ErrorType._();
  const factory ErrorType.responseError({
    String? message,
    String? error,
    int? statusCode,
  }) = ResponseError;
  const factory ErrorType.connectionTimeout() = ConnectionTimeout;
  const factory ErrorType.receiveTimeout() = ReceiveTimeout;
  const factory ErrorType.sendTimeout() = SendTimeout;
  const factory ErrorType.unknown() = UnknownError;

  factory ErrorType.dioError({
    required DioException exception,
  }) {
    final response = exception.response;
    final data = response?.data;

    final apiError = (data is Map) ? data['error']?.toString() : null;
    final apiMessage =
        (data is Map) ? data['message']?.toString() : exception.message;

    return switch (exception.type) {
      DioExceptionType.connectionTimeout => ErrorType.connectionTimeout(),
      DioExceptionType.receiveTimeout => ErrorType.receiveTimeout(),
      DioExceptionType.sendTimeout => ErrorType.sendTimeout(),
      _ when response == null => const ErrorType.unknown(),
      _ => ErrorType.responseError(
          message: apiMessage,
          statusCode: exception.response?.statusCode,
          error: apiError,
        )
    };
  }
}

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'error.freezed.dart';

@freezed
sealed class ErrorType with _$ErrorType {
  const ErrorType._();

  // Postgres tells these three apart by code; the app could not, so every
  // one of them read as "something went wrong".
  static const _uniqueViolation = '23505';
  static const _checkViolation = '23514';
  static const _notAllowedByPolicy = '42501';

  const factory ErrorType.responseError({
    String? message,
    String? error,
    int? statusCode,
  }) = ResponseError;
  const factory ErrorType.connectionTimeout() = ConnectionTimeout;
  const factory ErrorType.receiveTimeout() = ReceiveTimeout;
  const factory ErrorType.sendTimeout() = SendTimeout;
  const factory ErrorType.unknown() = UnknownError;

  // The person closed the sign-in page without finishing. That is not a
  // network or provider problem, so it needs its own kind of error.
  const factory ErrorType.signInCancelled() = SignInCancelled;

  const factory ErrorType.duplicateEntry() = DuplicateEntry;
  const factory ErrorType.invalidValue() = InvalidValue;
  const factory ErrorType.notAllowed() = NotAllowed;
  const factory ErrorType.notSignedIn() = NotSignedIn;

  factory ErrorType.dioError({required DioException exception}) {
    final response = exception.response;
    final data = response?.data;

    final apiError = (data is Map) ? data['error']?.toString() : null;
    final apiMessage = (data is Map)
        ? data['message']?.toString()
        : exception.message;

    return switch (exception.type) {
      DioExceptionType.connectionTimeout => ErrorType.connectionTimeout(),
      DioExceptionType.receiveTimeout => ErrorType.receiveTimeout(),
      DioExceptionType.sendTimeout => ErrorType.sendTimeout(),
      _ when response == null => const ErrorType.unknown(),
      _ => ErrorType.responseError(
        message: apiMessage,
        statusCode: exception.response?.statusCode,
        error: apiError,
      ),
    };
  }

  factory ErrorType.supabaseIgdbError({required FunctionException exception}) {
    final details = exception.details;
    final message = (details is Map) ? details['error']?.toString() : null;

    if (message == null) return const ErrorType.unknown();

    return ErrorType.responseError(
      message: message,
      statusCode: exception.status,
    );
  }

  factory ErrorType.postgrestError({required PostgrestException exception}) =>
      switch (exception.code) {
        _uniqueViolation => const ErrorType.duplicateEntry(),
        _checkViolation => const ErrorType.invalidValue(),
        _notAllowedByPolicy => const ErrorType.notAllowed(),
        _ => ErrorType.responseError(
          message: exception.message,
          error: exception.code,
          statusCode: int.tryParse(exception.code ?? ''),
        ),
      };
}

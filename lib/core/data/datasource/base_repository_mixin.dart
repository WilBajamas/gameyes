import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';

mixin BaseRepositoryMixin {
  Future<Result<T>> fetchData<T>({
    required Future<T> apiCall,
  }) async {
    try {
      final response = await apiCall;

      return Success(response);
    } on DioException catch (dioException) {
      final Map<String, dynamic>? errorResponse = dioException.response?.data;

      return Failure(
        ErrorType.errorType(
          exception: dioException,
          message: errorResponse?['message'],
          error: errorResponse?['error'],
          statusCode: dioException.response?.statusCode,
        ),
      );
    } catch (_) {
      return Failure(UnknownError());
    }
  }
}

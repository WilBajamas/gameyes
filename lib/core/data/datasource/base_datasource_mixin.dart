import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';

mixin BaseRepositoryMixin {
  Future<Either<ErrorType, T>> fetchData<T>({
    required Future<T> apiCall,
  }) async {
    try {
      final response = await apiCall;

      return Right(
        response,
      );
    } on DioException catch (dioException) {
      final Map<String, dynamic>? errorResponse = dioException.response?.data;

      return Left(
        ErrorType.errorType(
          exception: dioException,
          message: errorResponse?['message'],
          error: errorResponse?['error'],
          statusCode: dioException.response?.statusCode,
        ),
      );
    }
  }
}

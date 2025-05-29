import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GamesDataSource {
  final DioService _dioService;

  const GamesDataSource(this._dioService);

  Future<Either<ErrorType, GamesResponse>> fetchDatasourceGames({
    int page = 1,
    int pageSize = 20,
    String? searchTerm,
    String? dateRange,
    String? orderings,
    String? platforms,
    String? genres,
  }) async {
    try {
      final response = await _dioService.retrofitService.fetchGames(
        page,
        pageSize,
        dateRange,
        orderings,
        searchTerm,
        platforms,
        genres,
      );

      return Right(
        response.copyWith(currentPage: page),
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

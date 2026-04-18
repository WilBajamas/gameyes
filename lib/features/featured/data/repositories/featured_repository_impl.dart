import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasources/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeaturedRepository)
class FeaturedRepositoryImpl implements FeaturedRepository {
  final GamesDataSource _gamesDatasource;

  FeaturedRepositoryImpl(this._gamesDatasource);

  @override
  Future<Either<ErrorType, GamesResponse>> fetchGames({
    required int page,
    String? dateRange,
    String? orderings,
    String? platforms,
  }) async {
    try {
      final response = await _gamesDatasource.fetchDatasourceGames(
        page: page,
        dateRange: dateRange,
        orderings: orderings,
        platforms: platforms,
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

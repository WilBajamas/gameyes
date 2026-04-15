import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/datasource/games_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';
import 'package:gaming_library_assessment_flutter/features/games/domain/repositories/games_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GamesRepository)
class GamesRepositoryImpl implements GamesRepository {
  final GamesDataSource _gamesDatasource;

  const GamesRepositoryImpl(this._gamesDatasource);

  @override
  Future<Either<ErrorType, GamesResponse>> fetchGames({
    int page = 1,
    String? searchTerm,
    String? dateRange,
    String? ordering,
    String? platforms,
    String? genres,
  }) async {
    try {
      final response = await _gamesDatasource.fetchDatasourceGames(
        page: page,
        searchTerm: searchTerm,
        dateRange: dateRange,
        orderings: ordering,
        platforms: platforms,
        genres: genres,
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

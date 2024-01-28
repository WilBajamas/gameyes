import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/models/games_response.dart';
import 'package:injectable/injectable.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;

@injectable
class GamesDataSource {
  final _dioService = injection.getIt<DioService>();

  Future<Either<ErrorType, GamesResponse>> fetchGames({
    int page = 1,
    int pageSize = 10,
    String dateFrom = '',
    String dateTo = '',
    String ordering = 'released',
    bool reverseOrder = false,
    List<int>? platforms,
  }) async {
    final dateRange =
        '$dateFrom${dateFrom.isNotEmpty && dateTo.isNotEmpty ? ',' : ''}$dateTo';

    try {
      final response = await _dioService.dio.get(
        ConfigConstants.gamesEndpoint,
        queryParameters: {
          'dates': dateRange,
          'ordering': '${reverseOrder ? '-' : ''}$ordering',
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      return Right(GamesResponse.fromJson(response.data));
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

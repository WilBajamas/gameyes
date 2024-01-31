import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/api/dio_service.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameScreenshotsDatasource {
  final _dioService = getIt<DioService>();

  Future<Either<ErrorType, ScreenshotResponse>> fetchGameScreenshots({
    required String slug,
  }) async {
    try {
      final response = await _dioService.dio.get(
        '${ConfigConstants.gamesEndpoint}/$slug/${ConfigConstants.screenshotsEndpoint}',
      );

      return Right(
        ScreenshotResponse.fromJson(response.data),
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

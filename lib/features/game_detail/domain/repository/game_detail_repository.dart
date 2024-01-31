import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';

abstract class GameDetailRepository {
  Future<Either<ErrorType, GameDetailResponse>> fetchGameDetail({
    required int id,
  });
}

import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';

abstract class GamesRepository {
  Future<Either<ErrorType, GamesResponse>> fetchGames({
    int page,
    String? searchTerm,
    String? dateRange,
    String? platforms,
    String? genres,
    String? ordering,
  });
}

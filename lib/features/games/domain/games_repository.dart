import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/games_response.dart';

abstract class GamesRepository {
  Future<Either<ErrorType, GamesResponse>> fetchGames({
    int page,
    String? searchTerm,
    DateTime? dateFrom,
    DateTime? dateTo,
    required GameOrdering ordering,
    required List<GamesPlatform> platforms,
  });
}

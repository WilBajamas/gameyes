import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/models/games_response.dart';

abstract class FeaturedRepository {
  Future<Either<ErrorType, GamesResponse>> fetchMostAnticipated();
  Future<Either<ErrorType, GamesResponse>> fetchBestMetacritic();
  Future<Either<ErrorType, GamesResponse>> fetchLatestReleases();
}

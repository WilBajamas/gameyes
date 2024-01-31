import 'package:dartz/dartz.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/datasources/game_detail_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/game_detail_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GameDetailRepository)
class GameDetailRepositoryImpl implements GameDetailRepository {
  final _gameDetailDatasource = getIt<GameDetailDatasource>();

  @override
  Future<Either<ErrorType, GameDetailResponse>> fetchGameDetail({
    required int id,
  }) =>
      _gameDetailDatasource.fetchGameDetail(id: id);
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_detail_repository.dart';
import 'package:injectable/injectable.dart';

part 'game_detail_state.dart';

@injectable
class GameDetailCubit extends Cubit<GameDetailState> {
  final _gameDetailRepository = getIt<GameDetailRepository>();

  GameDetailCubit() : super(const GameDetailState());

  Future<void> fetchGameDetail({required int id}) async {
    emit(state.copyWith(status: GameDetailStatus.loading));

    final response = await _gameDetailRepository.fetchGameDetail(id: id);

    response.fold(
      (error) =>
          emit(state.copyWith(status: GameDetailStatus.failed, error: error)),
      (response) => emit(
        state.copyWith(status: GameDetailStatus.success, response: response),
      ),
    );
  }
}

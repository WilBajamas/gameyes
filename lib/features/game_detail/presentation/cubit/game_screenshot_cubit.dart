import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/screenshot_response.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_screenshots_repository.dart';
import 'package:injectable/injectable.dart';

part 'game_screenshot_state.dart';

@injectable
class GameScreenshotCubit extends Cubit<GameScreenshotState> {
  final GameScreenshotsRepository _gameScreenshotsRepository;

  GameScreenshotCubit(
      {@factoryParam required int id,
      required GameScreenshotsRepository gameScreenshotsRepository})
      : _gameScreenshotsRepository = gameScreenshotsRepository,
        super(const GameScreenshotState()) {
    fetchGameScreenshots(id: id);
  }

  Future<void> fetchGameScreenshots({required int id}) async {
    emit(state.copyWith(status: ScreenshotsStatus.loading));

    final response =
        await _gameScreenshotsRepository.fetchGameScreenshots(id: id);

    response.fold(
      (error) => emit(
        state.copyWith(status: ScreenshotsStatus.failure, error: error),
      ),
      (response) => emit(
        state.copyWith(
          status: ScreenshotsStatus.success,
          response: response,
        ),
      ),
    );
  }
}

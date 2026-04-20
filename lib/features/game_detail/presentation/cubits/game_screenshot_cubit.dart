import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repositories/game_screenshots_repository.dart';
import 'package:injectable/injectable.dart';

import 'game_screenshot_state.dart';

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

    final newState = switch (response) {
      Success(value: final screenshotResponse) => state.copyWith(
          status: ScreenshotsStatus.success,
          response: screenshotResponse,
        ),
      Failure(error: final error) =>
        state.copyWith(status: ScreenshotsStatus.failure, error: error),
    };

    emit(newState);
  }
}

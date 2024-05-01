import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repository/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

part 'tracker_detail_state.dart';

@injectable
class TrackerDetailCubit extends Cubit<TrackerDetailState> {
  final _trackerDetailRepository = getIt<TrackerDetailRepository>();

  TrackerDetailCubit() : super(const TrackerDetailState());

  void setSavedGame({required SavedGame game}) =>
      emit(TrackerDetailState(game: game));

  void setPlatform({required GamePlatform platform}) async {
    final savedGame = await _trackerDetailRepository.setPlatform(
      platform: platform,
      gameId: state.game!.gameId!,
    );

    emit(TrackerDetailState(game: savedGame));
  }
}

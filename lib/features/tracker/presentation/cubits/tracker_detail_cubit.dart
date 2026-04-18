import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game_task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_detail_repository.dart';
import 'package:injectable/injectable.dart';

part 'tracker_detail_state.dart';

@injectable
class TrackerDetailCubit extends Cubit<TrackerDetailState> {
  final TrackerDetailRepository _trackerDetailRepository;

  StreamSubscription? savedGameStreamSubscription;

  TrackerDetailCubit({
    @factoryParam required SavedGame game,
    required TrackerDetailRepository trackerDetailRepository,
  })  : _trackerDetailRepository = trackerDetailRepository,
        super(const TrackerDetailState()) {
    setSavedGame(game: game);
    listenToSavedGame(savedGameId: game.id);
  }

  void setSavedGame({required SavedGame game}) =>
      emit(TrackerDetailState(game: game));

  String getTasksCompletion() {
    final completedTasks = state.game!.groupTasks
        .where((gt) => gt.tasks.isNotEmpty)
        .expand((gt) => gt.tasks)
        .where((t) => t.completed == true)
        .length;

    final totalTasks =
        state.game!.groupTasks.fold(0, (acc, gt) => acc + gt.tasks.length);

    return totalTasks == 0 ? '-/-' : '$completedTasks/$totalTasks';
  }

  List<SavedGameTask> getPinnedTasks() {
    final tasks = state.game!.groupTasks
        .where((gt) => gt.tasks.isNotEmpty)
        .expand((gt) => gt.tasks)
        .where((t) => t.pinned == true)
        .toList();

    return tasks;
  }

  void setPlatform({required GamePlatform platform}) async {
    _trackerDetailRepository.setPlatform(
      platform: platform,
      savedGameId: state.game!.id,
    );
  }

  void addGroupTask({
    required String title,
    required String description,
  }) async {
    await _trackerDetailRepository.createGroupTask(
      title: title,
      description: description,
      id: state.game!.id,
    );
  }

  void listenToSavedGame({required int savedGameId}) {
    savedGameStreamSubscription?.cancel();
    final stream = _trackerDetailRepository
        .savedGameDetailStream(savedGameId: savedGameId)
        .listen((savedGame) => emit(TrackerDetailState(game: savedGame)));

    savedGameStreamSubscription = stream;
  }

  void removeGroupTask({required groupTaskId}) async =>
      await _trackerDetailRepository.removeGroupTask(
        savedGameId: state.game!.id,
        groupTaskId: groupTaskId,
      );

  void createTask({required groupTaskId}) async =>
      await _trackerDetailRepository.createTask(
        savedGameId: state.game!.id,
        groupTaskId: groupTaskId,
      );

  @override
  Future<void> close() {
    savedGameStreamSubscription?.cancel();
    return super.close();
  }
}

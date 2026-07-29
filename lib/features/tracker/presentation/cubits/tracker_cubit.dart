import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/get_tracker_sort_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/use_cases/save_tracker_sort_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackerCubit extends Cubit<TrackerState> {
  final TrackerRepository _repository;
  final SaveTrackerSortUseCase _saveTrackerSortUseCase;

  TrackerCubit(
    this._repository,
    this._saveTrackerSortUseCase,
    GetTrackerSortUseCase getTrackerSortUseCase,
  ) : super(TrackerState(tag: getTrackerSortUseCase()));

  void setSortTag(SavedGameFilterTag tag) {
    if (tag == state.tag) return;

    emit(state.copyWith(tag: tag));

    // Fire-and-forget: a slow or failing write must neither delay nor revert
    // the in-session reorder, and a write failure is never surfaced.
    _saveTrackerSortUseCase(tag).ignore();
  }

  void setSearchTerm(String? term) => emit(state.copyWith(searchTerm: term));

  Stream<List<TrackerSavedGameEntity>> get savedGamesStream =>
      _repository.savedGamesStream(state.tag, state.searchTerm);

  Future<void> removeSavedGame(int id) => _repository.removeSavedGame(id);
}

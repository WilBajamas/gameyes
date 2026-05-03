import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_saved_game_entity.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/tracker_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackerCubit extends Cubit<TrackerState> {
  final TrackerRepository _repository;

  TrackerCubit(this._repository) : super(const TrackerState());

  void setTag(SavedGameFilterTag? tag, String? searchTerm) =>
      emit(state.copyWith(tag: tag ?? state.tag, searchTerm: searchTerm));

  Stream<List<TrackerSavedGameEntity>> get savedGamesStream =>
      _repository.savedGamesStream(state.tag, state.searchTerm);

  Future<void> removeSavedGame(int id) => _repository.removeSavedGame(id);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/tracker_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackerCubit extends Cubit<TrackerState> {
  TrackerCubit() : super(const TrackerState());

  void setTag(SavedGameFilterTag? tag, String? searchTerm) =>
      emit(state.copyWith(tag, searchTerm));
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackerCubit extends Cubit<SavedGameFilterTag> {
  TrackerCubit() : super(SavedGameFilterTag.recentlyChanged);

  void setTag(SavedGameFilterTag tag) => emit(tag);
}

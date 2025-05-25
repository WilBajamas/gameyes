import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';

class TrackerState extends Equatable {
  final SavedGameFilterTag tag;
  final String? searchTerm;

  const TrackerState({
    this.tag = SavedGameFilterTag.recentlyChanged,
    this.searchTerm,
  });

  TrackerState copyWith(SavedGameFilterTag? tag, String? term) =>
      TrackerState(tag: tag ?? this.tag, searchTerm: term ?? searchTerm);

  @override
  List<Object?> get props => [tag, searchTerm];
}

import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';

/// Persistence boundary for the Tracker's selected sort option.
///
/// Both members are contractually non-throwing. [getSortTag] always returns a
/// valid [SavedGameFilterTag] member, defaulting to
/// [SavedGameFilterTag.recentlyChanged] when the stored value is absent,
/// unreadable or unrecognised.
abstract interface class TrackerSortRepository {
  SavedGameFilterTag getSortTag();

  Future<void> saveSortTag(SavedGameFilterTag tag);
}

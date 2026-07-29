import 'package:gaming_library_assessment_flutter/core/enums/saved_game_filter_tag.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/datasources/local/tracker_preferences_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/domain/repositories/tracker_sort_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackerSortRepository)
class TrackerSortRepositoryImpl implements TrackerSortRepository {
  final TrackerPreferencesDatasource _datasource;

  TrackerSortRepositoryImpl(this._datasource);

  @override
  SavedGameFilterTag getSortTag() {
    final name = _datasource.readSortTagName();

    if (name == null) return SavedGameFilterTag.recentlyChanged;

    for (final tag in SavedGameFilterTag.values) {
      if (tag.name == name) return tag;
    }

    return SavedGameFilterTag.recentlyChanged;
  }

  @override
  Future<void> saveSortTag(SavedGameFilterTag tag) =>
      _datasource.writeSortTagName(tag.name);
}

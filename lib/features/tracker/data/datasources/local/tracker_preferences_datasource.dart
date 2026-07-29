import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class TrackerPreferencesDatasource {
  final SharedPreferences _preferences;

  TrackerPreferencesDatasource(this._preferences);

  String? readSortTagName() {
    try {
      return _preferences.getString(StorageConstants.trackerSortTagKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeSortTagName(String name) async {
    try {
      await _preferences.setString(
        StorageConstants.trackerSortTagKey,
        name,
      );
    } catch (_) {
      // Persistence is best-effort; a failed write must not surface an error.
    }
  }
}

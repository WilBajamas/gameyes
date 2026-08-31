import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LibraryPreferencesDatasource {
  final SharedPreferences _preferences;

  LibraryPreferencesDatasource(this._preferences);

  String? readViewModeName() {
    try {
      return _preferences.getString(StorageConstants.libraryViewModeKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeViewModeName(String name) async {
    try {
      await _preferences.setString(StorageConstants.libraryViewModeKey, name);
    } catch (_) {
      // Persistence is best-effort; a failed write must not surface an error.
    }
  }

  String? readSortName() {
    try {
      return _preferences.getString(StorageConstants.librarySortKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeSortName(String name) async {
    try {
      await _preferences.setString(StorageConstants.librarySortKey, name);
    } catch (_) {
      // Persistence is best-effort; a failed write must not surface an error.
    }
  }
}

import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';
import 'package:gaming_library_assessment_flutter/features/library/data/datasources/library_preferences_datasource.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_preferences_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LibraryPreferencesRepository)
class LibraryPreferencesRepositoryImpl implements LibraryPreferencesRepository {
  final LibraryPreferencesDatasource _datasource;

  LibraryPreferencesRepositoryImpl(this._datasource);

  @override
  LibraryViewMode getViewMode() {
    final name = _datasource.readViewModeName();

    if (name == null) return LibraryViewMode.grid;

    for (final mode in LibraryViewMode.values) {
      if (mode.name == name) return mode;
    }

    return LibraryViewMode.grid;
  }

  @override
  Future<void> saveViewMode(LibraryViewMode mode) =>
      _datasource.writeViewModeName(mode.name);

  @override
  LibrarySort getSort() {
    final name = _datasource.readSortName();

    if (name == null) return LibrarySort.recentlyAdded;

    for (final sort in LibrarySort.values) {
      if (sort.name == name) return sort;
    }

    return LibrarySort.recentlyAdded;
  }

  @override
  Future<void> saveSort(LibrarySort sort) =>
      _datasource.writeSortName(sort.name);
}

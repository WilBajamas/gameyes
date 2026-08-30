import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';

/// Persistence boundary for the Library's view mode and sort.
///
/// Every member is contractually non-throwing. The getters always return a
/// valid value, defaulting to [LibraryViewMode.grid] and
/// [LibrarySort.recentlyAdded] when the stored value is absent, unreadable or
/// unrecognised.
abstract interface class LibraryPreferencesRepository {
  LibraryViewMode getViewMode();
  Future<void> saveViewMode(LibraryViewMode mode);

  LibrarySort getSort();
  Future<void> saveSort(LibrarySort sort);
}

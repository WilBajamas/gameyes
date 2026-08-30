import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_preferences_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLibraryPreferencesUseCase {
  const GetLibraryPreferencesUseCase(this._repository);

  final LibraryPreferencesRepository _repository;

  // Synchronous and outside Result: the repository below cannot fail or throw.
  ({LibraryViewMode viewMode, LibrarySort sort}) call() =>
      (viewMode: _repository.getViewMode(), sort: _repository.getSort());
}

import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_preferences_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveLibraryViewModeUseCase {
  const SaveLibraryViewModeUseCase(this._repository);

  final LibraryPreferencesRepository _repository;

  Future<void> call(LibraryViewMode mode) => _repository.saveViewMode(mode);
}

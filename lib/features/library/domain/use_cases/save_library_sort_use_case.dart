import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_preferences_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveLibrarySortUseCase {
  const SaveLibrarySortUseCase(this._repository);

  final LibraryPreferencesRepository _repository;

  Future<void> call(LibrarySort sort) => _repository.saveSort(sort);
}

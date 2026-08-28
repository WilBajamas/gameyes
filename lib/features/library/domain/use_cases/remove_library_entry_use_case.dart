import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveLibraryEntryUseCase {
  const RemoveLibraryEntryUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<void>> call({required int igdbId}) =>
      _repository.remove(igdbId: igdbId);
}

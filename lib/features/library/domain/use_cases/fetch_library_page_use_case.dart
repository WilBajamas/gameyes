import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_page_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchLibraryPageUseCase {
  const FetchLibraryPageUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryPageEntity>> call({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
    String? searchTerm,
  }) => _repository.fetchPage(
    status: status,
    sort: sort,
    limit: limit,
    offset: offset,
    searchTerm: searchTerm,
  );
}

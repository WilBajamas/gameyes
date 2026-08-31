import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateLibraryEntryUseCase {
  const UpdateLibraryEntryUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryEntryEntity>> call({
    required int igdbId,
    LibraryStatus? status,
    int? rating,
    bool clearRating = false,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) => _repository.update(
    igdbId: igdbId,
    status: status,
    rating: rating,
    clearRating: clearRating,
    platform: platform,
    genre: genre,
    playtimeHours: playtimeHours,
    progressPercent: progressPercent,
  );
}

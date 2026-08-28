import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddLibraryEntryUseCase {
  const AddLibraryEntryUseCase(this._repository);

  final LibraryRepository _repository;

  Future<Result<LibraryEntryEntity>> call({
    required int igdbId,
    required String title,
    String? coverUrl,
    DateTime? releaseDate,
    required LibraryStatus status,
    int? rating,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  }) => _repository.add(
    igdbId: igdbId,
    title: title,
    coverUrl: coverUrl,
    releaseDate: releaseDate,
    status: status,
    rating: rating,
    platform: platform,
    genre: genre,
    playtimeHours: playtimeHours,
    progressPercent: progressPercent,
  );
}

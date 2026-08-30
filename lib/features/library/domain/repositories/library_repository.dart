import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_counts_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_page_entity.dart';

abstract interface class LibraryRepository {
  Future<Result<LibraryPageEntity>> fetchPage({
    LibraryStatus? status,
    required LibrarySort sort,
    required int limit,
    required int offset,
    String? searchTerm,
  });

  Future<Result<LibraryCountsEntity>> fetchCounts();

  /// Every entry for the signed-in user, unpaged, newest change first.
  Future<Result<List<LibraryEntryEntity>>> fetchAllEntries({
    LibraryStatus? status,
  });

  Future<Result<LibraryEntryEntity>> add({
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
  });

  Future<Result<LibraryEntryEntity>> update({
    required int igdbId,
    LibraryStatus? status,
    int? rating,
    bool clearRating,
    String? platform,
    String? genre,
    double? playtimeHours,
    double? progressPercent,
  });

  Future<Result<void>> remove({required int igdbId});
}

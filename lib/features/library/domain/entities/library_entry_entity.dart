import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';

part 'library_entry_entity.freezed.dart';

@freezed
sealed class LibraryEntryEntity with _$LibraryEntryEntity {
  const factory LibraryEntryEntity({
    required String id,
    required int igdbId,
    required String title,
    String? coverUrl,
    DateTime? releaseDate,
    required LibraryStatus status,
    required DateTime createdAt,
    String? platform,
    int? rating,
    double? playtimeHours,
    double? progressPercent,
    String? genre,
    required DateTime updatedAt,
  }) = _LibraryEntryEntity;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';

part 'library_page_entity.freezed.dart';

@freezed
sealed class LibraryPageEntity with _$LibraryPageEntity {
  const factory LibraryPageEntity({
    required List<LibraryEntryEntity> entries,
    required int matchedCount,
  }) = _LibraryPageEntity;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';

part 'library_counts_entity.freezed.dart';

@freezed
sealed class LibraryCountsEntity with _$LibraryCountsEntity {
  const factory LibraryCountsEntity({
    required Map<LibraryStatus, int> byStatus,
    required int total,
  }) = _LibraryCountsEntity;
}

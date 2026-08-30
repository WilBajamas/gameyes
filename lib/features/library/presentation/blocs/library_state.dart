import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_sort.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_view_mode.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_counts_entity.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/entities/library_entry_entity.dart';

part 'library_state.freezed.dart';

enum LibraryLoadStatus { initial, loading, success, failed, empty }

enum LibraryNextPageStatus { initial, loading, failed }

@freezed
sealed class LibraryState with _$LibraryState {
  const factory LibraryState({
    LibraryStatus? activeStatus,
    @Default(LibrarySort.recentlyAdded) LibrarySort sort,
    @Default(LibraryViewMode.grid) LibraryViewMode viewMode,
    @Default('') String searchTerm,
    @Default(<LibraryEntryEntity>[]) List<LibraryEntryEntity> entries,
    @Default(LibraryLoadStatus.initial) LibraryLoadStatus status,
    @Default(LibraryNextPageStatus.initial)
    LibraryNextPageStatus nextPageStatus,
    @Default(false) bool hasReachedEnd,
    // Null means the counts have not been read, which is not the same as a
    // library where every status is genuinely zero.
    LibraryCountsEntity? counts,
    @Default(0) int matchedCount,
    ErrorType? error,
    ErrorType? nextPageError,
  }) = _LibraryState;
}

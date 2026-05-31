import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/repositories/featured_revamp_repository.dart';

part 'library_stats_state.freezed.dart';

enum LibraryStatsStatus { initial, loading, success, failed }

@freezed
sealed class LibraryStatsState with _$LibraryStatsState {
  const factory LibraryStatsState({
    @Default(LibraryStatsStatus.initial) LibraryStatsStatus status,
    LibrarySnapshotEntity? snapshot,
    String? errorMessage,
    @Default(false) bool isChecklistDismissed,
    @Default(false) bool step1Completed,
    @Default(false) bool step2Completed,
    @Default(false) bool step3Completed,
    @Default(0.0) double checklistProgress,
  }) = _LibraryStatsState;
}


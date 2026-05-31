import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/use_cases/get_library_snapshot_use_case.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'library_stats_state.dart';

@injectable
class LibraryStatsCubit extends Cubit<LibraryStatsState> {
  final GetLibrarySnapshotUseCase _getLibrarySnapshotUseCase;
  final SharedPreferences _sharedPreferences;

  static const String _checklistDismissedKey =
      'featured_revamp_checklist_dismissed';

  LibraryStatsCubit(
    this._getLibrarySnapshotUseCase,
    this._sharedPreferences,
  ) : super(const LibraryStatsState()) {
    final dismissed =
        _sharedPreferences.getBool(_checklistDismissedKey) ?? false;
    emit(state.copyWith(isChecklistDismissed: dismissed));
  }

  Future<void> loadLibrarySnapshot() async {
    emit(state.copyWith(status: LibraryStatsStatus.loading));

    final result = await _getLibrarySnapshotUseCase();

    switch (result) {
      case Success(value: final snapshot):
        var isDismissed = state.isChecklistDismissed;
        if (!isDismissed && snapshot.totalGamesCount >= 1) {
          isDismissed = true;
          await _sharedPreferences.setBool(_checklistDismissedKey, true);
        }

        final step1 = snapshot.totalGamesCount >= 1;
        final step2 = snapshot.nowPlayingGames.isNotEmpty;
        final step3 = snapshot.wishlistCount >= 1;

        double progress = 0.0;
        if (step1) progress += 1.0;
        if (step2) progress += 1.0;
        if (step3) progress += 1.0;
        progress /= 3.0;

        emit(
          state.copyWith(
            status: LibraryStatsStatus.success,
            snapshot: snapshot,
            isChecklistDismissed: isDismissed,
            step1Completed: step1,
            step2Completed: step2,
            step3Completed: step3,
            checklistProgress: progress,
          ),
        );
      case Failure(error: _):
        emit(
          state.copyWith(
            status: LibraryStatsStatus.failed,
            errorMessage: S.current.failed_to_load_library_stats,
          ),
        );
    }
  }
}

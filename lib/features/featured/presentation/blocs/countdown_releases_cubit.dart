import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/release_date_entity.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_countdown_game_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_out_this_week_use_case.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:injectable/injectable.dart';

import 'countdown_releases_state.dart';

@injectable
class CountdownReleasesCubit extends Cubit<CountdownReleasesState> {
  final GetCountdownGameUseCase _getCountdownGameUseCase;
  final GetOutThisWeekUseCase _getOutThisWeekUseCase;

  Timer? _timer;

  CountdownReleasesCubit(
    this._getCountdownGameUseCase,
    this._getOutThisWeekUseCase,
  ) : super(const CountdownReleasesState());

  Future<void> loadCountdownAndReleases({
    bool forceExtendWindow = false,
  }) async {
    emit(state.copyWith(status: CountdownReleasesStatus.loading));
    _timer?.cancel();

    final countdownResult = await _getCountdownGameUseCase();
    final releasesResult =
        await _getOutThisWeekUseCase(forceExtendWindow: forceExtendWindow);

    switch (countdownResult) {
      case Success(value: final countdownGame):
        switch (releasesResult) {
          case Success(value: final releases):
            final now = DateTime.now();
            final todayStart = DateTime(now.year, now.month, now.day);
            final sevenDaysEnd = todayStart.add(const Duration(days: 7));

            bool hasExtendedGame = false;
            for (final g in releases) {
              final rDate = _getReleaseDate(g);
              if (rDate != null &&
                  (rDate.isAfter(sevenDaysEnd) ||
                      rDate.isAtSameMomentAs(sevenDaysEnd))) {
                hasExtendedGame = true;
                break;
              }
            }

            final isComingSoon =
                forceExtendWindow || (releases.isEmpty) || hasExtendedGame;

            emit(
              state.copyWith(
                status: CountdownReleasesStatus.success,
                countdownGame: countdownGame,
                outThisWeekGames: releases,
                isComingSoonLabel: isComingSoon,
              ),
            );

            _updateCountdown();
            _startTimer();
          case Failure():
            emit(
              state.copyWith(
                status: CountdownReleasesStatus.failed,
                errorMessage: S.current.failed_to_load_weekly_releases,
              ),
            );
        }
      case Failure():
        emit(
          state.copyWith(
            status: CountdownReleasesStatus.failed,
            errorMessage: S.current.failed_to_load_countdown_game,
          ),
        );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final game = state.countdownGame;
    if (game == null) {
      emit(state.copyWith(durationRemaining: null, isReleaseDay: false));
      return;
    }

    final releaseDate = _getReleaseDate(game);
    if (releaseDate == null) {
      emit(state.copyWith(durationRemaining: null, isReleaseDay: false));
      return;
    }

    final now = DateTime.now();
    final targetMidnight =
        DateTime(releaseDate.year, releaseDate.month, releaseDate.day);
    final todayStart = DateTime(now.year, now.month, now.day);

    if (todayStart.isAtSameMomentAs(targetMidnight)) {
      emit(
        state.copyWith(
          durationRemaining: Duration.zero,
          isReleaseDay: true,
        ),
      );
    } else if (now.isBefore(targetMidnight)) {
      final remaining = targetMidnight.difference(now);
      emit(
        state.copyWith(
          durationRemaining: remaining,
          isReleaseDay: false,
        ),
      );
    } else {
      // Release day has passed (the day after release or later).
      // Advance to the next game by re-fetching.
      emit(
        state.copyWith(
          durationRemaining: Duration.zero,
          isReleaseDay: false,
        ),
      );
      loadCountdownAndReleases();
    }
  }

  DateTime? _getReleaseDate(GameEntity game) {
    if (game.releaseDates == null || game.releaseDates!.isEmpty) return null;
    final dates = List<ReleaseDateEntity>.from(game.releaseDates!)
      ..sort((a, b) => a.date.compareTo(b.date));
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    try {
      return dates
          .firstWhere(
            (d) =>
                d.date.isAfter(todayStart) ||
                d.date.isAtSameMomentAs(todayStart),
          )
          .date;
    } catch (_) {
      return dates.first.date;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

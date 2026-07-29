import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repositories/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_critics_choice_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/get_genre_preferences_use_case.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/use_cases/save_genre_preferences_use_case.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:injectable/injectable.dart';

import 'critics_grid_state.dart';

@injectable
class CriticsGridCubit extends Cubit<CriticsGridState> {
  final GetGenrePreferencesUseCase _getGenrePreferencesUseCase;
  final GetCriticsChoiceUseCase _getCriticsChoiceUseCase;
  final SaveGenrePreferencesUseCase _saveGenrePreferencesUseCase;

  CriticsGridCubit(
    this._getGenrePreferencesUseCase,
    this._getCriticsChoiceUseCase,
    this._saveGenrePreferencesUseCase,
  ) : super(const CriticsGridState());

  Future<void> loadCriticsGrid() async {
    emit(state.copyWith(status: CriticsGridStatus.loading));

    final prefsResult = await _getGenrePreferencesUseCase();

    switch (prefsResult) {
      case Success(value: final genrePreferencesEntity):
        final gamesResult =
            await _getCriticsChoiceUseCase(genrePreferencesEntity.genreIds);

        switch (gamesResult) {
          case Success(value: final games):
            emit(
              state.copyWith(
                status: CriticsGridStatus.success,
                criticsGames: games,
                genrePreferencesEntity: genrePreferencesEntity,
              ),
            );
          case Failure(error: _):
            emit(
              state.copyWith(
                status: CriticsGridStatus.failed,
                errorMessage: S.current.failed_to_load_critics_choice_reviews,
              ),
            );
        }
      case Failure(error: _):
        emit(
          state.copyWith(
            status: CriticsGridStatus.failed,
            errorMessage: S.current.failed_to_load_genre_preferences,
          ),
        );
    }
  }

  Future<void> toggleGenrePreference(int genreId) async {
    final currentPrefs = state.genrePreferencesEntity;
    if (currentPrefs == null) return;

    final updatedGenreIds = List<int>.from(currentPrefs.genreIds);
    if (updatedGenreIds.contains(genreId)) {
      updatedGenreIds.remove(genreId);
    } else {
      updatedGenreIds.add(genreId);
    }

    final saveResult = await _saveGenrePreferencesUseCase(
      updatedGenreIds,
      isSkipped: false,
    );

    switch (saveResult) {
      case Success(value: _):
        emit(
          state.copyWith(
            genrePreferencesEntity: GenrePreferencesEntity(
              genreIds: updatedGenreIds,
              isSkipped: false,
            ),
          ),
        );
        loadCriticsGrid();
      case Failure():
        emit(
          state.copyWith(
            status: CriticsGridStatus.failed,
            errorMessage: S.current.failed_to_save_genre_preference,
          ),
        );
    }
  }

  Future<void> skipGenrePreferences() async {
    final saveResult = await _saveGenrePreferencesUseCase(
      [],
      isSkipped: true,
    );

    switch (saveResult) {
      case Success(value: _):
        emit(
          state.copyWith(
            genrePreferencesEntity: GenrePreferencesEntity(
              genreIds: [],
              isSkipped: true,
            ),
          ),
        );
        loadCriticsGrid();
      case Failure():
        emit(
          state.copyWith(
            status: CriticsGridStatus.failed,
            errorMessage: S.current.failed_to_skip_genre_preferences,
          ),
        );
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_response.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_detail_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:injectable/injectable.dart';

part 'game_detail_state.dart';

@injectable
class GameDetailCubit extends Cubit<GameDetailState> {
  final _gameDetailRepository = getIt<GameDetailRepository>();

  GameDetailCubit({required int id}) : super(const GameDetailState()) {
    fetchGameDetail(id: id);
  }

  void get resetContent => emit(const GameDetailState());

  Future<void> fetchGameDetail({required int id}) async {
    emit(state.copyWith(status: GameDetailStatus.loading));

    final response = await _gameDetailRepository.fetchGameDetail(id: id);

    response.fold(
      (error) =>
          emit(state.copyWith(status: GameDetailStatus.failed, error: error)),
      (response) {
        emit(
          state.copyWith(status: GameDetailStatus.success, response: response),
        );

        if (response.id case final gameId?) getSavedGame(gameId: gameId);
      },
    );
  }

  void get expandContent => emit(
        state.copyWith(
          contentExpanded: !state.contentExpanded,
        ),
      );

  Future<void> getSavedGame({required int gameId}) async {
    final saved = await _gameDetailRepository.getSavedGame(id: gameId);

    emit(state.copyWith(savedGame: saved));
  }

  void saveButtonClicked() {
    if (state.savedGame != null) {
      _unsaveGame();
    } else {
      _saveGame();
    }
  }

  void _saveGame() {
    if (state.response == null) return;

    final SavedGame gameToSave = SavedGame()
      ..gameId = state.response?.id
      ..gameSlug = state.response?.slug
      ..name = state.response?.name
      ..imageUrl = state.response?.backgroundImage
      ..dateSaved = DateTime.now();

    _gameDetailRepository
        .saveGame(game: gameToSave)
        .then((_) => emit(state.copyWith(savedGame: gameToSave)));
  }

  Future<void> _unsaveGame() async {
    if (state.savedGame == null) return;

    await _gameDetailRepository
        .unsaveGame(id: state.savedGame!.id)
        .then((_) => emit(state.copyWith()));
  }
}

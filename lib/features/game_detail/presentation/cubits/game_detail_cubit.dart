import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repositories/game_detail_repository.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:injectable/injectable.dart';

import 'game_detail_state.dart';

@injectable
class GameDetailCubit extends Cubit<GameDetailState> {
  final GameDetailRepository _gameDetailRepository;

  GameDetailCubit({
    @factoryParam required int id,
    required GameDetailRepository gameDetailRepository,
  })  : _gameDetailRepository = gameDetailRepository,
        super(const GameDetailState()) {
    fetchGameDetail(id: id);
  }

  void get resetContent => emit(const GameDetailState());

  Future<void> fetchGameDetail({required int id}) async {
    emit(state.copyWith(status: GameDetailStatus.loading));

    final result = await _gameDetailRepository.fetchGameDetail(id: id);

    switch (result) {
      case Success(value: final gameEntity):
        emit(
          state.copyWith(
            status: GameDetailStatus.success,
            game: gameEntity,
          ),
        );

        getSavedGame(gameId: gameEntity.id);
      case Failure(error: final error):
        emit(state.copyWith(status: GameDetailStatus.failed, error: error));
    }
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
    if (state.game == null) return;

    final SavedGame gameToSave = SavedGame()
      ..gameId = state.game?.id
      ..gameSlug = state.game?.slug
      ..name = state.game?.name
      ..imageUrl = state.game?.imageUrl
      ..dateSaved = DateTime.now()
      ..availablePlatforms = state.game?.platforms
          ?.map((p) => SavedGamePlatform(
                id: p.id,
                name: p.name,
                abbreviation: p.abbreviation,
                logoUrl: p.platformLogo?.url,
              ))
          .toList();

    _gameDetailRepository
        .saveGame(game: gameToSave)
        .then((_) => emit(state.copyWith(savedGame: gameToSave)));
  }

  Future<void> _unsaveGame() async {
    if (state.savedGame == null) return;

    await _gameDetailRepository
        .unsaveGame(id: state.savedGame!.id)
        .then((_) => emit(state.copyWith(savedGame: null)));
  }
}

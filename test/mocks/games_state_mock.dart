import 'package:gaming_library_assessment_flutter/features/games/presentation/blocs/games_state.dart';

import 'game_response_mock.dart';

GamesState get mockExistingGamesState => GamesState(
  status: GamesStatus.success,
  response: mockGamesResponse.toEntity(),
  games: mockGamesResponse.toEntity().items,
);

GamesState get mockInitialGamesState => const GamesState();

import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart';

import 'game_response_mock.dart';

GamesState get mockExistingGamesState => GamesState(
      status: GamesStatus.success,
      response: mockGamesResponse,
      games: mockGamesResponse.results!,
    );

GamesState get mockInitialGamesState => const GamesState();

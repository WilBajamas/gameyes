import 'package:gaming_library_assessment_flutter/core/data/models/games_model.dart';

import 'game_mock.dart';

GamesModel get mockGamesResponse => GamesModel(
      count: 20,
      results: mockListGames,
      next: 'next_url',
      currentPage: 1,
    );

GamesModel get mockGamesResponseEmptyResults => const GamesModel(
      count: 0,
      results: [],
      next: 'next_url',
      currentPage: 2,
    );

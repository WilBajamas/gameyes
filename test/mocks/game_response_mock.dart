import 'package:gaming_library_assessment_flutter/core/data/models/games_response.dart';

import 'game_mock.dart';

GamesResponse get mockGamesResponse =>
    GamesResponse(20, mockListGames, 'next_url', 1);

GamesResponse get mockGamesResponseEmptyResults =>
    const GamesResponse(0, null, null, 2);

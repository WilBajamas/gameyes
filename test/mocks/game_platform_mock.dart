import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';

GamesPlatform get mockGamePlatform =>
    const GamesPlatform(id: 1, name: 'test game platform name', slug: 'slug');

List<GamesPlatform> get mockListGamePlatform =>
    [mockGamePlatform, mockGamePlatform, mockGamePlatform];

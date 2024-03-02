import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';

GamePlatform get mockGamePlatform =>
    const GamePlatform(id: 1, name: 'test game platform name', slug: 'slug');

List<GamePlatform> get mockListGamePlatform =>
    [mockGamePlatform, mockGamePlatform, mockGamePlatform];

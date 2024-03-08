import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';

GameGenre get mockGameGenre => GameGenre.racing;

Set<GameGenre> get mockGameGenres =>
    {GameGenre.shooter, GameGenre.rpg, GameGenre.card};

String get mockGameGenresNames =>
    '${GameGenre.shooter.name}, ${GameGenre.rpg.name}, ${GameGenre.card.name},';

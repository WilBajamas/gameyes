import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/features/featured_revamp/domain/repositories/featured_revamp_repository.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/release_date_entity.dart';

// Dummy data for loading skeleton
class GameLoadingWidgetData {
  GameLoadingWidgetData._();

  static GameEntity get countdownGame => GameEntity(
        id: 0,
        name: S.current.loading_game_title_placeholder,
        cover: const GameCoverEntity(),
        releaseDates: [
          ReleaseDateEntity(
            date: DateTime.now().add(const Duration(days: 3)),
            human: S.current.coming_soon,
          ),
        ],
        criticScore: 90,
        hypes: 100,
      );

  static List<GameEntity> get weeklyReleases => List.generate(
        5,
        (index) => GameEntity(
          id: index + 100,
          name: S.current.loading_game_release_title,
          cover: const GameCoverEntity(),
        ),
      );

  static const countdownDuration = Duration(days: 3, hours: 5, minutes: 12);

  static List<GameEntity> get criticsGames => List.generate(
        4,
        (index) => GameEntity(
          id: index + 200,
          name: S.current.critics_choice_title,
          cover: const GameCoverEntity(),
          criticScore: 85.0,
          releaseDates: [
            ReleaseDateEntity(
              date: DateTime.now(),
              human: S.current.released_2_days_ago,
            ),
          ],
        ),
      );

  static GenrePreferencesEntity get defaultGenrePrefs => GenrePreferencesEntity(
        genreIds: [4, 5],
        isSkipped: false,
      );
}

import '../../../../core/domain/entities/tracker_saved_game_entity.dart';

class LibrarySnapshotEntity {
  final int totalGamesCount;
  final List<TrackerSavedGameEntity> nowPlayingGames;
  final double thisWeekPlayHours;
  final int wishlistCount;
  final Set<int> ownedGameIds;

  LibrarySnapshotEntity({
    required this.totalGamesCount,
    required this.nowPlayingGames,
    required this.thisWeekPlayHours,
    required this.wishlistCount,
    required this.ownedGameIds,
  });
}

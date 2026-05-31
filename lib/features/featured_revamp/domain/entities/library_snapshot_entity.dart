import '../../../../features/tracker/data/models/saved_game.dart';

class LibrarySnapshotEntity {
  final int totalGamesCount;
  final List<SavedGame> nowPlayingGames;
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

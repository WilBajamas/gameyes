import 'now_playing_game_entity.dart';

class LibrarySnapshotEntity {
  final int totalGamesCount;
  final List<NowPlayingGameEntity> nowPlayingGames;
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

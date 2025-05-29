part of 'games_bloc.dart';

sealed class GamesEvent extends Equatable {
  const GamesEvent();
}

final class GamesFetched extends GamesEvent {
  final String? searchTerm;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final Set<GamePlatform>? platforms;
  final GameOrdering? ordering;
  final Set<GameGenre>? genres;
  final bool? ascending;

  const GamesFetched({
     this.searchTerm,
     this.dateFrom,
     this.dateTo,
     this.platforms,
     this.ordering,
     this.genres,
     this.ascending,
  });

  @override
  List<Object?> get props =>
      [searchTerm, dateFrom, dateTo, platforms, ordering, genres, ascending];
}

final class GamesNextPage extends GamesEvent {
  final String? searchTerm;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final Set<GamePlatform>? platforms;
  final GameOrdering? ordering;
  final Set<GameGenre>? genres;
  final bool? ascending;

  const GamesNextPage({
     this.searchTerm,
     this.dateFrom,
     this.dateTo,
     this.platforms,
     this.ordering,
     this.genres,
     this.ascending,
  });

  @override
  List<Object?> get props =>
      [searchTerm, dateFrom, dateTo, platforms, ordering, genres, ascending];
}

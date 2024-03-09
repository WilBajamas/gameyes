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
    required this.searchTerm,
    required this.dateFrom,
    required this.dateTo,
    required this.platforms,
    required this.ordering,
    required this.genres,
    required this.ascending,
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
    required this.searchTerm,
    required this.dateFrom,
    required this.dateTo,
    required this.platforms,
    required this.ordering,
    required this.genres,
    required this.ascending,
  });

  @override
  List<Object?> get props =>
      [searchTerm, dateFrom, dateTo, platforms, ordering, genres, ascending];
}

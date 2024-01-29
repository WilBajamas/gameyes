part of 'games_bloc.dart';

sealed class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object> get props => [];
}

final class GamesFetched extends GamesEvent {
  final bool resetPage;
  final String? searchTerm;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<GamesPlatform> platforms;
  final GameOrdering ordering;

  const GamesFetched({
    required this.resetPage,
    required this.searchTerm,
    required this.dateFrom,
    required this.dateTo,
    required this.platforms,
    required this.ordering,
  });
}

part of 'filter_cubit.dart';

final class FilterState extends Equatable {
  final GameOrdering ordering;
  final Set<GamePlatform> platforms;
  final Set<GameGenre> genres;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? searchTerm;
  final bool ascending;

  const FilterState({
    this.ordering = GameOrdering.released,
    this.platforms = const {},
    this.dateFrom,
    this.dateTo,
    this.searchTerm,
    this.genres = const {},
    this.ascending = false,
  });

  FilterState copyWith({
    GameOrdering? gameOrdering,
    Set<GamePlatform>? platforms,
    Set<GameGenre>? genres,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchTerm,
    bool? ascending,
  }) {
    return FilterState(
      ordering: gameOrdering ?? ordering,
      platforms: platforms ?? this.platforms,
      genres: genres ?? this.genres,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      searchTerm: searchTerm ?? this.searchTerm,
      ascending: ascending ?? this.ascending,
    );
  }

  @override
  List<dynamic> get props =>
      [ordering, platforms, dateFrom, dateTo, searchTerm, genres, ascending];
}

final class FilterInitial extends FilterState {}

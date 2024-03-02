part of 'filter_cubit.dart';

final class FilterState extends Equatable {
  const FilterState({
    this.ordering = GameOrdering.released,
    this.gamesPlatform = const Playstation5(),
    this.dateFrom,
    this.dateTo,
    this.searchTerm,
  });

  final GameOrdering ordering;
  final GamePlatform gamesPlatform;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? searchTerm;

  FilterState copyWith({
    GameOrdering? gameOrdering,
    GamePlatform? gamesPlatform,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchTerm,
  }) {
    return FilterState(
      ordering: gameOrdering ?? ordering,
      gamesPlatform: gamesPlatform ?? this.gamesPlatform,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  List<dynamic> get props =>
      [ordering, gamesPlatform, dateFrom, dateTo, searchTerm];
}

final class FilterInitial extends FilterState {}

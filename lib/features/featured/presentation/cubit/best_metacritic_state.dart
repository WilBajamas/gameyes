part of 'best_metacritic_cubit.dart';

enum BestMetacriticStatus { initial, success, failed, empty, loading }

class BestMetacriticState extends Equatable {
  final BestMetacriticStatus? status;
  final GamesResponse? games;
  final ErrorType? error;

  const BestMetacriticState({
    this.status = BestMetacriticStatus.initial,
    this.games,
    this.error,
  });

  BestMetacriticState copyWith({
    BestMetacriticStatus? status,
    GamesResponse? games,
    ErrorType? error,
  }) =>
      BestMetacriticState(
        status: status ?? this.status,
        games: games ?? this.games,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, games, error];
}
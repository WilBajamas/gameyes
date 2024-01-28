part of 'most_anticipated_cubit.dart';

enum MostAnticipatedStatus { initial, success, failed, empty, loading }

class MostAnticipatedState extends Equatable {
  final MostAnticipatedStatus? status;
  final GamesResponse? games;
  final ErrorType? error;

  const MostAnticipatedState({
    this.status = MostAnticipatedStatus.initial,
    this.games,
    this.error,
  });

  MostAnticipatedState copyWith({
    MostAnticipatedStatus? status,
    GamesResponse? games,
    ErrorType? error,
  }) =>
      MostAnticipatedState(
        status: status ?? this.status,
        games: games ?? this.games,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, games, error];
}

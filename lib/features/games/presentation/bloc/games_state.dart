part of 'games_bloc.dart';

enum GamesStatus { initial, success, failed, empty, loading }

enum GamesNextPageStatus { initial, failed, loading }

final class GamesState extends Equatable {
  final GamesStatus status;
  final GamesNextPageStatus? nextPageStatus;
  final GamesResponse? response;
  final List<Game> games;
  final ErrorType? error;
  final ErrorType? nextPageError;

  const GamesState({
    this.status = GamesStatus.initial,
    this.nextPageStatus = GamesNextPageStatus.initial,
    this.response,
    this.games = const <Game>[],
    this.error,
    this.nextPageError,
  });

  GamesState copyWith({
    GamesStatus? status,
    GamesResponse? response,
    List<Game>? games,
    GamesNextPageStatus? nextPageStatus,
    ErrorType? error,
    ErrorType? nextPageError,
    int? currentPage,
  }) {
    return GamesState(
      status: status ?? this.status,
      nextPageStatus: nextPageStatus ?? this.nextPageStatus,
      response: response ?? this.response,
      games: games ?? this.games,
      error: error ?? this.error,
      nextPageError: nextPageError ?? this.nextPageError,
    );
  }

  @override
  List<Object?> get props =>
      [status, nextPageStatus, response, games, error, nextPageError];
}

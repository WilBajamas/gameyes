part of 'games_bloc.dart';

enum GamesStatus { initial, success, failure }

final class GamesState extends Equatable {
  final GamesStatus status;
  final GamesResponse? response;
  final List<Game> games;

  const GamesState({
    this.status = GamesStatus.initial,
    this.response,
    this.games = const <Game>[],
  });

  GamesState copyWith({
    GamesStatus? status,
    GamesResponse? response,
    List<Game>? games,
  }) {
    return GamesState(
      status: status ?? this.status,
      response: response ?? this.response,
      games: games ?? this.games,
    );
  }

  @override
  List<Object?> get props => [status, response, games];
}

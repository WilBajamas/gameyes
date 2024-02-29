part of 'featured_bloc.dart';

enum FeaturedStatus { initial, success, failed, empty, loading }

class FeaturedState extends Equatable {
  final FeaturedTag tag;
  final FeaturedStatus? status;
  final GamesResponse? response;
  final List<Game> games;
  final ErrorType? error;

  const FeaturedState({
    this.tag = FeaturedTag.newAndTrending,
    this.status = FeaturedStatus.initial,
    this.response,
    this.games = const <Game>[],
    this.error,
  });

  FeaturedState copyWith({
    FeaturedTag? tag,
    FeaturedStatus? status,
    GamesResponse? response,
    List<Game>? games,
    ErrorType? error,
  }) =>
      FeaturedState(
        tag: tag ?? this.tag,
        status: status ?? this.status,
        response: response ?? this.response,
        games: games ?? this.games,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [tag, status, response, games, error];
}

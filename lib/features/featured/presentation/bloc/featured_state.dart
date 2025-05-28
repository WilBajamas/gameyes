part of 'featured_bloc.dart';

enum FeaturedStatus { initial, success, failed, empty, loading }

enum FeaturedNextPageStatus { initial, failed, loading }

class FeaturedState extends Equatable {
  final FeaturedTag tag;
  final Set<GamePlatform> platformsSelected;
  final FeaturedStatus? status;
  final FeaturedNextPageStatus? nextPageStatus;
  final GamesResponse? response;
  final List<Game> games;
  final ErrorType? error;
  final ErrorType? nextPageError;

  const FeaturedState({
    this.tag = FeaturedTag.newAndTrending,
    this.platformsSelected = const <GamePlatform>{},
    this.status = FeaturedStatus.initial,
    this.nextPageStatus = FeaturedNextPageStatus.initial,
    this.response,
    this.games = const <Game>[],
    this.error,
    this.nextPageError,
  });

  FeaturedState copyWith({
    FeaturedTag? tag,
    Set<GamePlatform>? platformsSelected,
    FeaturedStatus? status,
    FeaturedNextPageStatus? nextPageStatus,
    GamesResponse? response,
    List<Game>? games,
    ErrorType? error,
    ErrorType? nextPageError,
  }) =>
      FeaturedState(
        tag: tag ?? this.tag,
        platformsSelected: platformsSelected ?? this.platformsSelected,
        status: status ?? this.status,
        nextPageStatus: nextPageStatus ?? this.nextPageStatus,
        response: response ?? this.response,
        games: games ?? this.games,
        error: error ?? this.error,
        nextPageError: nextPageError ?? this.nextPageError,
      );

  @override
  List<Object?> get props => [
        tag,
        platformsSelected,
        status,
        nextPageStatus,
        response,
        games,
        error,
        nextPageError
      ];
}

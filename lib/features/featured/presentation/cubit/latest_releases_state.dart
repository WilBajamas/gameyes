part of 'latest_releases_cubit.dart';

enum LatestReleasesStatus { initial, success, failed, empty, loading }

class LatestReleasesState extends Equatable {
  final LatestReleasesStatus? status;
  final GamesResponse? games;
  final ErrorType? error;

  const LatestReleasesState({
    this.status = LatestReleasesStatus.initial,
    this.games,
    this.error,
  });

  LatestReleasesState copyWith({
    LatestReleasesStatus? status,
    GamesResponse? games,
    ErrorType? error,
  }) =>
      LatestReleasesState(
        status: status ?? this.status,
        games: games ?? this.games,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, games, error];
}

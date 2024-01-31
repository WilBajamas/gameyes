part of 'game_detail_cubit.dart';

enum GameDetailStatus { loading, success, failed }

final class GameDetailState extends Equatable {
  final GameDetailStatus status;
  final GameDetailResponse? response;
  final ErrorType? error;

  const GameDetailState({
    this.status = GameDetailStatus.loading,
    this.response,
    this.error,
  });

  GameDetailState copyWith({
    GameDetailStatus? status,
    GameDetailResponse? response,
    ErrorType? error,
  }) =>
      GameDetailState(
        status: status ?? this.status,
        error: error,
        response: response,
      );

  @override
  List<Object?> get props => [response, error];
}

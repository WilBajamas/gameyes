part of 'game_detail_cubit.dart';

enum GameDetailStatus { loading, success, failed }

final class GameDetailState extends Equatable {
  final GameDetailStatus? status;
  final GameDetailResponse? response;
  final ErrorType? error;
  final bool contentExpanded;

  const GameDetailState({
    this.status,
    this.response,
    this.error,
    this.contentExpanded = false,
  });

  GameDetailState copyWith({
    GameDetailStatus? status,
    GameDetailResponse? response,
    ErrorType? error,
    bool? contentExpanded,
  }) =>
      GameDetailState(
        status: status ?? this.status,
        error: error ?? this.error,
        response: response ?? this.response,
        contentExpanded: contentExpanded ?? this.contentExpanded,
      );

  @override
  List<Object?> get props => [response, error, status, contentExpanded];
}

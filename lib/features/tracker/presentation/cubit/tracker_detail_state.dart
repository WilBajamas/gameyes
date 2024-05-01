part of 'tracker_detail_cubit.dart';

class TrackerDetailState extends Equatable {
  final SavedGame? game;

  const TrackerDetailState({this.game});

  @override
  List<Object?> get props => [game];
}

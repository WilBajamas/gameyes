part of 'home_cubit.dart';

enum CurrentTabScreen { featured, games, settings }

class HomeState extends Equatable {
  final CurrentTabScreen currentTabScreen;

  HomeState copyWith({
    CurrentTabScreen? currentTabScreen,
  }) {
    return HomeState(
      currentTabScreen: currentTabScreen ?? this.currentTabScreen,
    );
  }

  const HomeState({
    this.currentTabScreen = CurrentTabScreen.games,
  });

  @override
  List<Object?> get props => [
        currentTabScreen,
      ];
}

part of 'featured_filter_cubit.dart';

class FeaturedFilterState extends Equatable {
  final Set<GamePlatform> platformsSelected;
  final Set<GamePlatform> tempPlatformsSelected;

  const FeaturedFilterState({
    this.platformsSelected = const {},
    this.tempPlatformsSelected = const {},
  });

  FeaturedFilterState copyWith({
    Set<GamePlatform>? platformsSelected,
    Set<GamePlatform>? tempPlatformsSelected,
  }) =>
      FeaturedFilterState(
        platformsSelected: platformsSelected ?? this.platformsSelected,
        tempPlatformsSelected:
            tempPlatformsSelected ?? this.tempPlatformsSelected,
      );

  @override
  List<Object?> get props => [
        platformsSelected,
        tempPlatformsSelected,
      ];
}

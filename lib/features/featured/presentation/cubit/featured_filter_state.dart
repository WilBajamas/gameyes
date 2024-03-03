part of 'featured_filter_cubit.dart';

class FeaturedFilterState extends Equatable {
  final Set<GamePlatfom> platformsSelected;

  const FeaturedFilterState({this.platformsSelected = const {}});

  FeaturedFilterState copyWith(
    Set<GamePlatfom> platformsSelected,
  ) {
    return FeaturedFilterState(platformsSelected: platformsSelected);
  }

  @override
  List<Object?> get props => [platformsSelected];
}

part of 'featured_bloc.dart';

sealed class FeaturedEvent extends Equatable {
  const FeaturedEvent();
}

final class FeaturedFetched extends FeaturedEvent {
  final FeaturedTag tag;
  final Set<GamePlatform>? platforms;

  const FeaturedFetched({
    required this.tag,
    this.platforms,
  });

  @override
  List<Object?> get props => [
        tag,
        platforms,
      ];
}

final class FeaturedNextPage extends FeaturedEvent {
  const FeaturedNextPage();

  @override
  List<Object> get props => [];
}

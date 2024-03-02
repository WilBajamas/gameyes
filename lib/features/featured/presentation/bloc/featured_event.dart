part of 'featured_bloc.dart';

sealed class FeaturedEvent extends Equatable {
  const FeaturedEvent();
}

final class FeaturedFetched extends FeaturedEvent {
  final FeaturedTag tag;
  final List<GamePlatform>? platforms;

  const FeaturedFetched({
    required this.tag,
    this.platforms,
  });

  @override
  List<Object?> get props => [
        tag,
      ];
}

final class FeaturedNextPage extends FeaturedEvent {
  const FeaturedNextPage();

  @override
  List<Object> get props => [];
}

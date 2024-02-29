part of 'featured_bloc.dart';

sealed class FeaturedEvent extends Equatable {
  const FeaturedEvent();
}

final class FeaturedFetched extends FeaturedEvent {
  final FeaturedTag tag;

  const FeaturedFetched({
    required this.tag,
  });

  @override
  List<Object?> get props => [
        tag,
      ];
}

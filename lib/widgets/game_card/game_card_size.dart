const double coverAspectRatio = 3 / 4;

enum GameCardSize {
  xs(width: 64, footerHeight: 0),
  sm(width: 132, footerHeight: 56),
  md(width: 220, footerHeight: 126);

  const GameCardSize({required this.width, required this.footerHeight});

  final double width;
  final double footerHeight;

  bool get fillsParent => this == GameCardSize.md;

  bool get hasFooter => this != GameCardSize.xs;

  double cellHeightFor(double cardWidth) =>
      cardWidth / coverAspectRatio + footerHeight;
}

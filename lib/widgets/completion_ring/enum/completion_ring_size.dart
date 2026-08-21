const double _ringInset = 2;

enum CompletionRingSize {
  inline(box: 60, stroke: 6, figureSize: 14, showsCaption: false),
  specimen(box: 80, stroke: 8, figureSize: 18, showsCaption: true),
  detail(box: 88, stroke: 8, figureSize: 22, showsCaption: true);

  const CompletionRingSize({
    required this.box,
    required this.stroke,
    required this.figureSize,
    required this.showsCaption,
  });

  final double box;
  final double stroke;
  final double figureSize;
  final bool showsCaption;

  double get radius => (box - _ringInset * 2 - stroke) / 2;
}

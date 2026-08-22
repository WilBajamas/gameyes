import 'package:flutter/widgets.dart';

enum CountdownForm {
  card(
    figureSize: 22,
    blockMinWidth: 40,
    blockPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    isGlass: false,
  ),
  tile(
    figureSize: 30,
    blockMinWidth: 52,
    blockPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    isGlass: true,
  );

  const CountdownForm({
    required this.figureSize,
    required this.blockMinWidth,
    required this.blockPadding,
    required this.isGlass,
  });

  final double figureSize;
  final double blockMinWidth;
  final EdgeInsets blockPadding;
  final bool isGlass;
}

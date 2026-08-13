import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

enum PlaceholderSlotSize {
  appMark(dimension: 88),
  providerMark(dimension: 20);

  const PlaceholderSlotSize({required this.dimension});

  final double dimension;

  bool get isAppMark => this == PlaceholderSlotSize.appMark;
}

class PlaceholderSlot extends StatelessWidget {
  const PlaceholderSlot({super.key, required this.size});

  final PlaceholderSlotSize size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final marker = tokens.typography.zoneLabel;

    return SizedBox.square(
      dimension: size.dimension,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.ink12,
          borderRadius: BorderRadius.circular(switch (size) {
            PlaceholderSlotSize.appMark => 20,
            PlaceholderSlotSize.providerMark => tokens.radius.xs,
          }),
          border: Border.all(color: tokens.color.ink24),
        ),
        child: size.isAppMark
            ? Center(
                child: Text(
                  'LOGO',
                  style: marker.style.copyWith(
                    fontSize: 14,
                    letterSpacing: 2.24,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

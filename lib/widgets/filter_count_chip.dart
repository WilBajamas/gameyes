import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class FilterCountChip extends StatelessWidget {
  const FilterCountChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.count,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final labelStyle = tokens.typography.meta.style;
    final count = this.count;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Center(
          widthFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected ? colors.accentIndigo : colors.ink08,
              borderRadius: BorderRadius.circular(tokens.radius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: labelStyle.copyWith(color: colors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (count != null)
                    Text(
                      '$count',
                      style: labelStyle.copyWith(
                        color: isSelected ? colors.ink : colors.ink55,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

class ContextChip extends StatelessWidget {
  const ContextChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final pill = tokens.typography.pill;

    return GlassSurface(
      fill: colors.glass32,
      borderRadius: BorderRadius.circular(tokens.radius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(icon, size: 12, color: colors.ink),
            Flexible(
              child: Text(
                pill.format(label),
                style: pill.style.copyWith(color: colors.ink),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

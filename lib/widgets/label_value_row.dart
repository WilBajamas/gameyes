import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class LabelValueRow extends StatelessWidget {
  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.showChevron = false,
  });

  final String label;
  final String value;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final meta = tokens.typography.meta.style;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Text(
              label,
              style: meta.copyWith(color: tokens.color.ink),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (showChevron)
            Icon(Icons.chevron_right, size: 16, color: tokens.color.ink55),
        ],
      ),
    );
  }
}

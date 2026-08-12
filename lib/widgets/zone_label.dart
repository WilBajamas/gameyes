import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ZoneLabel extends StatelessWidget {
  const ZoneLabel({
    super.key,
    required this.label,
    this.linkLabel,
    this.onLinkPressed,
  });

  final String label;
  final String? linkLabel;
  final VoidCallback? onLinkPressed;

  @override
  Widget build(BuildContext context) {
    final zoneLabel = context.tokens.typography.zoneLabel;
    // Locals so the two link fields promote to non-null inside the if below.
    final linkLabel = this.linkLabel;
    final onLinkPressed = this.onLinkPressed;

    // No padding or margin here on purpose: the gap between zones is the
    // caller's to apply, so this sits flush in whatever bounds it is given.
    return Row(
      children: [
        Expanded(
          child: Text(
            zoneLabel.format(label),
            style: zoneLabel.style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (linkLabel != null && onLinkPressed != null)
          _ZoneLink(label: linkLabel, onPressed: onLinkPressed),
      ],
    );
  }
}

class _ZoneLink extends StatelessWidget {
  const _ZoneLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      // Height only - the link keeps its 13px text and its own width.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Center(
          child: Text(label, style: context.tokens.typography.zoneLink.style),
        ),
      ),
    );
  }
}

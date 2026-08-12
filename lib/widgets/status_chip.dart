import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_status_tokens.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

import '../generated/l10n.dart';

enum StatusChipVariant {
  onMedia(dotSize: 6),
  list(dotSize: 7);

  const StatusChipVariant({required this.dotSize});

  final double dotSize;
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
    required this.variant,
    this.count,
  });

  final LibraryStatus status;
  final StatusChipVariant variant;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.color;
    final pill = context.tokens.typography.pill;
    final count = this.count;

    final statusToken = switch (status) {
      LibraryStatus.playing => colors.status.playing,
      LibraryStatus.backlog => colors.status.backlog,
      LibraryStatus.completed => colors.status.completed,
      LibraryStatus.onHold => colors.status.onHold,
      LibraryStatus.wishlist => colors.status.wishlist,
      LibraryStatus.dropped => colors.status.dropped,
    };

    final label = switch (status) {
      LibraryStatus.playing => S.current.playing,
      LibraryStatus.backlog => S.current.backlog,
      LibraryStatus.completed => S.current.completed,
      LibraryStatus.onHold => S.current.onHold,
      LibraryStatus.wishlist => S.current.wishlist,
      LibraryStatus.dropped => S.current.dropped,
    };

    final filled = statusToken.treatment == StatusTreatment.filled;

    // The filled pill already carries the status hue, so its dot reverts to
    // ink - reading the token's own colour would hide it against the fill.
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          _StatusDot(
            color: filled ? colors.ink : statusToken.color,
            size: variant.dotSize,
          ),
          Flexible(
            child: Text(
              pill.format(label),
              style: pill.style.copyWith(color: colors.ink),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (count != null)
            Text(
              '$count',
              style: pill.style.copyWith(
                color: filled ? colors.ink : colors.ink55,
              ),
            ),
        ],
      ),
    );

    final borderRadius = BorderRadius.circular(context.tokens.radius.pill);

    if (variant == StatusChipVariant.onMedia && !filled) {
      return GlassSurface(
        fill: colors.glass42,
        borderRadius: borderRadius,
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: statusToken.fill,
        borderRadius: borderRadius,
      ),
      child: content,
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

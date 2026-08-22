import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/countdown_digit_row.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/enum/countdown_form.dart';

class CountdownCard extends StatelessWidget {
  const CountdownCard({
    super.key,
    required this.title,
    required this.isWishlisted,
    required this.remaining,
    required this.onOpen,
    this.releaseDateText,
    this.onRemind,
  });

  final String title;
  final bool isWishlisted;
  final Duration? remaining;
  final String? releaseDateText;
  final VoidCallback onOpen;
  final VoidCallback? onRemind;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final remind = onRemind;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpen,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.surfaceRaised,
          borderRadius: BorderRadius.circular(tokens.radius.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              _ReasonLine(isWishlisted: isWishlisted),
              Text(
                title.toUpperCase(),
                style: tokens.typography.cardHeading.style,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              CountdownDigitRow(
                form: CountdownForm.card,
                remaining: remaining,
                releaseDateText: releaseDateText,
              ),
              if (remind != null) _RemindAction(onPressed: remind),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonLine extends StatelessWidget {
  const _ReasonLine({required this.isWishlisted});

  final bool isWishlisted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    if (!isWishlisted) {
      return Text(
        S.current.most_anticipated,
        style: tokens.typography.zoneLink.style.copyWith(
          color: tokens.color.ink55,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Icon(
          Icons.bookmark_outline,
          size: 14,
          color: tokens.color.accentLinkCyan,
        ),
        Flexible(
          child: Text(
            S.current.on_your_wishlist,
            style: tokens.typography.zoneLink.style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RemindAction extends StatelessWidget {
  const _RemindAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: tokens.color.ink12,
          borderRadius: BorderRadius.circular(tokens.radius.xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(Icons.notifications_none, size: 14, color: tokens.color.ink),
            Text(
              S.current.remind,
              style: tokens.typography.zoneLink.style.copyWith(
                color: tokens.color.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

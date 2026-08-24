import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/enum/error_notice_variant.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_dot.dart';

class ErrorNotice extends StatelessWidget {
  const ErrorNotice({
    super.key,
    required this.variant,
    required this.message,
    required this.onDismiss,
  });

  final ErrorNoticeVariant variant;
  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      ErrorNoticeVariant.strip => _ErrorStrip(
        message: message,
        onDismiss: onDismiss,
      ),
      ErrorNoticeVariant.toast => _ErrorToast(message: message),
    };
  }
}

class _ErrorStrip extends StatelessWidget {
  const _ErrorStrip({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.errorTint,
        border: Border.all(color: tokens.color.errorLine),
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                message,
                style: tokens.typography.meta.style.copyWith(
                  color: tokens.color.errorInk,
                ),
              ),
            ),
            Semantics(
              container: true,
              button: true,
              label: MaterialLocalizations.of(context).closeButtonTooltip,
              child: InkWell(
                onTap: onDismiss,
                child: SizedBox.square(
                  dimension: 44,
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: tokens.color.errorInk,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorToast extends StatelessWidget {
  const _ErrorToast({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius.sm),
      child: ColoredBox(
        color: tokens.color.surfaceToast,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            spacing: 8,
            children: [
              const ErrorDot(size: 8),
              Expanded(
                child: Text(
                  message,
                  style: tokens.typography.meta.style.copyWith(
                    color: tokens.color.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

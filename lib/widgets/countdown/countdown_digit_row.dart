import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/enum/countdown_form.dart';
import 'package:gaming_library_assessment_flutter/widgets/glass_surface_widget.dart';

class CountdownDigitRow extends StatelessWidget {
  const CountdownDigitRow({
    super.key,
    required this.form,
    required this.remaining,
    this.releaseDateText,
  });

  final CountdownForm form;
  final Duration? remaining;
  final String? releaseDateText;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final time = remaining;

    if (time == null) {
      final date = releaseDateText;

      if (date != null) {
        return Text(
          date,
          style: tokens.typography.meta.style.copyWith(
            color: tokens.color.ink55,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }

      return Text(
        tokens.typography.pill.format(S.current.countdown_date_unannounced),
        style: tokens.typography.pill.style.copyWith(color: tokens.color.ink55),
        maxLines: 1,
      );
    }

    if (time <= Duration.zero) {
      return Text(
        tokens.typography.pill.format(S.current.countdown_released),
        style: tokens.typography.pill.style.copyWith(color: tokens.color.ink),
        maxLines: 1,
      );
    }

    final days = time.inDays.toString().padLeft(2, '0');
    final hours = (time.inHours % 24).toString().padLeft(2, '0');
    final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: S.current.countdown_time_remaining(days, hours, minutes),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        spacing: 6,
        children: [
          _CountdownUnit(
            form: form,
            value: days,
            label: S.current.countdown_days,
          ),
          _CountdownColon(form: form),
          _CountdownUnit(
            form: form,
            value: hours,
            label: S.current.countdown_hours,
          ),
          _CountdownColon(form: form),
          _CountdownUnit(
            form: form,
            value: minutes,
            label: S.current.countdown_minutes,
          ),
        ],
      ),
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  const _CountdownUnit({
    required this.form,
    required this.value,
    required this.label,
  });

  final CountdownForm form;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final radius = BorderRadius.circular(tokens.radius.xs);
    final figure = Padding(
      padding: form.blockPadding,
      child: Text(
        value,
        style: tokens.typography.countdownFigure.style.copyWith(
          fontSize: form.figureSize,
        ),
        maxLines: 1,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: form.blockMinWidth),
          child: form.isGlass
              ? GlassSurface(
                  fill: tokens.color.glass32,
                  borderRadius: radius,
                  child: figure,
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.color.ink08,
                    borderRadius: radius,
                  ),
                  child: figure,
                ),
        ),
        Text(
          tokens.typography.microLabel.format(label),
          style: tokens.typography.microLabel.style.copyWith(
            color: tokens.color.ink55,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

class _CountdownColon extends StatelessWidget {
  const _CountdownColon({required this.form});

  final CountdownForm form;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Text(
      ':',
      style: tokens.typography.countdownColon.style.copyWith(
        color: form.isGlass ? tokens.color.countdownColon : tokens.color.ink12,
      ),
    );
  }
}

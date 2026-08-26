import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/color.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class DefaultSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final (Widget actionOne, VoidCallback? actionPressed)? actionOne;
  final (Widget actionTwo, VoidCallback? actionPressed)? actionTwo;

  const DefaultSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actionOne,
    this.actionTwo,
  });

  static const double _titleMaxFontSize = 34;
  static const double _titleMinFontSize = 22;
  static const double _subtitleMaxFontSize = 13;
  static const double _subtitleMinFontSize = 11;
  static const double _maxTextScale = 1;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: _maxTextScale).scale(1);

    return SliverAppBar(
      toolbarHeight: kToolbarHeight + 12,
      backgroundColor: context.themeData.scaffoldBackgroundColor,
      actions: [
        if (actionOne?.$1 != null)
          InkWell(onTap: actionOne!.$2, child: actionOne!.$1),
        if (actionTwo?.$1 != null)
          InkWell(onTap: actionTwo!.$2, child: actionTwo!.$1),
      ],
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              title,
              maxLines: 1,
              minFontSize: _titleMinFontSize,
              maxFontSize: _titleMaxFontSize,
              textScaleFactor: textScale,
              overflow: TextOverflow.ellipsis,
              style: context.themeData.textTheme.displayLarge!
                  .copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 4,
            ),
            if (subtitle case final subtitle?)
              AutoSizeText(
                subtitle,
                maxLines: 1,
                minFontSize: _subtitleMinFontSize,
                maxFontSize: _subtitleMaxFontSize,
                textScaleFactor: textScale,
                overflow: TextOverflow.ellipsis,
                style: context.themeData.textTheme.bodySmall!
                    .copyWith(color: ColorPalette.textGrey),
              ),
          ],
        ),
      ),
    );
  }
}

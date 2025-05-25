import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class DefaultSnackbar extends SnackBar {
  DefaultSnackbar({
    super.key,
    required String text,
  }) : super(
          backgroundColor: kColorScheme.primary,
          content: Builder(
            builder: (context) {
              return Text(
                text,
                style: context.themeData.textTheme.bodySmall!
                    .copyWith(color: Colors.white),
              );
            },
          ),
        );
}

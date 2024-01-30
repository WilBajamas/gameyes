/* This file is only for general extension functions.
  If you have specific functions you wish to extend for architecture components
  - specify them within their own folders */

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  ThemeData get themeData => Theme.of(this);
  AppLocalizations get localisations => AppLocalizations.of(this)!;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

extension DateFormatters on String? {
  String formatDate() {
    try {
      if (this != null) {
        final dateTime = DateFormat('yyyy-MM-dd').parse(this!);
        return DateFormat('d MMMM yyyy').format(dateTime);
      }
      return StringConstants.emptyStringPlaceholder;
    } on Exception {
      return StringConstants.emptyStringPlaceholder;
    }
  }
}

// ** Nullable (Date time)
extension DateTimeNullableExtension on DateTime? {
  String? getFormattedStringFromDateTime() {
    if (this != null) {
      return DateFormat('yyyy-MM-dd').format(this!);
    }

    return null;
  }
}

// ** Non null (Date time)
extension DateTimeExtension on DateTime {
  String getStringFromDateTime() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String getFormattedDateMonthsAgo({int monthsAgo = 0}) {
    final dateMonthsAgo = DateTime(year, month - monthsAgo, day);
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateMonthsAgo);
    return formattedDate;
  }

  String getFormattedDateYearsRange({int years = 0, bool after = false}) {
    final dateYearsAgo =
        DateTime(after ? year + years : year - years, month, day);
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateYearsAgo);
    return formattedDate;
  }

  DateTime getDateTimeLater({
    int yearsLater = 0,
    int monthsLater = 0,
    int daysLater = 0,
  }) {
    return DateTime(year + yearsLater, month + monthsLater, day + daysLater);
  }
}

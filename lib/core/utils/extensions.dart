/* This file is only for general extension functions.
  If you have specific functions you wish to extend for architecture components
  - specify them within their own folders */

import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  ThemeData get themeData => Theme.of(this);
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

extension DateFormatters on String? {
  String? formatDate() {
    try {
      final dateTime = DateFormat('yyyy-MM-dd').parse(this!);
      return DateFormat('d MMMM yyyy').format(dateTime);
    } on Exception {
      return StringConstants.emptyStringPlaceholder;
    }
  }
}

extension DateTimeExtension on DateTime {
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
}

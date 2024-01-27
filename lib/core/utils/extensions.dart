/* This file is only for general extension functions.
  If you have specific functions you wish to extend for architecture components
  - specify them within their own folders */

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  ThemeData themeData() => Theme.of(this);
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidget => MediaQuery.of(this).size.width;
}

extension DateFormatters on String? {
  String? formatDate() {
    try {
      DateTime? dateTime = DateTime.tryParse(this ?? '-');
      return DateFormat('MMMM y').format(dateTime ?? DateTime.now());
    } on Exception {
      return '-';
    }
  }

  DateTime stringToDatetime() {
    try {
      return DateFormat('yyyy-MM-dd').parse(this ?? '');
    } catch (_) {
      return DateTime.now();
    }
  }
}

extension DateToStringFormatters on DateTime {
  String? formatDate({required String format}) {
    try {
      return DateFormat(format).format(this);
    } on Exception {
      return '-';
    }
  }
}

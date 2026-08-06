import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';

ReleaseDate get mockReleaseDate =>
    const ReleaseDate(date: 1735689600, human: 'Jan 01, 2025', category: 0);

List<Map<String, dynamic>> get mockReleaseDatesJson => [
  mockReleaseDate.toJson(),
  mockReleaseDate.toJson(),
];

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/release_date_entity.dart';

part 'release_date.freezed.dart';
part 'release_date.g.dart';

@freezed
sealed class ReleaseDate with _$ReleaseDate {
  const ReleaseDate._();

  const factory ReleaseDate({
    int? date,
    String? human,
  }) = _ReleaseDate;

  factory ReleaseDate.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDateFromJson(json);

  ReleaseDateEntity toEntity() => ReleaseDateEntity(
        date: DateTime.fromMillisecondsSinceEpoch((date ?? 0) * 1000),
        human: human ?? '',
      );
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'developer.freezed.dart';
part 'developer.g.dart';

@freezed
sealed class Developer with _$Developer {
  const factory Developer({int? id, String? name}) = _Developer;
  factory Developer.fromJson(Map<String, dynamic> json) =>
      _$DeveloperFromJson(json);
}

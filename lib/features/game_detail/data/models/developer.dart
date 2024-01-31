import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'developer.g.dart';

@JsonSerializable()
final class Developer extends Equatable {
  final int? id;

  final String? name;

  const Developer(this.id, this.name);

  factory Developer.fromJson(Map<String, dynamic> json) =>
      _$DeveloperFromJson(json);

  Map<String, dynamic> toJson() => _$DeveloperToJson(this);

  @override
  List<Object?> get props => [id, name];
}

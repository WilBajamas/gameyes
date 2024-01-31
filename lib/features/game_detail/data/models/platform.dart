import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'platform.g.dart';

@JsonSerializable()
final class Platform extends Equatable {
  final int? id;

  final String? name;

  const Platform(this.id, this.name);

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformToJson(this);

  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publisher.g.dart';

@JsonSerializable()
final class Publisher extends Equatable {
  final int? id;

  final String? name;

  const Publisher(this.id, this.name);

  factory Publisher.fromJson(Map<String, dynamic> json) =>
      _$PublisherFromJson(json);

  Map<String, dynamic> toJson() => _$PublisherToJson(this);

  @override
  List<Object?> get props => [];
}

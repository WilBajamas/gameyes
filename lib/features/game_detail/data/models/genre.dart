import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable()
final class Genre extends Equatable {
  final int? id;

  final String? name;

  const Genre(this.id, this.name);

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);

  @override
  List<Object?> get props => [id, name];
}

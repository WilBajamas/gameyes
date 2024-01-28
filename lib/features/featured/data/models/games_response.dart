import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/features/featured/data/models/game.dart';
import 'package:json_annotation/json_annotation.dart';

part 'games_response.g.dart';

@JsonSerializable()
class GamesResponse extends Equatable {
  final int count;

  final String? next;

  final List<Game>? results;

  const GamesResponse(this.count, this.results, this.next);

  factory GamesResponse.fromJson(Map<String, dynamic> json) =>
      _$GamesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GamesResponseToJson(this);

  @override
  List<Object?> get props => [count, next, results];
}

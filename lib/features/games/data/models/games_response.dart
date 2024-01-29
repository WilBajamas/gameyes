import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/features/games/data/models/game.dart';
import 'package:json_annotation/json_annotation.dart';

part 'games_response.g.dart';

@JsonSerializable()
final class GamesResponse extends Equatable {
  final int count;

  final int? currentPage;

  final String? next;

  final List<Game>? results;

  const GamesResponse(this.count, this.results, this.next, this.currentPage);

  GamesResponse copyWith({
    int? count,
    int? currentPage,
    String? next,
    List<Game>? results,
  }) =>
      GamesResponse(
        count ?? this.count,
        results ?? this.results,
        next ?? this.next,
        currentPage ?? this.currentPage,
      );

  factory GamesResponse.fromJson(Map<String, dynamic> json) =>
      _$GamesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GamesResponseToJson(this);

  @override
  List<Object?> get props => [count, next, results];
}

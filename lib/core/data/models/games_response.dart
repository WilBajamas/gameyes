import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';

part 'games_response.freezed.dart';
part 'games_response.g.dart';

@freezed
sealed class GamesResponse with _$GamesResponse {
  const factory GamesResponse({
    required int count,
    int? currentPage,
    String? next,
    List<Game>? results,
  }) = _GamesResponse;

  factory GamesResponse.fromJson(Map<String, dynamic> json) =>
      _$GamesResponseFromJson(json);
}

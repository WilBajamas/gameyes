import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_list_entity.dart';

part 'games_model.freezed.dart';
part 'games_model.g.dart';

@freezed
sealed class GamesModel with _$GamesModel {
  const GamesModel._();

  const factory GamesModel({
    required int count,
    int? currentPage,
    String? next,
    List<Game>? results,
  }) = _GamesModel;

  factory GamesModel.fromJson(Map<String, dynamic> json) =>
      _$GamesModelFromJson(json);

  GameListEntity toEntity() => GameListEntity(
        totalCount: count,
        currentPage: currentPage,
        nextUrl: next,
        items: results?.map((e) => e.toEntity()).toList() ?? [],
      );
}

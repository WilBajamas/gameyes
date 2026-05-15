import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_keyword_entity.dart';

part 'game_keyword.freezed.dart';
part 'game_keyword.g.dart';

@freezed
sealed class GameKeyword with _$GameKeyword {
  const GameKeyword._();

  const factory GameKeyword({
    String? name,
  }) = _GameKeyword;

  factory GameKeyword.fromJson(Map<String, dynamic> json) =>
      _$GameKeywordFromJson(json);

  GameKeywordEntity toEntity() => GameKeywordEntity(
        name: name ?? '',
      );
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_keyword_entity.freezed.dart';

@freezed
sealed class GameKeywordEntity with _$GameKeywordEntity {
  const factory GameKeywordEntity({required String name}) = _GameKeywordEntity;
}

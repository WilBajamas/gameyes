import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';

part 'game_list_entity.freezed.dart';

@freezed
sealed class GameListEntity with _$GameListEntity {
  const factory GameListEntity({
    required int totalCount,
    required List<GameEntity> items,
    int? currentPage,
    String? nextUrl,
  }) = _GameListEntity;
}

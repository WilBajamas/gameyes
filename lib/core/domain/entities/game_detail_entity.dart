import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';

part 'game_detail_entity.freezed.dart';

@freezed
sealed class GameDetailEntity with _$GameDetailEntity {
  const GameDetailEntity._();

  const factory GameDetailEntity({
    required int id,
    required String name,
    String? slug,
    int? metacritic,
    String? releaseDate,
    String? description,
    String? imageUrl,
    String? additionalImageUrl,
    List<GamePlatform>? platforms,
    List<String>? developers,
    List<String>? genres,
    List<String>? publishers,
  }) = _GameDetailEntity;

  String get genreDisplay => genres?.join(', ') ?? '';
  String get developerDisplay => developers?.join(', ') ?? '';
  String get publisherDisplay => publishers?.join(', ') ?? '';
  String get platformDisplay => platforms?.map((e) => e.name).join(', ') ?? '';
}

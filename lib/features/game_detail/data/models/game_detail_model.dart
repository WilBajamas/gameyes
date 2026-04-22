import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_detail_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/mappers/platform_mapper.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/developer.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/genre.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform_item.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/publisher.dart';

part 'game_detail_model.freezed.dart';
part 'game_detail_model.g.dart';

@freezed
sealed class GameDetailModel with _$GameDetailModel {
  const GameDetailModel._();

  const factory GameDetailModel({
    int? id,
    String? name,
    String? slug,
    int? metacritic,
    String? released,
    @JsonKey(name: 'background_image') String? backgroundImage,
    @JsonKey(name: 'background_image_additional')
    String? backgroundImageAdditional,
    List<PlatformItem>? platforms,
    List<Developer>? developers,
    List<Genre>? genres,
    List<Publisher>? publishers,
    @JsonKey(name: 'description_raw') String? description,
  }) = _GameDetailModel;

  factory GameDetailModel.fromJson(Map<String, dynamic> json) =>
      _$GameDetailModelFromJson(json);

  GameDetailEntity toEntity() => GameDetailEntity(
        id: id ?? 0,
        name: name ?? 'Unknown',
        slug: slug,
        metacritic: metacritic,
        releaseDate: released,
        description: description,
        imageUrl: backgroundImage,
        additionalImageUrl: backgroundImageAdditional,
        platforms: platforms
            ?.map((p) => p.platform?.id?.toEntity())
            .whereType<GamePlatform>()
            .toList(),
        developers: developers?.map((d) => d.name ?? '').toList(),
        genres: genres?.map((g) => g.name ?? '').toList(),
        publishers: publishers?.map((p) => p.name ?? '').toList(),
      );
}

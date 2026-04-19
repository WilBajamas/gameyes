import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/developer.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/genre.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform_item.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/publisher.dart';

part 'game_detail_response.freezed.dart';
part 'game_detail_response.g.dart';

@freezed
sealed class GameDetailResponse with _$GameDetailResponse {
  const GameDetailResponse._();

  const factory GameDetailResponse({
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
  }) = _GameDetailResponse;

  String? get genreListString => genres?.map((e) => e.name).join(', ');
  String? get developerListString => developers?.map((e) => e.name).join(', ');
  String? get publisherListString => publishers?.map((e) => e.name).join(', ');
  String? get platformListString =>
      platforms?.map((e) => e.platform?.name).join(', ');

  factory GameDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GameDetailResponseFromJson(json);
}

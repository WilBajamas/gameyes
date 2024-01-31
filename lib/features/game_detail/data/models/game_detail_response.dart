import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/developer.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/genre.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform_item.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/publisher.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_detail_response.g.dart';

@JsonSerializable()
final class GameDetailResponse extends Equatable {
  final String? name;

  final int? metacritic;

  final String? released;

  @JsonKey(name: 'background_image')
  final String? backgroundImage;

  @JsonKey(name: 'background_image_additional')
  final String? backgroundImageAdditional;

  final List<PlatformItem>? platforms;

  final List<Developer>? developers;

  final List<Genre>? genres;

  final List<Publisher>? publishers;

  @JsonKey(name: 'description_raw')
  final String? description;

  String? get genreListString => genres?.map((e) => e.name).join(', ');
  String? get developerListString => developers?.map((e) => e.name).join(', ');
  String? get publisherListString => publishers?.map((e) => e.name).join(', ');
  String? get platformListString =>
      platforms?.map((e) => e.platform?.name).join(', ');

  const GameDetailResponse(
    this.name,
    this.metacritic,
    this.released,
    this.backgroundImage,
    this.backgroundImageAdditional,
    this.platforms,
    this.developers,
    this.genres,
    this.publishers,
    this.description,
  );

  factory GameDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GameDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GameDetailResponseToJson(this);

  @override
  List<Object?> get props => [
        name,
        metacritic,
        released,
        backgroundImage,
        backgroundImageAdditional,
        platforms,
        developers,
        genres,
        publishers,
        description,
      ];
}

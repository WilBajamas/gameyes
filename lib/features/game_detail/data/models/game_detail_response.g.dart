// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDetailResponse _$GameDetailResponseFromJson(Map<String, dynamic> json) =>
    GameDetailResponse(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['slug'] as String?,
      (json['metacritic'] as num?)?.toInt(),
      json['released'] as String?,
      json['background_image'] as String?,
      json['background_image_additional'] as String?,
      (json['platforms'] as List<dynamic>?)
          ?.map((e) => PlatformItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['developers'] as List<dynamic>?)
          ?.map((e) => Developer.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['genres'] as List<dynamic>?)
          ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['publishers'] as List<dynamic>?)
          ?.map((e) => Publisher.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['description_raw'] as String?,
    );

Map<String, dynamic> _$GameDetailResponseToJson(GameDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'metacritic': instance.metacritic,
      'released': instance.released,
      'background_image': instance.backgroundImage,
      'background_image_additional': instance.backgroundImageAdditional,
      'platforms': instance.platforms,
      'developers': instance.developers,
      'genres': instance.genres,
      'publishers': instance.publishers,
      'description_raw': instance.description,
    };

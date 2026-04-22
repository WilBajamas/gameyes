// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameDetailModel _$GameDetailModelFromJson(Map<String, dynamic> json) =>
    _GameDetailModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      metacritic: (json['metacritic'] as num?)?.toInt(),
      released: json['released'] as String?,
      backgroundImage: json['background_image'] as String?,
      backgroundImageAdditional: json['background_image_additional'] as String?,
      platforms: (json['platforms'] as List<dynamic>?)
          ?.map((e) => PlatformItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      developers: (json['developers'] as List<dynamic>?)
          ?.map((e) => Developer.fromJson(e as Map<String, dynamic>))
          .toList(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      publishers: (json['publishers'] as List<dynamic>?)
          ?.map((e) => Publisher.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description_raw'] as String?,
    );

Map<String, dynamic> _$GameDetailModelToJson(_GameDetailModel instance) =>
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Game _$GameFromJson(Map<String, dynamic> json) => _Game(
      id: (json['id'] as num?)?.toInt(),
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      released: json['released'] as String?,
      backgroundImage: json['background_image'] as String?,
      metacritic: (json['metacritic'] as num?)?.toInt(),
      platforms: (json['platforms'] as List<dynamic>?)
          ?.map((e) => PlatformItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameToJson(_Game instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'released': instance.released,
      'background_image': instance.backgroundImage,
      'metacritic': instance.metacritic,
      'platforms': instance.platforms,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      json['id'] as int?,
      json['slug'] as String?,
      json['name'] as String?,
      json['released'] as String?,
      json['background_image'] as String?,
      json['metacritic'] as int?,
      (json['platforms'] as List<dynamic>?)
          ?.map((e) => PlatformItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'released': instance.released,
      'background_image': instance.backgroundImage,
      'metacritic': instance.metacritic,
      'platforms': instance.platforms,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      json['id'] as int?,
      json['name'] as String?,
      json['released'] as String?,
      json['background_image'] as String?,
      json['metacritic'] as int?,
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'released': instance.released,
      'background_image': instance.backgroundImage,
      'metacritic': instance.metacritic,
    };

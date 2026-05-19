// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameDetailModel _$GameDetailModelFromJson(Map<String, dynamic> json) =>
    _GameDetailModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      summary: json['summary'] as String?,
      cover: json['cover'] == null
          ? null
          : GameCover.fromJson(json['cover'] as Map<String, dynamic>),
      gameModes: (json['game_modes'] as List<dynamic>?)
          ?.map((e) => GameMode.fromJson(e as Map<String, dynamic>))
          .toList(),
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => GameKeyword.fromJson(e as Map<String, dynamic>))
          .toList(),
      platforms: (json['platforms'] as List<dynamic>?)
          ?.map((e) => Platform.fromJson(e as Map<String, dynamic>))
          .toList(),
      releaseDates: (json['release_dates'] as List<dynamic>?)
          ?.map((e) => ReleaseDate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameDetailModelToJson(_GameDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'summary': instance.summary,
      'cover': instance.cover,
      'game_modes': instance.gameModes,
      'keywords': instance.keywords,
      'platforms': instance.platforms,
      'release_dates': instance.releaseDates,
    };

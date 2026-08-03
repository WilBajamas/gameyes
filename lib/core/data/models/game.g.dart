// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Game _$GameFromJson(Map<String, dynamic> json) => _Game(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
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
  criticScore: (json['total_rating'] as num?)?.toDouble(),
  hypes: (json['hypes'] as num?)?.toInt(),
  genres: (json['genres'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$GameToJson(_Game instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'cover': instance.cover,
  'game_modes': instance.gameModes,
  'keywords': instance.keywords,
  'platforms': instance.platforms,
  'release_dates': instance.releaseDates,
  'total_rating': instance.criticScore,
  'hypes': instance.hypes,
  'genres': instance.genres,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryEntryModel _$LibraryEntryModelFromJson(Map<String, dynamic> json) =>
    _LibraryEntryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      igdbId: (json['igdb_id'] as num).toInt(),
      title: json['title'] as String,
      coverUrl: json['cover_url'] as String?,
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      platform: json['platform'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      playtimeHours: (json['playtime_hours'] as num?)?.toDouble(),
      progressPercent: (json['progress_percent'] as num?)?.toDouble(),
      genre: json['genre'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$LibraryEntryModelToJson(_LibraryEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'igdb_id': instance.igdbId,
      'title': instance.title,
      'cover_url': instance.coverUrl,
      'release_date': instance.releaseDate?.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'platform': instance.platform,
      'rating': instance.rating,
      'playtime_hours': instance.playtimeHours,
      'progress_percent': instance.progressPercent,
      'genre': instance.genre,
      'updated_at': instance.updatedAt.toIso8601String(),
    };

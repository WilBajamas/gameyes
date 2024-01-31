// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformItem _$PlatformItemFromJson(Map<String, dynamic> json) => PlatformItem(
      json['platform'] == null
          ? null
          : Platform.fromJson(json['platform'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformItemToJson(PlatformItem instance) =>
    <String, dynamic>{
      'platform': instance.platform,
    };

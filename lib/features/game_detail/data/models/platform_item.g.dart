// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlatformItem _$PlatformItemFromJson(Map<String, dynamic> json) =>
    _PlatformItem(
      platform: json['platform'] == null
          ? null
          : Platform.fromJson(json['platform'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformItemToJson(_PlatformItem instance) =>
    <String, dynamic>{'platform': instance.platform};

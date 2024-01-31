import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform.dart';
import 'package:json_annotation/json_annotation.dart';

part 'platform_item.g.dart';

@JsonSerializable()
final class PlatformItem extends Equatable {
  final Platform? platform;

  factory PlatformItem.fromJson(Map<String, dynamic> json) =>
      _$PlatformItemFromJson(json);

  const PlatformItem(this.platform);

  Map<String, dynamic> toJson() => _$PlatformItemToJson(this);

  @override
  List<Object?> get props => [platform];
}

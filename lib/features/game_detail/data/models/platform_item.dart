import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform.dart';

part 'platform_item.freezed.dart';
part 'platform_item.g.dart';

@freezed
sealed class PlatformItem with _$PlatformItem {
  const factory PlatformItem({Platform? platform}) = _PlatformItem;

  factory PlatformItem.fromJson(Map<String, dynamic> json) =>
      _$PlatformItemFromJson(json);
}

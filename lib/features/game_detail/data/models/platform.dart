import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:json_annotation/json_annotation.dart';

part 'platform.g.dart';

@JsonSerializable()
final class Platform extends Equatable {
  final int? id;

  final String? name;

  const Platform(this.id, this.name);

  GamePlatfom? get value {
    final platformsContainsId =
        GamePlatfom.values.where((p) => p.ids.contains(id)).toList();

    if (platformsContainsId.isNotEmpty) {
      return platformsContainsId.firstWhere((_) => true);
    }

    return null;
  }

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformToJson(this);

  @override
  List<Object?> get props => [];
}

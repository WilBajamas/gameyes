import 'package:equatable/equatable.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
final class Game extends Equatable {
  final int? id;
  final String? slug;

  final String? name;

  final String? released;

  @JsonKey(name: 'background_image')
  final String? backgroundImage;

  final int? metacritic;

  final List<PlatformItem>? platforms;

  List<GamePlatfom>? get platformValues {
    if (platforms case final platforms?) {
      final List<GamePlatfom> values = [];

      for (var p in platforms) {
        if (p.platform?.value case final value?) values.add(value);
      }

      if (values.isEmpty) return null;

      return values.toSet().toList();
    }

    return null;
  }

  const Game(
    this.id,
    this.slug,
    this.name,
    this.released,
    this.backgroundImage,
    this.metacritic,
    this.platforms,
  );

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);

  @override
  List<Object?> get props => [id, name, released, backgroundImage, metacritic];
}

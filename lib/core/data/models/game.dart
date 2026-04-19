import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/platform_item.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
sealed class Game with _$Game {
  const Game._();

  const factory Game({
    int? id,
    String? slug,
    String? name,
    String? released,
    @JsonKey(name: 'background_image') String? backgroundImage,
    int? metacritic,
    List<PlatformItem>? platforms,
  }) = _Game;

  List<GamePlatform>? get platformValues {
    if (platforms case final platforms?) {
      final List<GamePlatform> values = [];

      for (var p in platforms) {
        if (p.platform?.value case final value?) values.add(value);
      }

      if (values.isEmpty) return null;

      return values.toSet().toList();
    }

    return null;
  }

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

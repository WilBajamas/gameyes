import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
final class Game extends Equatable {
  final String? name;

  final String? released;

  @JsonKey(name: 'background_image')
  final String? backgroundImage;

  final int? metacritic;

  const Game(
    this.name,
    this.released,
    this.backgroundImage,
    this.metacritic,
  );

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);

  @override
  List<Object?> get props => [name, released, backgroundImage, metacritic];
}

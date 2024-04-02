import 'package:isar/isar.dart';

part 'saved_game.g.dart';

@collection
class SavedGame {
  Id id = Isar.autoIncrement;

  String? name;

  String? imageUrl;

  int? gameId;

  String? gameSlug;
}

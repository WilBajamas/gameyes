import 'package:isar_community/isar.dart';

part 'play_session_log.g.dart';

@collection
class PlaySessionLog {
  Id id = Isar.autoIncrement;

  @Index()
  int? gameId;

  double? hoursPlayed;

  @Index()
  DateTime? timestamp;

  PlaySessionLog({
    this.gameId,
    this.hoursPlayed,
    this.timestamp,
  });
}

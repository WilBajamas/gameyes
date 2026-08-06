import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/release_date.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:injectable/injectable.dart';

// the "games" feature api service
@injectable
class GamesApiService {
  const GamesApiService(this._client);

  final SupabaseIgdbClient _client;

  Future<List<Game>> fetchGames(String query) => _decodeList(
    endpoint: SupabaseIgdbProxyConstants.gamesEndpoint,
    query: query,
    fromJson: Game.fromJson,
  );

  Future<List<ReleaseDate>> fetchReleaseDates(String query) => _decodeList(
    endpoint: SupabaseIgdbProxyConstants.releaseDatesEndpoint,
    query: query,
    fromJson: ReleaseDate.fromJson,
  );

  // reusable function - both functions above share the same shape
  Future<List<T>> _decodeList<T>({
    required String endpoint,
    required String query,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final body = await _client.invoke(endpoint: endpoint, query: query);

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }
}

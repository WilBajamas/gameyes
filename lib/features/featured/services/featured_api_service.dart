import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:injectable/injectable.dart';

// Featured borrowed games' service before this run. It owns one now, so the
// two features can diverge without either one growing the other's endpoints.
@injectable
class FeaturedApiService {
  const FeaturedApiService(this._client);

  final SupabaseIgdbClient _client;

  Future<List<Game>> fetchGames(String query) async {
    final body = await _client.invoke(
      endpoint: IgdbProxyConstants.gamesEndpoint,
      query: query,
    );

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

import 'package:gaming_library_assessment_flutter/core/data/models/game.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:injectable/injectable.dart';

// the "featured" feature api service
@injectable
class FeaturedApiService {
  const FeaturedApiService(this._proxy);

  final SupabaseIgdbProxyService _proxy;

  Future<List<Game>> fetchGames(String query) async {
    final body = await _proxy.invoke({
      'endpoint': SupabaseIgdbProxyConstants.gamesEndpoint,
      'query': query,
    });

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_client.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/data/models/game_detail_model.dart';
import 'package:injectable/injectable.dart';

// the "game detail" feature api service
@injectable
class GameDetailApiService {
  const GameDetailApiService(this._client);

  final SupabaseIgdbClient _client;

  Future<List<GameDetailModel>> fetchGameDetail(String query) async {
    final body = await _client.invoke(
      endpoint: IgdbProxyConstants.gamesEndpoint,
      query: query,
    );

    if (body is! List) {
      throw const FormatException('igdb-proxy did not return a list');
    }

    return body
        .map((item) => GameDetailModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

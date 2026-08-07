import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_call_log.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// the client we use to communicate with supabase
// querying and retrieving data from it
@injectable
class SupabaseIgdbClient {
  const SupabaseIgdbClient(this._client);

  final SupabaseClient _client;

  Future<Object?> invoke({
    required String endpoint,
    required String query,
  }) async {
    IgdbCallLog.request(endpoint: endpoint, query: query);
    try {
      final response = await _client.functions
          .invoke(
            SupabaseIgdbProxyConstants.functionName,
            body: {'endpoint': endpoint, 'query': query},
          )
          .timeout(SupabaseIgdbProxyConstants.requestTimeout);

      IgdbCallLog.response(response.data);
      return response.data;
    } catch (error, stackTrace) {
      IgdbCallLog.failure(error, stackTrace);
      rethrow;
    }
  }
}

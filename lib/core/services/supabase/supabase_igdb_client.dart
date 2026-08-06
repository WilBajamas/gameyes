import 'package:gaming_library_assessment_flutter/core/res/const.dart';
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
    final response = await _client.functions
        .invoke(
          SupabaseIgdbProxyConstants.functionName,
          body: {'endpoint': endpoint, 'query': query},
        )
        .timeout(SupabaseIgdbProxyConstants.requestTimeout);

    return response.data;
  }
}

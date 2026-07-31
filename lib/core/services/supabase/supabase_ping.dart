import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Sends one small request to Supabase just to see if it answers. Doesn't
// matter if the answer is "yes" or "that doesn't exist" - either way means
// Supabase is there and listening. Only a problem if there's no answer at all.
@injectable
class SupabasePing {
  const SupabasePing(this._client);

  final SupabaseClient _client;

  Future<void> ping() async {
    try {
      await _client.from(SupabaseConstants.connectionPath).select().limit(1);
    } on PostgrestException {
      return;
    }
  }
}

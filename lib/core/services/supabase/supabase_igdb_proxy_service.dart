import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:retrofit/retrofit.dart';

part 'supabase_igdb_proxy_service.g.dart';

// No base url here on purpose - the host is the flavour's own Supabase
// project, so it can only be known once the app is running.
@RestApi()
abstract class SupabaseIgdbProxyService {
  factory SupabaseIgdbProxyService(Dio dio) = _SupabaseIgdbProxyService;

  @POST(SupabaseIgdbProxyConstants.functionPath)
  Future<Object?> invoke(@Body() Map<String, String> body);
}

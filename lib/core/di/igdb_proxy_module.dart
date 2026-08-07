import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_proxy_auth_interceptor.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/supabase_igdb_proxy_service.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Headers;
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

@module
abstract class IgdbProxyModule {
  // Built at startup, so a build with no flavour set up fails here rather
  // than the first time somebody opens a game list.
  @singleton
  SupabaseIgdbProxyService supabaseIgdbProxyService(SupabaseClient supabase) {
    final config = FlavorConfig.instance;
    final baseUrl =
        '${config.supabaseUrl}${SupabaseIgdbProxyConstants.functionsBasePath}';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ConfigConstants.connectTimeout,
        receiveTimeout: ConfigConstants.receiveTimeout,
        sendTimeout: ConfigConstants.sendTimeout,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(
      IgdbProxyAuthInterceptor(
        auth: supabase.auth,
        anonKey: config.supabaseAnonKey,
        dio: dio,
      ),
    );

    // Added only for a developer running the dev build, so nothing is ever
    // printed in release or on prod. Defaults are left alone - they keep
    // request headers, and so the sign-in token, out of the console.
    // History is off because nothing in the app can show it.
    if (kDebugMode && config.flavor == Flavor.dev) {
      dio.interceptors.add(
        TalkerDioLogger(
          talker: Talker(settings: TalkerSettings(useHistory: false)),
        ),
      );
    }

    return SupabaseIgdbProxyService(dio);
  }
}

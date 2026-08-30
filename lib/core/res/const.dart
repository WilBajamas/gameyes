class ConfigConstants {
  static const igdbBaseUrl = 'https://api.igdb.com/v4/';
  static const apiKey = 'API_KEY';
  static const heroTag = 'hero_tag';
  static const enviedFilePath = '../gameyes/secret.env';
  static const enviedDevFilePath = '../gameyes/dev.env';
  static const enviedProdFilePath = '../gameyes/prod.env';
  static const supabaseUrl = 'SUPABASE_URL';
  static const supabaseAnonKey = 'SUPABASE_ANON_KEY';
  static const sentryDsn = 'SENTRY_DSN';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 5);
}

class PathConstants {
  static const imagePath = 'assets/images/';
}

/// Asset filenames used across the whole app - not for specific feature
class AssetConstants {
  static const error404 = 'error_404.png';
}

class StorageConstants {
  static const firstUseKey = 'first_use';
  static const trackerSortTagKey = 'tracker_sort_tag';
  static const libraryViewModeKey = 'library_view_mode';
  static const librarySortKey = 'library_sort';
}

class SupabaseConstants {
  // A made-up name we ask Supabase about, just to see if it replies.
  // Not a real table.
  static const connectionPath = 'connectionPath';

  static const Duration connectionTimeout = Duration(seconds: 10);

  // Where the sign-in page sends the person back to once they logged in
  // accounts for flavours
  static const devAuthRedirectUrl = 'com.questloggd.app.dev://login-callback';
  static const prodAuthRedirectUrl = 'com.questloggd.app://login-callback';
}

class SentryConstants {
  // What a checkout with no secret.env resolves to. Seeing this means crash
  // reporting stays off.
  static const placeholderDsn = 'PLACEHOLDER_SENTRY_DSN';

  static const flavorTag = 'flavor';
  static const appVersionTag = 'app_version';
}

class StringConstants {
  static const emptyStringPlaceholder = '-';
  static const na = 'NA';
  static const connectionTimeout = 'Connection timeout';
}

class RouteConstants {
  static const featured = '/featured';
  static const games = '/games';
  static const tracker = '/tracker';
  static const onboarding = '/onboarding';

  static const auth = '/auth';
  static const legal = '/legal';

  /// The only paths reachable without signing in.
  static const openPaths = {onboarding, auth, legal};
}

class IGDBConfig {
  static const standardGameFields = [
    'name',
    'cover.url',
    'game_modes.name',
    'keywords.name',
    'platforms.name',
    'platforms.abbreviation',
    'platforms.platform_logo.url',
    'release_dates.date',
    'release_dates.human',
  ];
}

class SupabaseIgdbProxyConstants {
  static const functionsBasePath = '/functions/v1';
  static const functionPath = '/igdb-proxy';
  static const gamesEndpoint = 'games';
  static const releaseDatesEndpoint = 'release_dates';
}

class GamesGridConstants {
  static const double gutter = 8;
  static const int columnCount = 2;

  static double columnWidth(double crossAxisExtent) =>
      (crossAxisExtent - gutter * (columnCount + 1)) / columnCount;
}

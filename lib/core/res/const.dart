class ConfigConstants {
  static const baseUrl = 'https://api.rawg.io/api/';
  static const igdbBaseUrl = 'https://api.igdb.com/v4/';
  static const gamesEndpoint = 'games';
  static const screenshotsEndpoint = 'screenshots';
  static const apiKey = 'API_KEY';
  static const twitchClientId = 'TWITCH_CLIENT_ID';
  static const twitchClientSecret = 'TWITCH_CLIENT_SECRET';
  static const heroTag = 'hero_tag';
  static const enviedFilePath = '../gameyes/secret.env';
  static const enviedDevFilePath = '../gameyes/dev.env';
  static const enviedProdFilePath = '../gameyes/prod.env';
  static const supabaseUrl = 'SUPABASE_URL';
  static const supabaseAnonKey = 'SUPABASE_ANON_KEY';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 5);
}

class PathConstants {
  static const lottieAnimationAssetPath = 'assets/animations/';
  static const imagePath = 'assets/images/';
}

/// Asset filenames used across the whole app - not for specific feature
class AssetConstants {
  static const error404 = 'error_404.png';
}

class StorageConstants {
  static const firstUseKey = 'first_use';
  static const trackerSortTagKey = 'tracker_sort_tag';
}

class SupabaseConstants {
  // A made-up name we ask Supabase about, just to see if it replies.
  // Not a real table.
  static const connectionPath = 'connectionPath';

  static const Duration connectionTimeout = Duration(seconds: 10);

  // Where the sign-in page sends the person back to once they approve.
  // Each build has its own address so both can be installed side by side.
  static const devAuthRedirectUrl = 'com.questloggd.app.dev://login-callback';
  static const prodAuthRedirectUrl = 'com.questloggd.app://login-callback';
}

class StringConstants {
  static const emptyStringPlaceholder = '-';
  static const na = 'NA';
  static const connectionTimeout = 'Connection timeout';
  static const sharedPrefTypeError = 'Unsupported type for shared preferences';
}

class RouteConstants {
  static const root = '/';
  static const home = '/home';
  static const featured = '/featured';
  static const games = '/games';
  static const tracker = '/tracker';
  static const trackerDetail = '/tracker_detail';
  static const taskDetail = '/task_detail';
  static const imagePageView = 'image_page_view';
  static const onboarding = '/onboarding';
  static const gameDetail = '/game_detail';
  static const browse = '/browse';
  static const news = '/news';
  static const settings = '/settings';

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

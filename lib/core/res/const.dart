enum TextInputValidatorType {
  nonEmpty,
  email,
  lessCharacters,
}

enum GameOrdering {
  name,
  released,
  added,
  created,
  updated,
  rating,
  metacritic,
}

class ConfigConstants {
  static const baseUrl = 'https://api.rawg.io/api/';
  static const gamesEndpoint = 'games';
  static const screenshotsEndpoint = 'screenshots';
  static const apiKey = 'API_KEY';
  static const heroTag = 'hero_tag';
  static const enviedFilePath =
      '../gaming_library_assessment_flutter/secret.env';
  
}

class PathConstants {
  static const lottieAnimationAssetPath = 'assets/animations/';
  static const imagePath = 'assets/images/';
}

class AssetConstants {
  static const onboardingAnimation1 = 'onboarding_anim_1.json';
  static const onboardingAnimation2 = 'onboarding_anim_2.json';
  static const onboardingAnimation3 = 'onboarding_anim_3.json';
}

class StorageConstants {
  static const firstUseKey = 'first_use';
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
  static const onboarding = '/onboarding';
  static const gameDetail = '/game_detail';
}

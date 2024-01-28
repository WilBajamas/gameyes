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
}

class PathConstants {
  static const lottieAnimationAssetPath = 'assets/animations/';
}

class AssetConstants {
  static const onboardingAnimation1 = 'onboarding_anim_1.json';
  static const onboardingAnimation2 = 'onboarding_anim_2.json';
  static const onboardingAnimation3 = 'onboarding_anim_3.json';
}

class StringConstants {
  static const onboardingDescriptionOne =
      'Stay informed of new game releases and news.';
  static const onboardingDescriptionTwo =
      'Find more information about your favourite games.';
  static const onboardingDescriptionThree =
      'Make a savelist of anticipated upcoming games.';
  static const emptyStringPlaceholder = '-';
  static const na = 'NA';
  static const next = 'Next';
  static const skip = 'Skip';
  static const featured = 'Featured';
  static const games = 'Games';
  static const settings = 'Settings';
  static const mostAnticipated = 'Most Anticipated';
  static const bestMetacritic = 'Best Metacritic';
  static const latestReleases = 'Latest Releases';
  static const connectionTimeout = 'Connection timeout';
  static const noResultsFound = 'No results found';
  static const errorResults = 'Error retrieving results';
  static const retry = 'Retry';
  static const featuredScreenTitle =
      // ignore: lines_longer_than_80_chars
      'Check out our featured lists of games, from most anticipated to the latest releases.';
}

class RouteConstants {
  static const root = '/';
  static const home = '/home';
}

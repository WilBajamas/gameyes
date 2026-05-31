import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Gaming Library Assessment'**
  String get app_title;

  /// No description provided for @onboarding_description_one.
  ///
  /// In en, this message translates to:
  /// **'Stay informed of new game releases and news.'**
  String get onboarding_description_one;

  /// No description provided for @onboarding_description_two.
  ///
  /// In en, this message translates to:
  /// **'Find more information about your favourite games.'**
  String get onboarding_description_two;

  /// No description provided for @onboarding_description_three.
  ///
  /// In en, this message translates to:
  /// **'Make a savelist of anticipated upcoming games.'**
  String get onboarding_description_three;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @most_anticipated.
  ///
  /// In en, this message translates to:
  /// **'Most Anticipated'**
  String get most_anticipated;

  /// No description provided for @best_metacritic.
  ///
  /// In en, this message translates to:
  /// **'Best Metacritic'**
  String get best_metacritic;

  /// No description provided for @latest_releases.
  ///
  /// In en, this message translates to:
  /// **'Latest Releases'**
  String get latest_releases;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// No description provided for @error_results.
  ///
  /// In en, this message translates to:
  /// **'Error retrieving results'**
  String get error_results;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @search_games.
  ///
  /// In en, this message translates to:
  /// **'Search games'**
  String get search_games;

  /// No description provided for @date_range.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get date_range;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @platforms.
  ///
  /// In en, this message translates to:
  /// **'Platforms'**
  String get platforms;

  /// No description provided for @ordering.
  ///
  /// In en, this message translates to:
  /// **'Ordering'**
  String get ordering;

  /// No description provided for @featured_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Check out our featured lists of games, from most anticipated to the latest releases.'**
  String get featured_screen_title;

  /// No description provided for @screenshots.
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get screenshots;

  /// No description provided for @metacritic_score.
  ///
  /// In en, this message translates to:
  /// **'Metacritic score'**
  String get metacritic_score;

  /// No description provided for @release_date.
  ///
  /// In en, this message translates to:
  /// **'Release date'**
  String get release_date;

  /// No description provided for @publishers.
  ///
  /// In en, this message translates to:
  /// **'Publishers'**
  String get publishers;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @developers.
  ///
  /// In en, this message translates to:
  /// **'Developers'**
  String get developers;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get read_more;

  /// No description provided for @read_less.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get read_less;

  /// No description provided for @featured_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything in one glance'**
  String get featured_subtitle;

  /// No description provided for @new_and_trending.
  ///
  /// In en, this message translates to:
  /// **'New & Trending'**
  String get new_and_trending;

  /// No description provided for @best_of_the_year.
  ///
  /// In en, this message translates to:
  /// **'Best of the year'**
  String get best_of_the_year;

  /// No description provided for @new_releases_30_days.
  ///
  /// In en, this message translates to:
  /// **'New releases last 30 days'**
  String get new_releases_30_days;

  /// No description provided for @popular_last_year.
  ///
  /// In en, this message translates to:
  /// **'Popular last year'**
  String get popular_last_year;

  /// No description provided for @top_rated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get top_rated;

  /// No description provided for @all_time_top_100.
  ///
  /// In en, this message translates to:
  /// **'All time top 100'**
  String get all_time_top_100;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @games_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for your favourite games here'**
  String get games_screen_subtitle;

  /// No description provided for @search_saved_games.
  ///
  /// In en, this message translates to:
  /// **'Search saved games'**
  String get search_saved_games;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @tasks_completed.
  ///
  /// In en, this message translates to:
  /// **'Tasks Completed'**
  String get tasks_completed;

  /// No description provided for @tracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tracker;

  /// No description provided for @recently_changed.
  ///
  /// In en, this message translates to:
  /// **'Recently changed'**
  String get recently_changed;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @playtime.
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get playtime;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @date_added.
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get date_added;

  /// No description provided for @no_games_saved.
  ///
  /// In en, this message translates to:
  /// **'No games saved'**
  String get no_games_saved;

  /// No description provided for @no_games_saved_description.
  ///
  /// In en, this message translates to:
  /// **'Bookmark some games from the games or featured sections.'**
  String get no_games_saved_description;

  /// No description provided for @delete_saved_game.
  ///
  /// In en, this message translates to:
  /// **'Delete saved game'**
  String get delete_saved_game;

  /// No description provided for @delete_saved_game_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove your saved game? All your notes and progress will be lost.'**
  String get delete_saved_game_description;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @onHold.
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get onHold;

  /// No description provided for @rageQuit.
  ///
  /// In en, this message translates to:
  /// **'Rage Quit'**
  String get rageQuit;

  /// No description provided for @toBuy.
  ///
  /// In en, this message translates to:
  /// **'To Buy'**
  String get toBuy;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get last_updated;

  /// No description provided for @select_platforms.
  ///
  /// In en, this message translates to:
  /// **'Select Platforms'**
  String get select_platforms;

  /// No description provided for @tasks_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Tasks in progress'**
  String get tasks_in_progress;

  /// No description provided for @task_screenshots.
  ///
  /// In en, this message translates to:
  /// **'Task screenshots'**
  String get task_screenshots;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @improve.
  ///
  /// In en, this message translates to:
  /// **'Improve'**
  String get improve;

  /// No description provided for @task_statuses.
  ///
  /// In en, this message translates to:
  /// **'Task Statuses'**
  String get task_statuses;

  /// No description provided for @date_started.
  ///
  /// In en, this message translates to:
  /// **'Date started'**
  String get date_started;

  /// No description provided for @not_started.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get not_started;

  /// No description provided for @add_group_task.
  ///
  /// In en, this message translates to:
  /// **'Add Group Task'**
  String get add_group_task;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @keep_it_short.
  ///
  /// In en, this message translates to:
  /// **'Keep it short'**
  String get keep_it_short;

  /// No description provided for @a_brief_description.
  ///
  /// In en, this message translates to:
  /// **'A breif description'**
  String get a_brief_description;

  /// No description provided for @add_task.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get add_task;

  /// No description provided for @tasks_pinned.
  ///
  /// In en, this message translates to:
  /// **'Tasks pinned'**
  String get tasks_pinned;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @no_pinned_tasks_desc.
  ///
  /// In en, this message translates to:
  /// **'There are no pinned tasks'**
  String get no_pinned_tasks_desc;

  /// No description provided for @no_group_task_created.
  ///
  /// In en, this message translates to:
  /// **'No group task created'**
  String get no_group_task_created;

  /// No description provided for @please_enter_value.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get please_enter_value;

  /// No description provided for @group_task_created.
  ///
  /// In en, this message translates to:
  /// **'Group task created'**
  String get group_task_created;

  /// No description provided for @only_10_group_tasks_allowed.
  ///
  /// In en, this message translates to:
  /// **'Only a maximum of 10 group tasks are allowed.'**
  String get only_10_group_tasks_allowed;

  /// No description provided for @set_title_here.
  ///
  /// In en, this message translates to:
  /// **'Set title here'**
  String get set_title_here;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @add_step.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get add_step;

  /// No description provided for @step_added.
  ///
  /// In en, this message translates to:
  /// **'Step has been added'**
  String get step_added;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @remove_step.
  ///
  /// In en, this message translates to:
  /// **'Remove step'**
  String get remove_step;

  /// No description provided for @remove_step_desc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove step {stepName}? This action cannot be undone'**
  String remove_step_desc(String stepName);

  /// No description provided for @remove_step_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed removing step'**
  String get remove_step_failed;

  /// No description provided for @removed_step.
  ///
  /// In en, this message translates to:
  /// **'Step removed'**
  String get removed_step;

  /// No description provided for @failed_to_load_weekly_releases.
  ///
  /// In en, this message translates to:
  /// **'Failed to load weekly releases'**
  String get failed_to_load_weekly_releases;

  /// No description provided for @failed_to_load_countdown_game.
  ///
  /// In en, this message translates to:
  /// **'Failed to load countdown game'**
  String get failed_to_load_countdown_game;

  /// No description provided for @failed_to_load_critics_choice_reviews.
  ///
  /// In en, this message translates to:
  /// **'Failed to load critics choice reviews'**
  String get failed_to_load_critics_choice_reviews;

  /// No description provided for @failed_to_load_genre_preferences.
  ///
  /// In en, this message translates to:
  /// **'Failed to load genre preferences'**
  String get failed_to_load_genre_preferences;

  /// No description provided for @failed_to_save_genre_preference.
  ///
  /// In en, this message translates to:
  /// **'Failed to save genre preference'**
  String get failed_to_save_genre_preference;

  /// No description provided for @failed_to_skip_genre_preferences.
  ///
  /// In en, this message translates to:
  /// **'Failed to skip genre preferences'**
  String get failed_to_skip_genre_preferences;

  /// No description provided for @failed_to_load_library_stats.
  ///
  /// In en, this message translates to:
  /// **'Failed to load library stats'**
  String get failed_to_load_library_stats;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

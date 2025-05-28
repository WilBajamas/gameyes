// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Gaming Library Assessment`
  String get app_title {
    return Intl.message(
      'Gaming Library Assessment',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `Stay informed of new game releases and news.`
  String get onboarding_description_one {
    return Intl.message(
      'Stay informed of new game releases and news.',
      name: 'onboarding_description_one',
      desc: '',
      args: [],
    );
  }

  /// `Find more information about your favourite games.`
  String get onboarding_description_two {
    return Intl.message(
      'Find more information about your favourite games.',
      name: 'onboarding_description_two',
      desc: '',
      args: [],
    );
  }

  /// `Make a savelist of anticipated upcoming games.`
  String get onboarding_description_three {
    return Intl.message(
      'Make a savelist of anticipated upcoming games.',
      name: 'onboarding_description_three',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Featured`
  String get featured {
    return Intl.message('Featured', name: 'featured', desc: '', args: []);
  }

  /// `Games`
  String get games {
    return Intl.message('Games', name: 'games', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Most Anticipated`
  String get most_anticipated {
    return Intl.message(
      'Most Anticipated',
      name: 'most_anticipated',
      desc: '',
      args: [],
    );
  }

  /// `Best Metacritic`
  String get best_metacritic {
    return Intl.message(
      'Best Metacritic',
      name: 'best_metacritic',
      desc: '',
      args: [],
    );
  }

  /// `Latest Releases`
  String get latest_releases {
    return Intl.message(
      'Latest Releases',
      name: 'latest_releases',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get no_results_found {
    return Intl.message(
      'No results found',
      name: 'no_results_found',
      desc: '',
      args: [],
    );
  }

  /// `Error retrieving results`
  String get error_results {
    return Intl.message(
      'Error retrieving results',
      name: 'error_results',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Search games`
  String get search_games {
    return Intl.message(
      'Search games',
      name: 'search_games',
      desc: '',
      args: [],
    );
  }

  /// `Date range`
  String get date_range {
    return Intl.message('Date range', name: 'date_range', desc: '', args: []);
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Platforms`
  String get platforms {
    return Intl.message('Platforms', name: 'platforms', desc: '', args: []);
  }

  /// `Ordering`
  String get ordering {
    return Intl.message('Ordering', name: 'ordering', desc: '', args: []);
  }

  /// `Check out our featured lists of games, from most anticipated to the latest releases.`
  String get featured_screen_title {
    return Intl.message(
      'Check out our featured lists of games, from most anticipated to the latest releases.',
      name: 'featured_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Screenshots`
  String get screenshots {
    return Intl.message('Screenshots', name: 'screenshots', desc: '', args: []);
  }

  /// `Metacritic score`
  String get metacritic_score {
    return Intl.message(
      'Metacritic score',
      name: 'metacritic_score',
      desc: '',
      args: [],
    );
  }

  /// `Release date`
  String get release_date {
    return Intl.message(
      'Release date',
      name: 'release_date',
      desc: '',
      args: [],
    );
  }

  /// `Publishers`
  String get publishers {
    return Intl.message('Publishers', name: 'publishers', desc: '', args: []);
  }

  /// `Genre`
  String get genre {
    return Intl.message('Genre', name: 'genre', desc: '', args: []);
  }

  /// `Developers`
  String get developers {
    return Intl.message('Developers', name: 'developers', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Read more`
  String get read_more {
    return Intl.message('Read more', name: 'read_more', desc: '', args: []);
  }

  /// `Read less`
  String get read_less {
    return Intl.message('Read less', name: 'read_less', desc: '', args: []);
  }

  /// `Everything in one glance`
  String get featured_subtitle {
    return Intl.message(
      'Everything in one glance',
      name: 'featured_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `New & Trending`
  String get new_and_trending {
    return Intl.message(
      'New & Trending',
      name: 'new_and_trending',
      desc: '',
      args: [],
    );
  }

  /// `Best of the year`
  String get best_of_the_year {
    return Intl.message(
      'Best of the year',
      name: 'best_of_the_year',
      desc: '',
      args: [],
    );
  }

  /// `New releases last 30 days`
  String get new_releases_30_days {
    return Intl.message(
      'New releases last 30 days',
      name: 'new_releases_30_days',
      desc: '',
      args: [],
    );
  }

  /// `Popular last year`
  String get popular_last_year {
    return Intl.message(
      'Popular last year',
      name: 'popular_last_year',
      desc: '',
      args: [],
    );
  }

  /// `Top rated`
  String get top_rated {
    return Intl.message('Top rated', name: 'top_rated', desc: '', args: []);
  }

  /// `All time top 100`
  String get all_time_top_100 {
    return Intl.message(
      'All time top 100',
      name: 'all_time_top_100',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get browse {
    return Intl.message('Browse', name: 'browse', desc: '', args: []);
  }

  /// `News`
  String get news {
    return Intl.message('News', name: 'news', desc: '', args: []);
  }

  /// `Search for your favourite games here`
  String get games_screen_subtitle {
    return Intl.message(
      'Search for your favourite games here',
      name: 'games_screen_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Search saved games`
  String get search_saved_games {
    return Intl.message(
      'Search saved games',
      name: 'search_saved_games',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Tasks Completed`
  String get tasks_completed {
    return Intl.message(
      'Tasks Completed',
      name: 'tasks_completed',
      desc: '',
      args: [],
    );
  }

  /// `Tracker`
  String get tracker {
    return Intl.message('Tracker', name: 'tracker', desc: '', args: []);
  }

  /// `Recently changed`
  String get recently_changed {
    return Intl.message(
      'Recently changed',
      name: 'recently_changed',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Playtime`
  String get playtime {
    return Intl.message('Playtime', name: 'playtime', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Date added`
  String get date_added {
    return Intl.message('Date added', name: 'date_added', desc: '', args: []);
  }

  /// `No games saved`
  String get no_games_saved {
    return Intl.message(
      'No games saved',
      name: 'no_games_saved',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark some games from the games or featured sections.`
  String get no_games_saved_description {
    return Intl.message(
      'Bookmark some games from the games or featured sections.',
      name: 'no_games_saved_description',
      desc: '',
      args: [],
    );
  }

  /// `Delete saved game`
  String get delete_saved_game {
    return Intl.message(
      'Delete saved game',
      name: 'delete_saved_game',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove your saved game? All your notes and progress will be lost.`
  String get delete_saved_game_description {
    return Intl.message(
      'Are you sure you want to remove your saved game? All your notes and progress will be lost.',
      name: 'delete_saved_game_description',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message('Ok', name: 'ok', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `On Hold`
  String get onHold {
    return Intl.message('On Hold', name: 'onHold', desc: '', args: []);
  }

  /// `Rage Quit`
  String get rageQuit {
    return Intl.message('Rage Quit', name: 'rageQuit', desc: '', args: []);
  }

  /// `To Buy`
  String get toBuy {
    return Intl.message('To Buy', name: 'toBuy', desc: '', args: []);
  }

  /// `In Progress`
  String get inProgress {
    return Intl.message('In Progress', name: 'inProgress', desc: '', args: []);
  }

  /// `Last Updated`
  String get last_updated {
    return Intl.message(
      'Last Updated',
      name: 'last_updated',
      desc: '',
      args: [],
    );
  }

  /// `Select Platforms`
  String get select_platforms {
    return Intl.message(
      'Select Platforms',
      name: 'select_platforms',
      desc: '',
      args: [],
    );
  }

  /// `Tasks in progress`
  String get tasks_in_progress {
    return Intl.message(
      'Tasks in progress',
      name: 'tasks_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Task screenshots`
  String get task_screenshots {
    return Intl.message(
      'Task screenshots',
      name: 'task_screenshots',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Missed`
  String get missed {
    return Intl.message('Missed', name: 'missed', desc: '', args: []);
  }

  /// `Improve`
  String get improve {
    return Intl.message('Improve', name: 'improve', desc: '', args: []);
  }

  /// `Task Statuses`
  String get task_statuses {
    return Intl.message(
      'Task Statuses',
      name: 'task_statuses',
      desc: '',
      args: [],
    );
  }

  /// `Date started`
  String get date_started {
    return Intl.message(
      'Date started',
      name: 'date_started',
      desc: '',
      args: [],
    );
  }

  /// `Not started`
  String get not_started {
    return Intl.message('Not started', name: 'not_started', desc: '', args: []);
  }

  /// `Add Group Task`
  String get add_group_task {
    return Intl.message(
      'Add Group Task',
      name: 'add_group_task',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Keep it short`
  String get keep_it_short {
    return Intl.message(
      'Keep it short',
      name: 'keep_it_short',
      desc: '',
      args: [],
    );
  }

  /// `A breif description`
  String get a_brief_description {
    return Intl.message(
      'A breif description',
      name: 'a_brief_description',
      desc: '',
      args: [],
    );
  }

  /// `Add task`
  String get add_task {
    return Intl.message('Add task', name: 'add_task', desc: '', args: []);
  }

  /// `Tasks pinned`
  String get tasks_pinned {
    return Intl.message(
      'Tasks pinned',
      name: 'tasks_pinned',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Tasks`
  String get tasks {
    return Intl.message('Tasks', name: 'tasks', desc: '', args: []);
  }

  /// `There are no pinned tasks`
  String get no_pinned_tasks_desc {
    return Intl.message(
      'There are no pinned tasks',
      name: 'no_pinned_tasks_desc',
      desc: '',
      args: [],
    );
  }

  /// `No group task created`
  String get no_group_task_created {
    return Intl.message(
      'No group task created',
      name: 'no_group_task_created',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a value`
  String get please_enter_value {
    return Intl.message(
      'Please enter a value',
      name: 'please_enter_value',
      desc: '',
      args: [],
    );
  }

  /// `Group task created`
  String get group_task_created {
    return Intl.message(
      'Group task created',
      name: 'group_task_created',
      desc: '',
      args: [],
    );
  }

  /// `Only a maximum of 10 group tasks are allowed.`
  String get only_10_group_tasks_allowed {
    return Intl.message(
      'Only a maximum of 10 group tasks are allowed.',
      name: 'only_10_group_tasks_allowed',
      desc: '',
      args: [],
    );
  }

  /// `Set title here`
  String get set_title_here {
    return Intl.message(
      'Set title here',
      name: 'set_title_here',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message('Reminder', name: 'reminder', desc: '', args: []);
  }

  /// `Add step`
  String get add_step {
    return Intl.message('Add step', name: 'add_step', desc: '', args: []);
  }

  /// `Step has been added`
  String get step_added {
    return Intl.message(
      'Step has been added',
      name: 'step_added',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Remove step`
  String get remove_step {
    return Intl.message('Remove step', name: 'remove_step', desc: '', args: []);
  }

  /// `Are you sure you want to remove step {stepName}? This action cannot be undone`
  String remove_step_desc(String stepName) {
    return Intl.message(
      'Are you sure you want to remove step $stepName? This action cannot be undone',
      name: 'remove_step_desc',
      desc: '',
      args: [stepName],
    );
  }

  /// `Failed removing step`
  String get remove_step_failed {
    return Intl.message(
      'Failed removing step',
      name: 'remove_step_failed',
      desc: '',
      args: [],
    );
  }

  /// `Step removed`
  String get removed_step {
    return Intl.message(
      'Step removed',
      name: 'removed_step',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

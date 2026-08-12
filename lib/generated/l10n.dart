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

  /// `QuestLoggd`
  String get app_title {
    return Intl.message('QuestLoggd', name: 'app_title', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `TRACK EVERY GAME YOU'VE EVER TOUCHED`
  String get welcome_headline_one {
    return Intl.message(
      'TRACK EVERY GAME YOU\'VE EVER TOUCHED',
      name: 'welcome_headline_one',
      desc: '',
      args: [],
    );
  }

  /// `Every game you have played, beaten, dropped or shelved, in one place — 312 or 3.`
  String get welcome_body_one {
    return Intl.message(
      'Every game you have played, beaten, dropped or shelved, in one place — 312 or 3.',
      name: 'welcome_body_one',
      desc: '',
      args: [],
    );
  }

  /// `AND KNOW WHAT DROPS NEXT`
  String get welcome_headline_two {
    return Intl.message(
      'AND KNOW WHAT DROPS NEXT',
      name: 'welcome_headline_two',
      desc: '',
      args: [],
    );
  }

  /// `Track what you are waiting on and see the countdown to every release you care about.`
  String get welcome_body_two {
    return Intl.message(
      'Track what you are waiting on and see the countdown to every release you care about.',
      name: 'welcome_body_two',
      desc: '',
      args: [],
    );
  }

  /// `Get started`
  String get get_started {
    return Intl.message('Get started', name: 'get_started', desc: '', args: []);
  }

  /// `Sign in`
  String get auth_title {
    return Intl.message('Sign in', name: 'auth_title', desc: '', args: []);
  }

  /// `Sign in to keep your library and release tracking in sync.`
  String get auth_lead {
    return Intl.message(
      'Sign in to keep your library and release tracking in sync.',
      name: 'auth_lead',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Discord`
  String get continue_with_discord {
    return Intl.message(
      'Continue with Discord',
      name: 'continue_with_discord',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continue_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Signing in with {provider}`
  String auth_signing_in(String provider) {
    return Intl.message(
      'Signing in with $provider',
      name: 'auth_signing_in',
      desc: '',
      args: [provider],
    );
  }

  /// `We couldn't sign you in. Please try again.`
  String get auth_sign_in_error {
    return Intl.message(
      'We couldn\'t sign you in. Please try again.',
      name: 'auth_sign_in_error',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get auth_sign_out {
    return Intl.message('Sign out', name: 'auth_sign_out', desc: '', args: []);
  }

  /// `We couldn't sign you out. Please try again.`
  String get auth_sign_out_error {
    return Intl.message(
      'We couldn\'t sign you out. Please try again.',
      name: 'auth_sign_out_error',
      desc: '',
      args: [],
    );
  }

  /// `Just sign in for now — we'll help you set things up next.`
  String get auth_scope_reassurance {
    return Intl.message(
      'Just sign in for now — we\'ll help you set things up next.',
      name: 'auth_scope_reassurance',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our `
  String get auth_legal_prefix {
    return Intl.message(
      'By continuing, you agree to our ',
      name: 'auth_legal_prefix',
      desc: '',
      args: [],
    );
  }

  /// `Terms`
  String get auth_terms {
    return Intl.message('Terms', name: 'auth_terms', desc: '', args: []);
  }

  /// ` and acknowledge our `
  String get auth_legal_middle {
    return Intl.message(
      ' and acknowledge our ',
      name: 'auth_legal_middle',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get auth_privacy {
    return Intl.message(
      'Privacy Policy',
      name: 'auth_privacy',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get auth_legal_suffix {
    return Intl.message('.', name: 'auth_legal_suffix', desc: '', args: []);
  }

  /// `Playing`
  String get playing {
    return Intl.message('Playing', name: 'playing', desc: '', args: []);
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

  /// `Backlog`
  String get backlog {
    return Intl.message('Backlog', name: 'backlog', desc: '', args: []);
  }

  /// `Dropped`
  String get dropped {
    return Intl.message('Dropped', name: 'dropped', desc: '', args: []);
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

  /// `Failed to load weekly releases`
  String get failed_to_load_weekly_releases {
    return Intl.message(
      'Failed to load weekly releases',
      name: 'failed_to_load_weekly_releases',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load countdown game`
  String get failed_to_load_countdown_game {
    return Intl.message(
      'Failed to load countdown game',
      name: 'failed_to_load_countdown_game',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load critics choice reviews`
  String get failed_to_load_critics_choice_reviews {
    return Intl.message(
      'Failed to load critics choice reviews',
      name: 'failed_to_load_critics_choice_reviews',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load genre preferences`
  String get failed_to_load_genre_preferences {
    return Intl.message(
      'Failed to load genre preferences',
      name: 'failed_to_load_genre_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save genre preference`
  String get failed_to_save_genre_preference {
    return Intl.message(
      'Failed to save genre preference',
      name: 'failed_to_save_genre_preference',
      desc: '',
      args: [],
    );
  }

  /// `Failed to skip genre preferences`
  String get failed_to_skip_genre_preferences {
    return Intl.message(
      'Failed to skip genre preferences',
      name: 'failed_to_skip_genre_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load library stats`
  String get failed_to_load_library_stats {
    return Intl.message(
      'Failed to load library stats',
      name: 'failed_to_load_library_stats',
      desc: '',
      args: [],
    );
  }

  /// `Loading Game Title`
  String get loading_game_title_placeholder {
    return Intl.message(
      'Loading Game Title',
      name: 'loading_game_title_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get coming_soon {
    return Intl.message('Coming Soon', name: 'coming_soon', desc: '', args: []);
  }

  /// `Loading Game Release Title`
  String get loading_game_release_title {
    return Intl.message(
      'Loading Game Release Title',
      name: 'loading_game_release_title',
      desc: '',
      args: [],
    );
  }

  /// `Critics Choice Title`
  String get critics_choice_title {
    return Intl.message(
      'Critics Choice Title',
      name: 'critics_choice_title',
      desc: '',
      args: [],
    );
  }

  /// `Released 2 days ago`
  String get released_2_days_ago {
    return Intl.message(
      'Released 2 days ago',
      name: 'released_2_days_ago',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to GameYes 🎮`
  String get welcome_to_gameyes {
    return Intl.message(
      'Welcome to GameYes 🎮',
      name: 'welcome_to_gameyes',
      desc: '',
      args: [],
    );
  }

  /// `Let's complete your quick onboarding steps.`
  String get complete_onboarding_steps {
    return Intl.message(
      'Let\'s complete your quick onboarding steps.',
      name: 'complete_onboarding_steps',
      desc: '',
      args: [],
    );
  }

  /// `Add a game you've played`
  String get add_game_played {
    return Intl.message(
      'Add a game you\'ve played',
      name: 'add_game_played',
      desc: '',
      args: [],
    );
  }

  /// `+ Add`
  String get add_button {
    return Intl.message('+ Add', name: 'add_button', desc: '', args: []);
  }

  /// `Mark what you're playing now`
  String get mark_playing_now {
    return Intl.message(
      'Mark what you\'re playing now',
      name: 'mark_playing_now',
      desc: '',
      args: [],
    );
  }

  /// `+ Mark`
  String get mark_button {
    return Intl.message('+ Mark', name: 'mark_button', desc: '', args: []);
  }

  /// `Wishlist an upcoming game`
  String get wishlist_upcoming_game {
    return Intl.message(
      'Wishlist an upcoming game',
      name: 'wishlist_upcoming_game',
      desc: '',
      args: [],
    );
  }

  /// `+ Wishlist`
  String get wishlist_button {
    return Intl.message(
      '+ Wishlist',
      name: 'wishlist_button',
      desc: '',
      args: [],
    );
  }

  /// `Total Games`
  String get total_games {
    return Intl.message('Total Games', name: 'total_games', desc: '', args: []);
  }

  /// `Wishlist`
  String get wishlist {
    return Intl.message('Wishlist', name: 'wishlist', desc: '', args: []);
  }

  /// `This Week`
  String get this_week {
    return Intl.message('This Week', name: 'this_week', desc: '', args: []);
  }

  /// `Now Playing`
  String get now_playing {
    return Intl.message('Now Playing', name: 'now_playing', desc: '', args: []);
  }

  /// `No game in progress`
  String get no_game_in_progress {
    return Intl.message(
      'No game in progress',
      name: 'no_game_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Mark something as playing →`
  String get mark_something_playing {
    return Intl.message(
      'Mark something as playing →',
      name: 'mark_something_playing',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `{percentage}% completed`
  String completed_percentage(String percentage) {
    return Intl.message(
      '$percentage% completed',
      name: 'completed_percentage',
      desc: '',
      args: [percentage],
    );
  }

  /// `{logged}h logged of {average}h`
  String logged_hours_of(String logged, String average) {
    return Intl.message(
      '${logged}h logged of ${average}h',
      name: 'logged_hours_of',
      desc: '',
      args: [logged, average],
    );
  }

  /// `{hours}h played`
  String played_hours(String hours) {
    return Intl.message(
      '${hours}h played',
      name: 'played_hours',
      desc: '',
      args: [hours],
    );
  }

  /// `+ {count} more playing`
  String more_playing(String count) {
    return Intl.message(
      '+ $count more playing',
      name: 'more_playing',
      desc: '',
      args: [count],
    );
  }

  /// `{hours}h`
  String hours_abbreviation(String hours) {
    return Intl.message(
      '${hours}h',
      name: 'hours_abbreviation',
      desc: '',
      args: [hours],
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

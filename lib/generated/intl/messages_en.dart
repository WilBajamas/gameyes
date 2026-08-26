// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(provider) => "Signing in with ${provider}";

  static String m1(percentage) => "${percentage}% completed";

  static String m2(days, hours, minutes) =>
      "${days} days, ${hours} hours, ${minutes} minutes until release";

  static String m3(hours) => "${hours}h";

  static String m4(logged, average) => "${logged}h logged of ${average}h";

  static String m5(count) => "+ ${count} more playing";

  static String m6(hours) => "${hours}h played";

  static String m7(stepName) =>
      "Are you sure you want to remove step ${stepName}? This action cannot be undone";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "a_brief_description": MessageLookupByLibrary.simpleMessage(
      "A breif description",
    ),
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "active": MessageLookupByLibrary.simpleMessage("Active"),
    "add_button": MessageLookupByLibrary.simpleMessage("+ Add"),
    "add_game_played": MessageLookupByLibrary.simpleMessage(
      "Add a game you\'ve played",
    ),
    "add_group_task": MessageLookupByLibrary.simpleMessage("Add Group Task"),
    "add_step": MessageLookupByLibrary.simpleMessage("Add step"),
    "add_task": MessageLookupByLibrary.simpleMessage("Add task"),
    "add_to_library": MessageLookupByLibrary.simpleMessage("Add to library"),
    "all_time_top_100": MessageLookupByLibrary.simpleMessage(
      "All time top 100",
    ),
    "app_title": MessageLookupByLibrary.simpleMessage("QuestLoggd"),
    "auth_lead": MessageLookupByLibrary.simpleMessage(
      "Sign in to keep your library and release tracking in sync.",
    ),
    "auth_legal_middle": MessageLookupByLibrary.simpleMessage(
      " and acknowledge our ",
    ),
    "auth_legal_prefix": MessageLookupByLibrary.simpleMessage(
      "By continuing, you agree to our ",
    ),
    "auth_legal_suffix": MessageLookupByLibrary.simpleMessage("."),
    "auth_privacy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "auth_scope_reassurance": MessageLookupByLibrary.simpleMessage(
      "Just sign in for now — we\'ll help you set things up next.",
    ),
    "auth_sign_in_error": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t sign you in. Please try again.",
    ),
    "auth_sign_out": MessageLookupByLibrary.simpleMessage("Sign out"),
    "auth_sign_out_error": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t sign you out. Please try again.",
    ),
    "auth_signing_in": m0,
    "auth_terms": MessageLookupByLibrary.simpleMessage("Terms"),
    "auth_title": MessageLookupByLibrary.simpleMessage("Sign in"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backlog": MessageLookupByLibrary.simpleMessage("Backlog"),
    "best_metacritic": MessageLookupByLibrary.simpleMessage("Best Metacritic"),
    "best_of_the_year": MessageLookupByLibrary.simpleMessage(
      "Best of the year",
    ),
    "browse": MessageLookupByLibrary.simpleMessage("Browse"),
    "browse_for_your_next_game": MessageLookupByLibrary.simpleMessage(
      "Browse the catalogue and line up what you play next.",
    ),
    "browse_games": MessageLookupByLibrary.simpleMessage("Browse games"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "clear_filters": MessageLookupByLibrary.simpleMessage("Clear filters"),
    "coming_soon": MessageLookupByLibrary.simpleMessage("Coming Soon"),
    "complete_onboarding_steps": MessageLookupByLibrary.simpleMessage(
      "Let\'s complete your quick onboarding steps.",
    ),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "completed_percentage": m1,
    "continue_with_discord": MessageLookupByLibrary.simpleMessage(
      "Continue with Discord",
    ),
    "continue_with_google": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "countdown_date_unannounced": MessageLookupByLibrary.simpleMessage(
      "Date to be announced",
    ),
    "countdown_days": MessageLookupByLibrary.simpleMessage("Days"),
    "countdown_hours": MessageLookupByLibrary.simpleMessage("Hrs"),
    "countdown_minutes": MessageLookupByLibrary.simpleMessage("Min"),
    "countdown_released": MessageLookupByLibrary.simpleMessage("Out now"),
    "countdown_time_remaining": m2,
    "critics_choice_title": MessageLookupByLibrary.simpleMessage(
      "Critics Choice Title",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "date_added": MessageLookupByLibrary.simpleMessage("Date added"),
    "date_range": MessageLookupByLibrary.simpleMessage("Date range"),
    "date_started": MessageLookupByLibrary.simpleMessage("Date started"),
    "delete_saved_game": MessageLookupByLibrary.simpleMessage(
      "Delete saved game",
    ),
    "delete_saved_game_description": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove your saved game? All your notes and progress will be lost.",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "details": MessageLookupByLibrary.simpleMessage("Details"),
    "developers": MessageLookupByLibrary.simpleMessage("Developers"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "dropped": MessageLookupByLibrary.simpleMessage("Dropped"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "error_results": MessageLookupByLibrary.simpleMessage(
      "Error retrieving results",
    ),
    "every_pick_without_a_genre_filter": MessageLookupByLibrary.simpleMessage(
      "Clear the genre filter to see every pick critics made this week.",
    ),
    "failed_to_load_countdown_game": MessageLookupByLibrary.simpleMessage(
      "Failed to load countdown game",
    ),
    "failed_to_load_critics_choice_reviews":
        MessageLookupByLibrary.simpleMessage(
          "Failed to load critics choice reviews",
        ),
    "failed_to_load_genre_preferences": MessageLookupByLibrary.simpleMessage(
      "Failed to load genre preferences",
    ),
    "failed_to_load_library_stats": MessageLookupByLibrary.simpleMessage(
      "Failed to load library stats",
    ),
    "failed_to_load_weekly_releases": MessageLookupByLibrary.simpleMessage(
      "Failed to load weekly releases",
    ),
    "failed_to_save_genre_preference": MessageLookupByLibrary.simpleMessage(
      "Failed to save genre preference",
    ),
    "failed_to_skip_genre_preferences": MessageLookupByLibrary.simpleMessage(
      "Failed to skip genre preferences",
    ),
    "featured": MessageLookupByLibrary.simpleMessage("Featured"),
    "featured_screen_title": MessageLookupByLibrary.simpleMessage(
      "Check out our featured lists of games, from most anticipated to the latest releases.",
    ),
    "featured_subtitle": MessageLookupByLibrary.simpleMessage(
      "Everything in one glance",
    ),
    "from": MessageLookupByLibrary.simpleMessage("From"),
    "games": MessageLookupByLibrary.simpleMessage("Games"),
    "games_screen_subtitle": MessageLookupByLibrary.simpleMessage(
      "Search for your favourite games here",
    ),
    "genre": MessageLookupByLibrary.simpleMessage("Genre"),
    "get_started": MessageLookupByLibrary.simpleMessage("Get started"),
    "group_task_created": MessageLookupByLibrary.simpleMessage(
      "Group task created",
    ),
    "hours_abbreviation": m3,
    "improve": MessageLookupByLibrary.simpleMessage("Improve"),
    "inProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "keep_it_short": MessageLookupByLibrary.simpleMessage("Keep it short"),
    "last_updated": MessageLookupByLibrary.simpleMessage("Last Updated"),
    "latest_releases": MessageLookupByLibrary.simpleMessage("Latest Releases"),
    "loading_game_release_title": MessageLookupByLibrary.simpleMessage(
      "Loading Game Release Title",
    ),
    "loading_game_title_placeholder": MessageLookupByLibrary.simpleMessage(
      "Loading Game Title",
    ),
    "logged_hours_of": m4,
    "look_further_ahead": MessageLookupByLibrary.simpleMessage(
      "Look further ahead",
    ),
    "mark_button": MessageLookupByLibrary.simpleMessage("+ Mark"),
    "mark_playing_now": MessageLookupByLibrary.simpleMessage(
      "Mark what you\'re playing now",
    ),
    "mark_something_playing": MessageLookupByLibrary.simpleMessage(
      "Mark something as playing",
    ),
    "metacritic_score": MessageLookupByLibrary.simpleMessage(
      "Metacritic score",
    ),
    "missed": MessageLookupByLibrary.simpleMessage("Missed"),
    "more_playing": m5,
    "most_anticipated": MessageLookupByLibrary.simpleMessage(
      "Most anticipated",
    ),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "new_and_trending": MessageLookupByLibrary.simpleMessage("New & Trending"),
    "new_releases_30_days": MessageLookupByLibrary.simpleMessage(
      "New releases last 30 days",
    ),
    "news": MessageLookupByLibrary.simpleMessage("News"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "no_game_in_progress": MessageLookupByLibrary.simpleMessage(
      "No game in progress",
    ),
    "no_games_saved": MessageLookupByLibrary.simpleMessage("No games saved"),
    "no_games_saved_description": MessageLookupByLibrary.simpleMessage(
      "Bookmark some games from the games or featured sections.",
    ),
    "no_group_task_created": MessageLookupByLibrary.simpleMessage(
      "No group task created",
    ),
    "no_pinned_tasks_desc": MessageLookupByLibrary.simpleMessage(
      "There are no pinned tasks",
    ),
    "not_started": MessageLookupByLibrary.simpleMessage("Not started"),
    "nothing_matches_yet": MessageLookupByLibrary.simpleMessage(
      "Nothing matches yet",
    ),
    "now_playing": MessageLookupByLibrary.simpleMessage("Now Playing"),
    "ok": MessageLookupByLibrary.simpleMessage("Ok"),
    "onHold": MessageLookupByLibrary.simpleMessage("On Hold"),
    "on_your_wishlist": MessageLookupByLibrary.simpleMessage(
      "On your wishlist",
    ),
    "only_10_group_tasks_allowed": MessageLookupByLibrary.simpleMessage(
      "Only a maximum of 10 group tasks are allowed.",
    ),
    "open_up_your_genres": MessageLookupByLibrary.simpleMessage(
      "Open up your genres",
    ),
    "ordering": MessageLookupByLibrary.simpleMessage("Ordering"),
    "pick_a_game_to_start_logging": MessageLookupByLibrary.simpleMessage(
      "Pick a game from your library and start logging hours.",
    ),
    "platforms": MessageLookupByLibrary.simpleMessage("Platforms"),
    "played_hours": m6,
    "playing": MessageLookupByLibrary.simpleMessage("Playing"),
    "playtime": MessageLookupByLibrary.simpleMessage("Playtime"),
    "please_enter_value": MessageLookupByLibrary.simpleMessage(
      "Please enter a value",
    ),
    "popular_last_year": MessageLookupByLibrary.simpleMessage(
      "Popular last year",
    ),
    "publishers": MessageLookupByLibrary.simpleMessage("Publishers"),
    "rageQuit": MessageLookupByLibrary.simpleMessage("Rage Quit"),
    "read_less": MessageLookupByLibrary.simpleMessage("Read less"),
    "read_more": MessageLookupByLibrary.simpleMessage("Read more"),
    "recently_changed": MessageLookupByLibrary.simpleMessage(
      "Recently changed",
    ),
    "release_date": MessageLookupByLibrary.simpleMessage("Release date"),
    "released_2_days_ago": MessageLookupByLibrary.simpleMessage(
      "Released 2 days ago",
    ),
    "remind": MessageLookupByLibrary.simpleMessage("Remind"),
    "reminder": MessageLookupByLibrary.simpleMessage("Reminder"),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "remove_step": MessageLookupByLibrary.simpleMessage("Remove step"),
    "remove_step_desc": m7,
    "remove_step_failed": MessageLookupByLibrary.simpleMessage(
      "Failed removing step",
    ),
    "removed_step": MessageLookupByLibrary.simpleMessage("Step removed"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "screenshots": MessageLookupByLibrary.simpleMessage("Screenshots"),
    "search_games": MessageLookupByLibrary.simpleMessage("Search games"),
    "search_saved_games": MessageLookupByLibrary.simpleMessage(
      "Search saved games",
    ),
    "select_platforms": MessageLookupByLibrary.simpleMessage(
      "Select Platforms",
    ),
    "set_title_here": MessageLookupByLibrary.simpleMessage("Set title here"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "show_every_pick": MessageLookupByLibrary.simpleMessage("Show every pick"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "start_a_countdown": MessageLookupByLibrary.simpleMessage(
      "Start a countdown",
    ),
    "step_added": MessageLookupByLibrary.simpleMessage("Step has been added"),
    "task_screenshots": MessageLookupByLibrary.simpleMessage(
      "Task screenshots",
    ),
    "task_statuses": MessageLookupByLibrary.simpleMessage("Task Statuses"),
    "tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
    "tasks_completed": MessageLookupByLibrary.simpleMessage("Tasks Completed"),
    "tasks_in_progress": MessageLookupByLibrary.simpleMessage(
      "Tasks in progress",
    ),
    "tasks_pinned": MessageLookupByLibrary.simpleMessage("Tasks pinned"),
    "this_week": MessageLookupByLibrary.simpleMessage("This Week"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "to": MessageLookupByLibrary.simpleMessage("To"),
    "toBuy": MessageLookupByLibrary.simpleMessage("To Buy"),
    "top_rated": MessageLookupByLibrary.simpleMessage("Top rated"),
    "total_games": MessageLookupByLibrary.simpleMessage("Total Games"),
    "tracker": MessageLookupByLibrary.simpleMessage("Tracker"),
    "try_widening_your_filters": MessageLookupByLibrary.simpleMessage(
      "Widen your filters and more of the catalogue comes into view.",
    ),
    "welcome_body_one": MessageLookupByLibrary.simpleMessage(
      "Every game you have played, beaten, dropped or shelved, in one place — 312 or 3.",
    ),
    "welcome_body_two": MessageLookupByLibrary.simpleMessage(
      "Track what you are waiting on and see the countdown to every release you care about.",
    ),
    "welcome_headline_one": MessageLookupByLibrary.simpleMessage(
      "TRACK EVERY GAME YOU\'VE EVER TOUCHED",
    ),
    "welcome_headline_two": MessageLookupByLibrary.simpleMessage(
      "AND KNOW WHAT DROPS NEXT",
    ),
    "welcome_to_gameyes": MessageLookupByLibrary.simpleMessage(
      "Welcome to GameYes 🎮",
    ),
    "wishlist": MessageLookupByLibrary.simpleMessage("Wishlist"),
    "wishlist_a_game_to_track_release": MessageLookupByLibrary.simpleMessage(
      "Wishlist an upcoming game and its release lands here.",
    ),
    "wishlist_button": MessageLookupByLibrary.simpleMessage("+ Wishlist"),
    "wishlist_upcoming_game": MessageLookupByLibrary.simpleMessage(
      "Wishlist an upcoming game",
    ),
  };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(provider) => "正在使用 ${provider} 登录";

  static String m1(percentage) => "已完成 ${percentage}%";

  static String m2(days, hours, minutes) =>
      "距发售还有 ${days} 天 ${hours} 小时 ${minutes} 分钟";

  static String m3(hours) => "${hours}小时";

  static String m4(logged, average) => "已记录 ${logged}小时，共 ${average}小时";

  static String m5(count) => "还有 ${count} 款正在玩";

  static String m6(hours) => "已游玩 ${hours}小时";

  static String m7(stepName) =>
      "Are you sure you want to remove step ${stepName}? This action cannot be undone";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "a_brief_description": MessageLookupByLibrary.simpleMessage(
      "A breif description",
    ),
    "about": MessageLookupByLibrary.simpleMessage("关于"),
    "active": MessageLookupByLibrary.simpleMessage("活跃"),
    "add_button": MessageLookupByLibrary.simpleMessage("+ 添加"),
    "add_game_played": MessageLookupByLibrary.simpleMessage("添加一款你玩过的游戏"),
    "add_group_task": MessageLookupByLibrary.simpleMessage("Add Group Task"),
    "add_step": MessageLookupByLibrary.simpleMessage("Add step"),
    "add_task": MessageLookupByLibrary.simpleMessage("Add task"),
    "add_to_library": MessageLookupByLibrary.simpleMessage("添加到游戏库"),
    "all_time_top_100": MessageLookupByLibrary.simpleMessage(
      "All time top 100",
    ),
    "app_title": MessageLookupByLibrary.simpleMessage("QuestLoggd"),
    "auth_lead": MessageLookupByLibrary.simpleMessage("登录以同步你的游戏库和发售追踪。"),
    "auth_legal_middle": MessageLookupByLibrary.simpleMessage("并知悉我们的"),
    "auth_legal_prefix": MessageLookupByLibrary.simpleMessage("继续即表示你同意我们的"),
    "auth_legal_suffix": MessageLookupByLibrary.simpleMessage("。"),
    "auth_privacy": MessageLookupByLibrary.simpleMessage("隐私政策"),
    "auth_scope_reassurance": MessageLookupByLibrary.simpleMessage(
      "现在只需登录，接下来我们会帮你完成设置。",
    ),
    "auth_sign_in_error": MessageLookupByLibrary.simpleMessage("无法登录，请重试。"),
    "auth_sign_out": MessageLookupByLibrary.simpleMessage("退出登录"),
    "auth_sign_out_error": MessageLookupByLibrary.simpleMessage("无法退出登录，请重试。"),
    "auth_signing_in": m0,
    "auth_terms": MessageLookupByLibrary.simpleMessage("条款"),
    "auth_title": MessageLookupByLibrary.simpleMessage("登录"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backlog": MessageLookupByLibrary.simpleMessage("待玩"),
    "best_metacritic": MessageLookupByLibrary.simpleMessage("最佳元评论家"),
    "best_of_the_year": MessageLookupByLibrary.simpleMessage(
      "Best of the year",
    ),
    "browse": MessageLookupByLibrary.simpleMessage("浏览"),
    "browse_for_your_next_game": MessageLookupByLibrary.simpleMessage(
      "浏览游戏库，安排你接下来要玩的游戏。",
    ),
    "browse_games": MessageLookupByLibrary.simpleMessage("浏览游戏"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "clear_filters": MessageLookupByLibrary.simpleMessage("清除筛选"),
    "coming_soon": MessageLookupByLibrary.simpleMessage("即将推出"),
    "complete_onboarding_steps": MessageLookupByLibrary.simpleMessage(
      "让我们完成快速入门步骤。",
    ),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "completed_percentage": m1,
    "continue_with_discord": MessageLookupByLibrary.simpleMessage(
      "使用 Discord 继续",
    ),
    "continue_with_google": MessageLookupByLibrary.simpleMessage(
      "使用 Google 继续",
    ),
    "countdown_date_unannounced": MessageLookupByLibrary.simpleMessage(
      "发售日期待公布",
    ),
    "countdown_days": MessageLookupByLibrary.simpleMessage("天"),
    "countdown_hours": MessageLookupByLibrary.simpleMessage("小时"),
    "countdown_minutes": MessageLookupByLibrary.simpleMessage("分钟"),
    "countdown_released": MessageLookupByLibrary.simpleMessage("现已推出"),
    "countdown_time_remaining": m2,
    "critics_choice_title": MessageLookupByLibrary.simpleMessage("媒体选择标题"),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "date_added": MessageLookupByLibrary.simpleMessage("Date added"),
    "date_range": MessageLookupByLibrary.simpleMessage("选日期"),
    "date_started": MessageLookupByLibrary.simpleMessage("Date started"),
    "delete_saved_game": MessageLookupByLibrary.simpleMessage(
      "Delete saved game",
    ),
    "delete_saved_game_description": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove your saved game? All your notes and progress will be lost.",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "details": MessageLookupByLibrary.simpleMessage("Details"),
    "developers": MessageLookupByLibrary.simpleMessage("游戏开发者"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "dropped": MessageLookupByLibrary.simpleMessage("弃坑"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "error_results": MessageLookupByLibrary.simpleMessage("获取结果失败"),
    "every_pick_without_a_genre_filter": MessageLookupByLibrary.simpleMessage(
      "清除类型筛选，就能看到本周媒体的全部推荐。",
    ),
    "failed_to_load_countdown_game": MessageLookupByLibrary.simpleMessage(
      "加载倒计时游戏失败",
    ),
    "failed_to_load_critics_choice_reviews":
        MessageLookupByLibrary.simpleMessage("加载媒体选择评测失败"),
    "failed_to_load_genre_preferences": MessageLookupByLibrary.simpleMessage(
      "加载类型偏好失败",
    ),
    "failed_to_load_library_stats": MessageLookupByLibrary.simpleMessage(
      "加载库统计信息失败",
    ),
    "failed_to_load_weekly_releases": MessageLookupByLibrary.simpleMessage(
      "加载每周发布失败",
    ),
    "failed_to_save_genre_preference": MessageLookupByLibrary.simpleMessage(
      "保存类型偏好失败",
    ),
    "failed_to_skip_genre_preferences": MessageLookupByLibrary.simpleMessage(
      "跳过类型偏好失败",
    ),
    "featured": MessageLookupByLibrary.simpleMessage("精选"),
    "featured_screen_title": MessageLookupByLibrary.simpleMessage("游戏天地，等你探索"),
    "featured_subtitle": MessageLookupByLibrary.simpleMessage(
      "Everything in one glance",
    ),
    "feed": MessageLookupByLibrary.simpleMessage("动态"),
    "from": MessageLookupByLibrary.simpleMessage("从"),
    "games_screen_subtitle": MessageLookupByLibrary.simpleMessage(
      "Search for your favourite games here",
    ),
    "genre": MessageLookupByLibrary.simpleMessage("风格"),
    "get_started": MessageLookupByLibrary.simpleMessage("开始使用"),
    "group_task_created": MessageLookupByLibrary.simpleMessage(
      "Group task created",
    ),
    "hours_abbreviation": m3,
    "improve": MessageLookupByLibrary.simpleMessage("Improve"),
    "inProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "keep_it_short": MessageLookupByLibrary.simpleMessage("Keep it short"),
    "last_updated": MessageLookupByLibrary.simpleMessage("Last Updated"),
    "latest_releases": MessageLookupByLibrary.simpleMessage("最新版本"),
    "library": MessageLookupByLibrary.simpleMessage("游戏库"),
    "loading_game_release_title": MessageLookupByLibrary.simpleMessage(
      "加载游戏发布标题",
    ),
    "loading_game_title_placeholder": MessageLookupByLibrary.simpleMessage(
      "加载游戏标题",
    ),
    "logged_hours_of": m4,
    "look_further_ahead": MessageLookupByLibrary.simpleMessage("看看更远的未来"),
    "mark_button": MessageLookupByLibrary.simpleMessage("+ 标记"),
    "mark_playing_now": MessageLookupByLibrary.simpleMessage("标记你现在正在玩的游戏"),
    "mark_something_playing": MessageLookupByLibrary.simpleMessage(
      "标记一些游戏为正在玩",
    ),
    "metacritic_score": MessageLookupByLibrary.simpleMessage("综合评分"),
    "missed": MessageLookupByLibrary.simpleMessage("Missed"),
    "more_playing": m5,
    "most_anticipated": MessageLookupByLibrary.simpleMessage("最受期待"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "new_and_trending": MessageLookupByLibrary.simpleMessage("New & Trending"),
    "new_releases_30_days": MessageLookupByLibrary.simpleMessage(
      "New releases last 30 days",
    ),
    "news": MessageLookupByLibrary.simpleMessage("News"),
    "next": MessageLookupByLibrary.simpleMessage("下一步"),
    "no_game_in_progress": MessageLookupByLibrary.simpleMessage("目前没有正在进行的游戏"),
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
    "nothing_matches_yet": MessageLookupByLibrary.simpleMessage("还没有匹配的结果"),
    "now_playing": MessageLookupByLibrary.simpleMessage("正在玩"),
    "ok": MessageLookupByLibrary.simpleMessage("Ok"),
    "onHold": MessageLookupByLibrary.simpleMessage("On Hold"),
    "on_your_wishlist": MessageLookupByLibrary.simpleMessage("在你的愿望单中"),
    "only_10_group_tasks_allowed": MessageLookupByLibrary.simpleMessage(
      "Only a maximum of 10 group tasks are allowed.",
    ),
    "open_up_your_genres": MessageLookupByLibrary.simpleMessage("放开你的类型偏好"),
    "ordering": MessageLookupByLibrary.simpleMessage("排序"),
    "pick_a_game_to_start_logging": MessageLookupByLibrary.simpleMessage(
      "从你的游戏库中选一款，开始记录时长。",
    ),
    "platforms": MessageLookupByLibrary.simpleMessage("主机选择"),
    "played_hours": m6,
    "playing": MessageLookupByLibrary.simpleMessage("在玩"),
    "playtime": MessageLookupByLibrary.simpleMessage("Playtime"),
    "please_enter_value": MessageLookupByLibrary.simpleMessage(
      "Please enter a value",
    ),
    "popular_last_year": MessageLookupByLibrary.simpleMessage(
      "Popular last year",
    ),
    "publishers": MessageLookupByLibrary.simpleMessage("出版商"),
    "rageQuit": MessageLookupByLibrary.simpleMessage("Rage Quit"),
    "read_less": MessageLookupByLibrary.simpleMessage("收起"),
    "read_more": MessageLookupByLibrary.simpleMessage("阅读全文"),
    "recently_changed": MessageLookupByLibrary.simpleMessage(
      "Recently changed",
    ),
    "release_date": MessageLookupByLibrary.simpleMessage("上线日期"),
    "released_2_days_ago": MessageLookupByLibrary.simpleMessage("2天前发布"),
    "remind": MessageLookupByLibrary.simpleMessage("提醒"),
    "reminder": MessageLookupByLibrary.simpleMessage("Reminder"),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "remove_step": MessageLookupByLibrary.simpleMessage("Remove step"),
    "remove_step_desc": m7,
    "remove_step_failed": MessageLookupByLibrary.simpleMessage(
      "Failed removing step",
    ),
    "removed_step": MessageLookupByLibrary.simpleMessage("Step removed"),
    "retry": MessageLookupByLibrary.simpleMessage("重试"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "screenshots": MessageLookupByLibrary.simpleMessage("截图"),
    "search_games": MessageLookupByLibrary.simpleMessage("搜索游戏"),
    "search_saved_games": MessageLookupByLibrary.simpleMessage(
      "Search saved games",
    ),
    "select_platforms": MessageLookupByLibrary.simpleMessage(
      "Select Platforms",
    ),
    "set_title_here": MessageLookupByLibrary.simpleMessage("Set title here"),
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "show_every_pick": MessageLookupByLibrary.simpleMessage("显示全部推荐"),
    "skip": MessageLookupByLibrary.simpleMessage("跳过"),
    "start_a_countdown": MessageLookupByLibrary.simpleMessage("开启一个倒计时"),
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
    "this_week": MessageLookupByLibrary.simpleMessage("本周"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "to": MessageLookupByLibrary.simpleMessage("到"),
    "toBuy": MessageLookupByLibrary.simpleMessage("To Buy"),
    "top_rated": MessageLookupByLibrary.simpleMessage("Top rated"),
    "total_games": MessageLookupByLibrary.simpleMessage("总游戏数"),
    "try_widening_your_filters": MessageLookupByLibrary.simpleMessage(
      "放宽筛选条件，就能看到更多游戏。",
    ),
    "welcome_body_one": MessageLookupByLibrary.simpleMessage(
      "你打通的、弃坑的、积灰的游戏，全都在一处 —— 312 款还是 3 款都一样。",
    ),
    "welcome_body_two": MessageLookupByLibrary.simpleMessage(
      "追踪你在等的游戏，看着倒计时一天一天逼近每一个发售日。",
    ),
    "welcome_headline_one": MessageLookupByLibrary.simpleMessage("追踪你玩过的每一款游戏"),
    "welcome_headline_two": MessageLookupByLibrary.simpleMessage("抢先知道下一款大作"),
    "welcome_to_gameyes": MessageLookupByLibrary.simpleMessage(
      "欢迎来到 GameYes 🎮",
    ),
    "wishlist": MessageLookupByLibrary.simpleMessage("心愿单"),
    "wishlist_a_game_to_track_release": MessageLookupByLibrary.simpleMessage(
      "将即将推出的游戏加入心愿单，它的发售就会出现在这里。",
    ),
    "wishlist_button": MessageLookupByLibrary.simpleMessage("+ 心愿单"),
    "wishlist_upcoming_game": MessageLookupByLibrary.simpleMessage(
      "将即将推出的游戏加入心愿单",
    ),
  };
}

import 'package:flutter/foundation.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor_config.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Console notes about live IGDB calls, for a developer running the dev build.
/// Silent everywhere else, and nothing here ever leaves the device.
abstract final class IgdbCallLog {
  // History is off because nothing can ever show it - the console is the only
  // reader.
  static final Talker _talker = Talker(
    settings: TalkerSettings(useHistory: false),
  );

  // Checked on every call, not once at startup. kDebugMode comes first so a
  // release build drops the rest of this file entirely.
  static bool get _isOn =>
      kDebugMode && FlavorConfig.instanceOrNull?.flavor == Flavor.dev;

  static void request({required String endpoint, required String query}) {
    _write(() => _talker.info('IGDB request -> $endpoint | $query'));
  }

  static void response(Object? body) {
    _write(() => _talker.info('IGDB response <-\n${trimToLineCap(body)}'));
  }

  static void failure(Object error, StackTrace stackTrace) {
    _write(() => _talker.error('IGDB call failed', error, stackTrace));
  }

  /// At most 50 lines of body, and a plain note when there was more, so a short
  /// log is never mistaken for a cut-off one.
  @visibleForTesting
  static String trimToLineCap(Object? body) {
    final text = '$body';
    final lines = text.split('\n');
    final cap = SupabaseIgdbProxyConstants.maxLogBodyLines;
    if (lines.length <= cap) return text;
    final kept = lines.take(cap).join('\n');
    return '$kept\n[cut short: showing $cap of ${lines.length} lines]';
  }

  static void _write(void Function() entry) {
    if (!_isOn) return;
    try {
      entry();
    } catch (_) {
      // A missing log line is always better than a failed IGDB call.
    }
  }
}

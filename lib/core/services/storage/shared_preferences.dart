import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class SharedPreference {
  Future<SharedPreferences> _getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Read value
  Future<T?> readValue<T>(String key) async {
    final prefs = await _getSharedPrefs();
    switch (T) {
      case int:
        return prefs.getInt(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      case const (List<String>):
        return prefs.getStringList(key) as T?;
      default:
        throw ArgumentError(StringConstants.sharedPrefTypeError);
    }
  }

  // Delete value
  void deleteValue(String key) async {
    final prefs = await _getSharedPrefs();
    await prefs.remove(key);
  }

  // Write value
  void writeValue<T>(String key, T value) async {
    final prefs = await _getSharedPrefs();
    switch (T) {
      case int:
        await prefs.setInt(key, value as int);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case String:
        await prefs.setString(key, value as String);
        break;
      case const (List<String>):
        await prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw ArgumentError(StringConstants.sharedPrefTypeError);
    }
  }
}

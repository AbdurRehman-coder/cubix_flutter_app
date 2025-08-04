import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const _key = 'isFirstTimeUser';

  /// Returns true only on first call (first app install)
  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();

    // If key already exists and is false, it's not first time
    if (prefs.containsKey(_key)) return false;

    // First time: set flag to false immediately
    await prefs.setBool(_key, false);
    return true;
  }
}

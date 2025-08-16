import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static const _firstTimeKey = 'isFirstTimeUser';
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_firstTimeKey)) return false;
    await prefs.setBool(_firstTimeKey, false);
    return true;
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

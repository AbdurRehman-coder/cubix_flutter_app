import 'dart:convert';

import 'package:cubix_app/features/auth/models/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static const _firstTimeKey = 'isFirstTimeUser';

  static const String _authKey = "user_model";

  /// Save auth response
  Future<void> saveLoggedUser(AuthResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(response.toJson());
    await prefs.setString(_authKey, jsonString);
  }

  /// Load auth response
  Future<AuthResponse?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_authKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return AuthResponse.fromJson(jsonMap);
  }

  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_firstTimeKey)) return false;
    await prefs.setBool(_firstTimeKey, false);
    return true;
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

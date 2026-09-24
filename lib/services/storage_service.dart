import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String userKey = 'user';
  static const String loggedInKey = 'loggedIn';

  // Save user account
  static Future<void> saveUser(
    Map<String, dynamic> user,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      userKey,
      jsonEncode(user),
    );
  }

  // Get user account
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data = prefs.getString(userKey);

    if (data == null) {
      return null;
    }

    return Map<String, dynamic>.from(
      jsonDecode(data),
    );
  }

  // Save login status
  static Future<void> setLoggedIn(
    bool value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      loggedInKey,
      value,
    );
  }

  // Check login status
  static Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          loggedInKey,
        ) ??
        false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      loggedInKey,
      false,
    );
  }
}
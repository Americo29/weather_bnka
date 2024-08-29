
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bnka/features/auth/domain/entities/user.dart';

class SharedPrefHelper {
  static const String _userKey = 'user';

  Future<void> setUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<UserEntity?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      return UserEntity.fromJson(jsonDecode(userString));
    } else {
      return null;
    }
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
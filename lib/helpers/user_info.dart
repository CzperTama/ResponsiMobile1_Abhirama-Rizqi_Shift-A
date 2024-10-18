import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  static const String _tokenKey = "token";
  static const String _userEmailKey = "userEmail";
  static const String _userIdKey = "userId";

  Future<bool> setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(_tokenKey, value);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_tokenKey);
  }

  Future<bool> setUserEmail(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(_userEmailKey, value);
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_userEmailKey);
  }

  Future<bool> setUserId(int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(_userIdKey, value);
  }

  Future<int?> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(_userIdKey);
  }

  Future<bool> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(_tokenKey);
    return pref.remove(_userIdKey);
  }
}
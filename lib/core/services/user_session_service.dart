import 'package:shared_preferences/shared_preferences.dart';

class UserSessionService {
  static const String _currentUserKey = 'current_user_uid';
  static const String fallbackUserId = 'user_123';

  Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey) ?? fallbackUserId;
  }

  Future<void> setCurrentUserId(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, uid);
  }

  Future<void> clearCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
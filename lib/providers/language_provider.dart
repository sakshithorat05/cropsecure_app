import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = NotifierProvider<LanguageNotifier, String>(() {
  return LanguageNotifier();
});

class LanguageNotifier extends Notifier<String> {
  static const String _langKey = 'selected_language';
  
  @override
  String build() {
    _loadLanguage(); // Fire and forget
    return 'en';     // Default
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_langKey);
    if (lang != null) {
      state = lang;
    }
  }

  Future<void> setLanguage(String languageCode) async {
    state = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, languageCode);
  }
}

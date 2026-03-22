import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = NotifierProvider<LocaleNotifier, String>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<String> {
  @override
  String build() {
    _loadLocale();
    return 'en';
  }

  static const String _key = 'selected_locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_key);
    if (savedCode != null) {
      state = savedCode;
    }
  }

  Future<void> setLocale(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, localeCode);
    state = localeCode;
  }
}

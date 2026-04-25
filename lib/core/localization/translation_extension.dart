import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/locale_provider.dart';
import './app_translations.dart';

extension TranslationExtension on String {
  String tr(WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final languageMap = AppTranslations.translations[locale] ?? AppTranslations.translations['en']!;
    return languageMap[this] ?? this;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulamanın aktif dilini yönetir ve kullanıcı tercihini kalıcı olarak saklar.
class LocaleProvider extends ChangeNotifier {
  static const String _prefsKey = 'app_locale';
  static const Locale _defaultLocale = Locale('en');
  static const Locale _turkishLocale = Locale('tr');

  LocaleProvider._(this._locale, this._prefs);

  final SharedPreferences _prefs;
  Locale _locale;

  Locale get locale => _locale;

  /// Kayıtlı bir tercih varsa onu kullanır. Yoksa cihazın sistem diline göre
  /// karar verir: cihaz Türkçe ise Türkçe, aksi halde (İngilizce dahil tüm
  /// diğer diller) varsayılan olarak İngilizce seçilir.
  static Future<LocaleProvider> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_prefsKey);

    Locale initialLocale;
    if (savedLanguageCode != null) {
      initialLocale = Locale(savedLanguageCode);
    } else {
      final deviceLanguageCode =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      initialLocale = deviceLanguageCode == _turkishLocale.languageCode
          ? _turkishLocale
          : _defaultLocale;
    }

    return LocaleProvider._(initialLocale, prefs);
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs.setString(_prefsKey, locale.languageCode);
    notifyListeners();
  }
}

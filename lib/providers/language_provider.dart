import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _appLocale;

  LanguageProvider(String? code)
      : _appLocale = code != null ? Locale(code) : const Locale('en');

  Locale get appLocale => _appLocale;

  Future<void> changeLanguage(Locale newLocale) async {
    if (_appLocale == newLocale) return;
    _appLocale = newLocale;

    // Save the preference to device storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);

    notifyListeners();
  }
}
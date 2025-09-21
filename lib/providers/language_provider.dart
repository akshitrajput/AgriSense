import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _appLocale = const Locale('en'); // Default to English

  Locale get appLocale => _appLocale;

  void changeLanguage(Locale newLocale) {
    if (_appLocale == newLocale) return;
    _appLocale = newLocale;
    notifyListeners();
  }
}
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_language.dart';

class AppLanguageProvider extends ChangeNotifier {
  AppLanguageProvider() {
    _loadLanguage();
  }

  static const String _storageKey = 'app_language';

  AppLanguage _currentLanguage = AppLanguage.portuguese;
  bool _isLoaded = false;

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isLoaded => _isLoaded;
  Locale get locale => _currentLanguage == AppLanguage.libras
      ? const Locale('pt')
      : Locale(_currentLanguage.code);

  Future<void> _loadLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final storedCode = preferences.getString(_storageKey);

    if (storedCode != null) {
      _currentLanguage = AppLanguage.values.firstWhere(
        (language) => language.code == storedCode,
        orElse: () => AppLanguage.portuguese,
      );
    } else {
      _currentLanguage = AppLanguage.portuguese;
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;

    _currentLanguage = language;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, language.code);
  }
}

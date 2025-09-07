import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_base_repository.dart';

class LanguageRepository implements LanguageBaseRepository {
  final SharedPreferences _sharedPreferences;

  LanguageRepository({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  static const String _key = 'Language_';

  @override
  Future<Locale> getLocale() async {
    final String? code = _sharedPreferences.getString(_key);
    if (code == null) return const Locale('en');
    // Normalize legacy 'vn' to 'vi'
    final normalized = code == 'vn' ? 'vi' : code;
    return Locale(normalized);
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _sharedPreferences.setString(_key, locale.languageCode);
  }
}

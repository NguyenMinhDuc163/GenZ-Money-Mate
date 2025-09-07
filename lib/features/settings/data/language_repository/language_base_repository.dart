import 'package:flutter/material.dart';

abstract class LanguageBaseRepository {
  Future<Locale> getLocale();
  Future<void> setLocale(Locale locale);
}

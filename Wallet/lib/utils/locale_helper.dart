import 'package:dinari_wallet/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';

const String selectedLocaleKey = "selectedLocaleCode";

// save user language preference
Future<Locale> setUserPreferredLocale(String languageCode) async {
  await  SharedPref().saveSingleString(selectedLocaleKey, languageCode);
  return _locale(languageCode);
}

// retrieve user language preference if any or default to 'sw'
Future<Locale> getUserPreferredLocale() async {
  String locale =
      await  SharedPref().readSingleString(selectedLocaleKey) ?? 'en';
  return _locale(locale);
}

Locale _locale(String languageCode) {
  return languageCode.isNotEmpty ? Locale(languageCode, '') : const Locale('en', '');
}
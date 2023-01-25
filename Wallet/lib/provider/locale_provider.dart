import 'package:dinari_wallet/utils/locale_helper.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  void changeLanguage(String languageCode) async {
    final locale = await setUserPreferredLocale(languageCode);
    _locale = locale;
    notifyListeners();
  }

  void getLocale() async {
    final locale = await getUserPreferredLocale();
    _locale = locale;
  }
}
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key.toString());

    if (data != null) {
      return data;
    } else {
      return null;
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  saveBoolean(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> readBoolean(String key) async {
    bool _result = true;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(key) != null) {
      _result = prefs.getBool(key);
    }

    return _result;
  }

  //////
  readSingleString(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    return data;
  }

  saveSingleString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  
}